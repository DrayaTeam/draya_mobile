import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:flutter/material.dart";

class RichMarkdownViewer extends StatelessWidget {
  final String markdownContent;

  const RichMarkdownViewer({
    super.key,
    required this.markdownContent,
  });

  @override
  Widget build(BuildContext context) {
    final lines = markdownContent.split("\n");
    final List<Widget> widgets = [];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();

      if (line.isEmpty) {
        widgets.add(const SizedBox(height: 8));
        continue;
      }

      if (line.startsWith("### ")) {
        widgets.add(
          Padding(
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
                    _stripMarkdown(line.substring(4)),
                    style: AppTextStyles.h4.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (line.startsWith("## ")) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 18, bottom: 8),
            child: Text(
              _stripMarkdown(line.substring(3)),
              style: AppTextStyles.h3.copyWith(
                color: AppColors.ai900,
                fontWeight: FontWeight.w900,
                fontSize: 17,
              ),
            ),
          ),
        );
      } else if (line.startsWith("# ")) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: Text(
              _stripMarkdown(line.substring(2)),
              style: AppTextStyles.h2.copyWith(
                color: AppColors.primary900,
                fontWeight: FontWeight.w900,
                fontSize: 19,
              ),
            ),
          ),
        );
      } else if (line.startsWith("---") || line.startsWith("***")) {
        widgets.add(
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: AppColors.border, thickness: 1),
          ),
        );
      } else if (line.startsWith("> ")) {
        widgets.add(
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.ai50,
              borderRadius: BorderRadius.circular(12),
              border: const Border(
                right: BorderSide(color: AppColors.ai500, width: 4),
              ),
            ),
            child: Text(
              _stripMarkdown(line.substring(2)),
              style: AppTextStyles.body.copyWith(
                color: AppColors.ai900,
                fontStyle: FontStyle.italic,
                fontSize: 13,
              ),
            ),
          ),
        );
      } else if (line.startsWith("- ") || line.startsWith("* ")) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 6, left: 6, right: 2),
                  child: Icon(
                    Icons.circle,
                    size: 6,
                    color: AppColors.ai700,
                  ),
                ),
                Expanded(
                  child: _buildRichText(line.substring(2)),
                ),
              ],
            ),
          ),
        );
      } else if (RegExp(r"^\d+\.\s").hasMatch(line)) {
        final match = RegExp(r"^(\d+)\.\s(.*)").firstMatch(line);
        final num = match?.group(1) ?? "•";
        final content = match?.group(2) ?? line;

        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.ai100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    num,
                    style: const TextStyle(
                      color: AppColors.ai700,
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildRichText(content),
                ),
              ],
            ),
          ),
        );
      } else {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: _buildRichText(line),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _buildRichText(String text) {
    final spans = <InlineSpan>[];
    final regExp = RegExp(r"(\*\*[^*]+\*\*|\*[^*]+\*|`[^`]+`)");
    final matches = regExp.allMatches(text);

    int currentIndex = 0;

    for (final match in matches) {
      if (match.start > currentIndex) {
        spans.add(
          TextSpan(
            text: text.substring(currentIndex, match.start),
            style: AppTextStyles.body.copyWith(
              color: AppColors.textPrimary,
              fontSize: 13.5,
              height: 1.6,
            ),
          ),
        );
      }

      final matchedText = match.group(0)!;
      if (matchedText.startsWith("**") && matchedText.endsWith("**")) {
        spans.add(
          TextSpan(
            text: matchedText.substring(2, matchedText.length - 2),
            style: AppTextStyles.body.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
              height: 1.6,
            ),
          ),
        );
      } else if (matchedText.startsWith("*") && matchedText.endsWith("*")) {
        spans.add(
          TextSpan(
            text: matchedText.substring(1, matchedText.length - 1),
            style: AppTextStyles.body.copyWith(
              color: AppColors.textPrimary,
              fontStyle: FontStyle.italic,
              fontSize: 13.5,
              height: 1.6,
            ),
          ),
        );
      } else if (matchedText.startsWith("`") && matchedText.endsWith("`")) {
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
                matchedText.substring(1, matchedText.length - 1),
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
      }

      currentIndex = match.end;
    }

    if (currentIndex < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(currentIndex),
          style: AppTextStyles.body.copyWith(
            color: AppColors.textPrimary,
            fontSize: 13.5,
            height: 1.6,
          ),
        ),
      );
    }

    return Text.rich(
      TextSpan(children: spans),
      style: const TextStyle(height: 1.6),
    );
  }

  String _stripMarkdown(String text) {
    return text.replaceAll("**", "").replaceAll("*", "").replaceAll("`", "");
  }
}
