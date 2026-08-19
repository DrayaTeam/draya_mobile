import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_text_styles.dart';
import 'package:draya_mobile/features/student/student_materials/domain/entity/classroom_section.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SectionExpandableCard extends StatefulWidget {
  final ClassroomSection section;
  final bool initialExpanded;
  final bool isReadOnly;
  final String? openingId;
  final void Function(SectionDocument doc)? onOpenDocument;
  final void Function(SectionDocument doc)? onDownloadDocument;
  final void Function(SectionVideo video)? onOpenVideo;
  final void Function(SectionExam exam)? onStartExam;

  const SectionExpandableCard({
    super.key,
    required this.section,
    this.initialExpanded = true,
    this.isReadOnly = false,
    this.openingId,
    this.onOpenDocument,
    this.onDownloadDocument,
    this.onOpenVideo,
    this.onStartExam,
  });

  @override
  State<SectionExpandableCard> createState() => _SectionExpandableCardState();
}

class _SectionExpandableCardState extends State<SectionExpandableCard>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initialExpanded;
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final section = widget.section;
    final totalCount = section.totalItemsCount;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _isExpanded ? AppColors.primary300 : AppColors.border,
          width: _isExpanded ? 1.4 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            InkWell(
              onTap: _toggleExpand,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: _isExpanded
                            ? AppColors.primary
                            : AppColors.primary50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _isExpanded
                              ? AppColors.primary
                              : AppColors.primary200,
                        ),
                      ),
                      child: Icon(
                        Icons.folder_special_rounded,
                        color: _isExpanded ? Colors.white : AppColors.primary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            section.title,
                            style: AppTextStyles.h5.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                          if (section.description != null &&
                              section.description!.trim().isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              section.description!.trim(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              if (section.documents.isNotEmpty)
                                _BadgePill(
                                  icon: Icons.description_outlined,
                                  text: '${section.documents.length} مستند',
                                  color: AppColors.error,
                                ),
                              if (section.videos.isNotEmpty)
                                _BadgePill(
                                  icon: Icons.play_circle_outline_rounded,
                                  text: '${section.videos.length} فيديو',
                                  color: AppColors.ai700,
                                ),
                              if (section.exams.isNotEmpty)
                                _BadgePill(
                                  icon: Icons.quiz_outlined,
                                  text: '${section.exams.length} اختبار',
                                  color: AppColors.amber,
                                ),
                              if (totalCount == 0)
                                const _BadgePill(
                                  icon: Icons.info_outline_rounded,
                                  text: 'لا توجد مواد',
                                  color: AppColors.foregroundMuted,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOutCubic,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundSecondary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.foregroundMuted,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Divider(color: AppColors.border, height: 1),
                    const SizedBox(height: 12),
                    if (totalCount == 0)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: Text(
                            'لا توجد مواد تعليمية مضافة في هذا القسم حالياً.',
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      )
                    else ...[
                      // Documents
                      if (section.documents.isNotEmpty) ...[
                        const _SectionSubHeader(
                          title: 'المستندات والملفات',
                          icon: Icons.picture_as_pdf_rounded,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: 8),
                        ...section.documents.map((doc) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _DocumentTile(
                              document: doc,
                              isReadOnly: widget.isReadOnly,
                              isOpening: widget.openingId == doc.id,
                              onOpen: () => widget.onOpenDocument?.call(doc),
                              onDownload: () =>
                                  widget.onDownloadDocument?.call(doc),
                            ),
                          );
                        }),
                        const SizedBox(height: 8),
                      ],

                      // Videos
                      if (section.videos.isNotEmpty) ...[
                        const _SectionSubHeader(
                          title: 'الفيديوهات والمحاضرات',
                          icon: Icons.play_circle_filled_rounded,
                          color: AppColors.ai700,
                        ),
                        const SizedBox(height: 8),
                        ...section.videos.map((vid) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _VideoTile(
                              video: vid,
                              isReadOnly: widget.isReadOnly,
                              isOpening: widget.openingId == vid.id,
                              onOpen: () => widget.onOpenVideo?.call(vid),
                            ),
                          );
                        }),
                        const SizedBox(height: 8),
                      ],

                      // Exams
                      if (section.exams.isNotEmpty) ...[
                        const _SectionSubHeader(
                          title: 'الاختبارات والتقييمات',
                          icon: Icons.quiz_rounded,
                          color: AppColors.amber,
                        ),
                        const SizedBox(height: 8),
                        ...section.exams.map((exam) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _ExamTile(
                              exam: exam,
                              isReadOnly: widget.isReadOnly,
                              onStart: () => widget.onStartExam?.call(exam),
                            ),
                          );
                        }),
                      ],
                    ],
                  ],
                ),
              ),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionSubHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _SectionSubHeader({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          title,
          style: AppTextStyles.label.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _BadgePill extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _BadgePill({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 3),
          Text(
            text,
            style: AppTextStyles.label.copyWith(
              color: color,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _DocumentTile extends StatelessWidget {
  final SectionDocument document;
  final bool isReadOnly;
  final bool isOpening;
  final VoidCallback? onOpen;
  final VoidCallback? onDownload;

  const _DocumentTile({
    required this.document,
    required this.isReadOnly,
    required this.isOpening,
    this.onOpen,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMM yyyy', 'ar');
    final dateStr = dateFormat.format(document.createdAt);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.picture_as_pdf_rounded,
              color: AppColors.error,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${document.materialType} • $dateStr',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (isReadOnly) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.lock_outline_rounded,
                    size: 13,
                    color: AppColors.foregroundMuted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'مغلق',
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.foregroundMuted,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            if (document.hasFileUrl) ...[
              if (onDownload != null)
                IconButton(
                  onPressed: onDownload,
                  iconSize: 18,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  tooltip: 'تحميل',
                  icon: const Icon(
                    Icons.download_rounded,
                    color: AppColors.primary,
                  ),
                ),
              const SizedBox(width: 4),
            ],
            SizedBox(
              height: 32,
              child: ElevatedButton(
                onPressed: isOpening ? null : onOpen,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: isOpening
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'عرض',
                        style: AppTextStyles.button.copyWith(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _VideoTile extends StatelessWidget {
  final SectionVideo video;
  final bool isReadOnly;
  final bool isOpening;
  final VoidCallback? onOpen;

  const _VideoTile({
    required this.video,
    required this.isReadOnly,
    required this.isOpening,
    this.onOpen,
  });

  String _formatDuration(int? seconds) {
    if (seconds == null || seconds <= 0) return '';
    final minutes = seconds ~/ 60;
    final remainingSecs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSecs.toString().padLeft(2, '0')} دقيقة';
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMM yyyy', 'ar');
    final dateStr = dateFormat.format(video.createdAt);
    final durationStr = _formatDuration(video.videoDurationInSeconds);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.ai700.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.play_circle_filled_rounded,
              color: AppColors.ai700,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  durationStr.isNotEmpty
                      ? '$durationStr • $dateStr'
                      : 'فيديو • $dateStr',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (isReadOnly) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.lock_outline_rounded,
                    size: 13,
                    color: AppColors.foregroundMuted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'مغلق',
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.foregroundMuted,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            SizedBox(
              height: 32,
              child: ElevatedButton.icon(
                onPressed: isOpening ? null : onOpen,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.ai700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                icon: isOpening
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.play_arrow_rounded, size: 16),
                label: Text(
                  'مشاهدة',
                  style: AppTextStyles.button.copyWith(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ExamTile extends StatelessWidget {
  final SectionExam exam;
  final bool isReadOnly;
  final VoidCallback? onStart;

  const _ExamTile({
    required this.exam,
    this.isReadOnly = false,
    this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMM yyyy', 'ar');
    final dateStr = dateFormat.format(exam.createdAt);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.amber.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.quiz_rounded,
              color: AppColors.amber,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exam.topic,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${exam.questionsCount} سؤال • $dateStr',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (isReadOnly) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.lock_outline_rounded,
                    size: 13,
                    color: AppColors.foregroundMuted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'مغلق',
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.foregroundMuted,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            SizedBox(
              height: 32,
              child: ElevatedButton.icon(
                onPressed: onStart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.amber,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.play_arrow_rounded, size: 16),
                label: Text(
                  'بدء',
                  style: AppTextStyles.button.copyWith(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
