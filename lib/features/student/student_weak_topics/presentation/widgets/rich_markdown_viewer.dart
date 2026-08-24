import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

class RichMarkdownViewer extends StatelessWidget {
  final String markdownContent;

  const RichMarkdownViewer({
    super.key,
    required this.markdownContent,
  });

  static final RegExp _bulletRegex = RegExp(r"^(\s*)(?:[-*•])\s+(.*)$");
  static final RegExp _numberedRegex = RegExp(r"^(\s*)(\d+)[.)]\s+(.*)$");
  static final RegExp _checkboxRegex = RegExp(
    r"^(\s*)[-*]\s+\[( |x|X)\]\s+(.*)$",
  );

  @override
  Widget build(BuildContext context) {
    // AI revision content is generated in English; force LTR layout even
    // when the surrounding app shell is RTL.
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _parseBlocks(markdownContent),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Block parsing
  // ---------------------------------------------------------------------------

  List<Widget> _parseBlocks(String content) {
    final lines = content.split("\n");
    final blocks = <Widget>[];

    int i = 0;
    while (i < lines.length) {
      final line = lines[i];
      final trimmed = line.trim();

      if (trimmed.isEmpty) {
        if (blocks.isNotEmpty) blocks.add(const SizedBox(height: 10));
        i++;
        continue;
      }

      // Fenced code block.
      if (trimmed.startsWith("```")) {
        final buffer = StringBuffer();
        i++;
        while (i < lines.length && !lines[i].trim().startsWith("```")) {
          buffer.writeln(lines[i]);
          i++;
        }
        i++; // Skip closing fence.
        blocks.add(_buildCodeBlock(buffer.toString().trimRight()));
        continue;
      }

      // Table block.
      if (trimmed.startsWith("|") && trimmed.endsWith("|")) {
        final rows = <List<String>>[];
        while (i < lines.length) {
          final rowLine = lines[i].trim();
          if (!rowLine.startsWith("|")) break;
          final cells = rowLine
              .split("|")
              .sublist(
                1,
                rowLine.endsWith("|") ? rowLine.split("|").length - 1 : null,
              )
              .map((c) => c.trim())
              .toList();
          // Skip separator rows like |---|---|.
          final isSeparator =
              cells.isNotEmpty &&
              cells.every((c) => RegExp(r"^:?-{2,}:?$").hasMatch(c));
          if (!isSeparator && cells.any((c) => c.isNotEmpty)) {
            rows.add(cells);
          }
          i++;
        }
        if (rows.isNotEmpty) blocks.add(_buildTable(rows));
        continue;
      }

      // Horizontal rule.
      if (RegExp(r"^(---+|\*\*\*+|___+)\s*$").hasMatch(trimmed)) {
        blocks.add(
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: AppColors.borderStrong, thickness: 1),
          ),
        );
        i++;
        continue;
      }

      // Headings.
      final headingMatch = RegExp(r"^(#{1,4})\s+(.*)$").firstMatch(trimmed);
      if (headingMatch != null) {
        blocks.add(
          _buildHeading(
            level: headingMatch.group(1)!.length,
            text: headingMatch.group(2)!,
          ),
        );
        i++;
        continue;
      }

      // Blockquote group (consecutive quote lines merge into one callout).
      if (trimmed.startsWith(">")) {
        final quotes = <String>[];
        while (i < lines.length) {
          final l = lines[i].trim();
          if (!l.startsWith(">")) break;
          quotes.add(l.replaceFirst(RegExp(r"^>\s?"), ""));
          i++;
        }
        blocks.add(_buildBlockquote(quotes.join("\n")));
        continue;
      }

      // List group (bullets, numbered, checkboxes — mixed runs are grouped).
      final isListItem =
          _bulletRegex.hasMatch(line) ||
          _numberedRegex.hasMatch(line) ||
          _checkboxRegex.hasMatch(line);
      if (isListItem) {
        final items = <_ListItem>[];
        while (i < lines.length) {
          final l = lines[i];
          if (l.trim().isEmpty) {
            // Peek: only consume the gap if the list continues after it.
            final next = i + 1 < lines.length ? lines[i + 1] : "";
            if (_bulletRegex.hasMatch(next) ||
                _numberedRegex.hasMatch(next) ||
                _checkboxRegex.hasMatch(next)) {
              i++;
              continue;
            }
            break;
          }

          var match = _checkboxRegex.firstMatch(l);
          if (match != null) {
            items.add(
              _ListItem(
                indent: _indentLevel(match.group(1)!),
                type: _ListItemType.checkbox,
                checked: match.group(2)!.toLowerCase() == "x",
                text: match.group(3)!,
              ),
            );
            i++;
            continue;
          }

          match = _numberedRegex.firstMatch(l);
          if (match != null) {
            items.add(
              _ListItem(
                indent: _indentLevel(match.group(1)!),
                type: _ListItemType.numbered,
                number: match.group(2)!,
                text: match.group(3)!,
              ),
            );
            i++;
            continue;
          }

          match = _bulletRegex.firstMatch(l);
          if (match != null) {
            items.add(
              _ListItem(
                indent: _indentLevel(match.group(1)!),
                type: _ListItemType.bullet,
                text: match.group(2)!,
              ),
            );
            i++;
            continue;
          }
          break;
        }
        if (items.isNotEmpty) blocks.add(_buildListCard(items));
        continue;
      }

      // Paragraph: merge consecutive plain-text lines.
      final paragraph = <String>[trimmed];
      i++;
      while (i < lines.length) {
        final next = lines[i].trim();
        if (next.isEmpty ||
            next.startsWith("#") ||
            next.startsWith(">") ||
            next.startsWith("```") ||
            next.startsWith("|") ||
            _bulletRegex.hasMatch(lines[i]) ||
            _numberedRegex.hasMatch(lines[i]) ||
            _checkboxRegex.hasMatch(lines[i]) ||
            RegExp(r"^(---+|\*\*\*+|___+)\s*$").hasMatch(next)) {
          break;
        }
        paragraph.add(next);
        i++;
      }
      blocks.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: _buildRichText(paragraph.join(" ")),
        ),
      );
    }

    return blocks;
  }

  int _indentLevel(String leadingWhitespace) {
    var width = 0;
    for (final char in leadingWhitespace.split("")) {
      width += char == "\t" ? 4 : 1;
    }
    return width ~/ 2;
  }

  // ---------------------------------------------------------------------------
  // Block builders
  // ---------------------------------------------------------------------------

  Widget _buildHeading({required int level, required String text}) {
    switch (level) {
      case 1:
        return Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 10),
          child: Text(
            _stripMarkdown(text),
            style: AppTextStyles.h2.copyWith(
              color: AppColors.primary900,
              fontWeight: FontWeight.w900,
              fontSize: 19,
              height: 1.35,
            ),
          ),
        );
      case 2:
        return Padding(
          padding: const EdgeInsets.only(top: 18, bottom: 8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 8),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.border, width: 1.5),
              ),
            ),
            child: Text(
              _stripMarkdown(text),
              style: AppTextStyles.h3.copyWith(
                color: AppColors.ai900,
                fontWeight: FontWeight.w900,
                fontSize: 17,
                height: 1.35,
              ),
            ),
          ),
        );
      case 3:
        return Padding(
          padding: const EdgeInsets.only(top: 14, bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 3.5,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.ai700,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _stripMarkdown(text),
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      default: // Level 4.
        return Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 5),
          child: Text(
            _stripMarkdown(text),
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
              height: 1.4,
            ),
          ),
        );
    }
  }

  Widget _buildBlockquote(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.ai50,
        borderRadius: BorderRadius.circular(12),
        border: const BorderDirectional(
          start: BorderSide(color: AppColors.ai500, width: 4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2, left: 8),
            child: Icon(
              Icons.format_quote_rounded,
              size: 16,
              color: AppColors.ai500,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: text
                  .split("\n")
                  .where((l) => l.trim().isNotEmpty)
                  .map(
                    (l) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: _buildRichText(l, italic: true),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListCard(List<_ListItem> items) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.backgroundMuted,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int j = 0; j < items.length; j++) ...[
            _buildListItem(items[j]),
            if (j < items.length - 1) const SizedBox(height: 6),
          ],
        ],
      ),
    );
  }

  Widget _buildListItem(_ListItem item) {
    final indentPadding = item.indent * 18.0;

    Widget marker;
    if (item.type == _ListItemType.numbered) {
      marker = Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.ai100,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          item.number!,
          style: const TextStyle(
            color: AppColors.ai700,
            fontWeight: FontWeight.w800,
            fontSize: 11,
          ),
        ),
      );
    } else if (item.type == _ListItemType.checkbox) {
      marker = Icon(
        item.checked
            ? Icons.check_box_rounded
            : Icons.check_box_outline_blank_rounded,
        size: 18,
        color: item.checked ? AppColors.success : AppColors.textDisabled,
      );
    } else if (item.indent > 0) {
      marker = Container(
        width: 6,
        height: 6,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.ai500, width: 1.5),
        ),
      );
    } else {
      marker = const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Icon(Icons.circle, size: 6, color: AppColors.ai700),
      );
    }

    return Padding(
      padding: EdgeInsetsDirectional.only(start: indentPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: marker,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildRichText(
              item.text,
              strike: item.type == _ListItemType.checkbox && item.checked,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeBlock(String code) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 14, 44, 14),
            child: Text(
              code,
              style: const TextStyle(
                fontFamily: "monospace",
                fontSize: 12.5,
                height: 1.6,
                color: Color(0xFFE2E8F0),
              ),
            ),
          ),
          PositionedDirectional(
            top: 4,
            end: 4,
            child: IconButton(
              icon: const Icon(
                Icons.copy_rounded,
                size: 15,
                color: Color(0xFF94A3B8),
              ),
              tooltip: "نسخ الكود",
              constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
              padding: EdgeInsets.zero,
              onPressed: () => Clipboard.setData(ClipboardData(text: code)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(List<List<String>> rows) {
    final columnCount = rows
        .map((r) => r.length)
        .reduce((a, b) => a > b ? a : b);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderStrong),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (int r = 0; r < rows.length; r++)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: r == 0 ? AppColors.ai50 : Colors.white,
                border: Border(
                  bottom: r < rows.length - 1
                      ? const BorderSide(color: AppColors.border)
                      : BorderSide.none,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int c = 0; c < columnCount; c++) ...[
                    if (c > 0) const SizedBox(width: 10),
                    Expanded(
                      child: r == 0
                          ? Text(
                              _stripMarkdown(
                                c < rows[r].length ? rows[r][c] : "",
                              ),
                              style: const TextStyle(
                                color: AppColors.ai900,
                                fontWeight: FontWeight.w800,
                                fontSize: 12.5,
                                height: 1.5,
                              ),
                            )
                          : _buildRichText(
                              c < rows[r].length ? rows[r][c] : "",
                            ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Inline parsing
  // ---------------------------------------------------------------------------

  static final RegExp _inlineRegex = RegExp(
    r"(\*\*[^*]+\*\*|__[^_]+__|\*[^*]+\*|_[^_]+_|~~[^~]+~~|`[^`]+`|\[[^\]]+\]\([^)]+\))",
  );

  Widget _buildRichText(
    String text, {
    bool italic = false,
    bool strike = false,
  }) {
    final spans = <InlineSpan>[];
    final matches = _inlineRegex.allMatches(text);

    int currentIndex = 0;

    TextStyle baseStyle({
      bool bold = false,
      bool inlineItalic = false,
      bool inlineStrike = false,
    }) {
      return AppTextStyles.body.copyWith(
        color: inlineStrike ? AppColors.textSecondary : AppColors.textPrimary,
        fontWeight: bold ? FontWeight.w800 : FontWeight.w400,
        fontStyle: italic || inlineItalic ? FontStyle.italic : FontStyle.normal,
        fontSize: 13.5,
        height: 1.6,
        decoration: inlineStrike ? TextDecoration.lineThrough : null,
        decorationColor: AppColors.textDisabled,
      );
    }

    void addPlain(int start, int end) {
      if (end > start) {
        spans.add(TextSpan(text: text.substring(start, end)));
      }
    }

    for (final match in matches) {
      addPlain(currentIndex, match.start);

      final matched = match.group(0)!;
      if ((matched.startsWith("**") && matched.endsWith("**")) ||
          (matched.startsWith("__") && matched.endsWith("__"))) {
        spans.add(
          TextSpan(
            text: matched.substring(2, matched.length - 2),
            style: baseStyle(bold: true),
          ),
        );
      } else if (matched.startsWith("~~") && matched.endsWith("~~")) {
        spans.add(
          TextSpan(
            text: matched.substring(2, matched.length - 2),
            style: baseStyle(inlineStrike: true),
          ),
        );
      } else if (matched.startsWith("`") && matched.endsWith("`")) {
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Text(
                matched.substring(1, matched.length - 1),
                style: const TextStyle(
                  fontFamily: "monospace",
                  color: Color(0xFF0F172A),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        );
      } else if (matched.startsWith("[")) {
        final linkMatch = RegExp(
          r"^\[([^\]]+)\]\(([^)]+)\)$",
        ).firstMatch(matched);
        final label = linkMatch?.group(1) ?? matched;
        final url = linkMatch?.group(2) ?? "";
        spans.add(
          TextSpan(
            text: label,
            style: baseStyle().copyWith(
              color: AppColors.ai700,
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.ai300,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Clipboard.setData(ClipboardData(text: url));
              },
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: matched.substring(1, matched.length - 1),
            style: baseStyle(inlineItalic: true),
          ),
        );
      }

      currentIndex = match.end;
    }

    addPlain(currentIndex, text.length);

    return Text.rich(
      TextSpan(
        children: spans,
        style: baseStyle().copyWith(
          decoration: strike ? TextDecoration.lineThrough : TextDecoration.none,
          decorationColor: AppColors.textDisabled,
        ),
      ),
    );
  }

  String _stripMarkdown(String text) {
    return text
        .replaceAll("**", "")
        .replaceAll("__", "")
        .replaceAll("*", "")
        .replaceAll("`", "")
        .replaceAll("~~", "");
  }
}

enum _ListItemType { bullet, numbered, checkbox }

class _ListItem {
  final int indent;
  final _ListItemType type;
  final String text;
  final String? number;
  final bool checked;

  const _ListItem({
    required this.indent,
    required this.type,
    required this.text,
    this.number,
    this.checked = false,
  });
}
