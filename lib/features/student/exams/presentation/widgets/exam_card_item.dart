import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/features/student/exams/domain/entity/student_exam.dart";
import "package:draya_mobile/features/student/student_materials/domain/entity/classroom_section.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

enum ExamAccessStatus {
  active,
  upcoming,
  expired,
}

class ExamCardItem extends StatelessWidget {
  final SectionExam exam;
  final String classroomName;
  final String sectionTitle;
  final VoidCallback onStart;
  final StudentExamOverview? overview;
  final VoidCallback? onViewResult;

  const ExamCardItem({
    super.key,
    required this.exam,
    required this.classroomName,
    required this.sectionTitle,
    required this.onStart,
    this.overview,
    this.onViewResult,
  });

  bool get _hasViewableResult => overview?.hasViewableResult ?? false;

  bool get _hasAttemptsLeft => overview?.hasAttemptsLeft ?? true;

  /// The exam title from the exams endpoint, falling back to the section topic.
  String get _displayTitle =>
      (overview?.title.isNotEmpty ?? false) ? overview!.title : exam.topic;

  ExamAccessStatus _getAccessStatus() {
    final now = DateTime.now().toUtc();
    if (exam.startDate != null && now.isBefore(exam.startDate!.toUtc())) {
      return ExamAccessStatus.upcoming;
    }
    if (exam.endDate != null && now.isAfter(exam.endDate!.toUtc())) {
      return ExamAccessStatus.expired;
    }
    return ExamAccessStatus.active;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat("d MMM yyyy", "ar");
    final dateTimeFormat = DateFormat("d MMM - hh:mm a", "ar");
    final dateStr = dateFormat.format(exam.createdAt);
    final status = _getAccessStatus();

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.s16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: status == ExamAccessStatus.expired
              ? AppColors.border
              : (status == ExamAccessStatus.active
                  ? AppColors.primary100
                  : AppColors.border),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: status == ExamAccessStatus.active
                ? AppColors.primary.withValues(alpha: 0.06)
                : const Color.fromRGBO(17, 24, 39, 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top row: Classroom badge + Status badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primary200),
                  ),
                  child: Text(
                    classroomName,
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
                _buildStatusBadge(status),
              ],
            ),
            const SizedBox(height: AppSizes.s12),

            // Exam Title (from exams endpoint) with Topic badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    _displayTitle,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.h4.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (overview != null &&
                    overview!.topic.isNotEmpty &&
                    overview!.topic != _displayTitle) ...[
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.ai100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        overview!.topic,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.ai700,
                          fontWeight: FontWeight.w700,
                          fontSize: 10.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 4),

            // Section subtitle & creation date
            Text(
              "القسم: $sectionTitle • أضيف في $dateStr",
              textAlign: TextAlign.right,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: AppSizes.s12),

            // Detailed constraints chips row (Duration, Attempts, Question count)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildInfoChip(
                  icon: Icons.quiz_outlined,
                  text: "${exam.questionsCount} أسئلة",
                  color: AppColors.primary,
                  bgColor: AppColors.primary50,
                ),
                if (exam.durationMinutes != null && exam.durationMinutes! > 0)
                  _buildInfoChip(
                    icon: Icons.timer_outlined,
                    text: "${exam.durationMinutes} دقيقة",
                    color: AppColors.amber,
                    bgColor: AppColors.amber.withValues(alpha: 0.12),
                  ),
                if (exam.allowedAttempts != null && exam.allowedAttempts! > 0) ...[
                  if (overview != null && (overview!.usedAttempts > 0 || !_hasAttemptsLeft))
                    _buildInfoChip(
                      icon: Icons.replay_rounded,
                      text:
                          "المحاولات المستخدمة ${overview!.usedAttempts} من ${exam.allowedAttempts}",
                      color: _hasAttemptsLeft ? AppColors.ai700 : AppColors.error,
                      bgColor: _hasAttemptsLeft
                          ? AppColors.ai100
                          : AppColors.error.withValues(alpha: 0.12),
                    )
                  else
                    _buildInfoChip(
                      icon: Icons.replay_rounded,
                      text: "${exam.allowedAttempts} محاولات مسموحة",
                      color: AppColors.ai700,
                      bgColor: AppColors.ai100,
                    ),
                ],
              ],
            ),

            if (status == ExamAccessStatus.upcoming && exam.startDate != null) ...[
              const SizedBox(height: AppSizes.s8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.mathPhysics.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 14, color: AppColors.mathPhysics),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "يبدأ الامتحان في: ${dateTimeFormat.format(exam.startDate!.toLocal())}",
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.mathPhysics,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            if (status == ExamAccessStatus.active && exam.endDate != null) ...[
              const SizedBox(height: AppSizes.s8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.amber.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.alarm, size: 14, color: AppColors.amber),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "ينتهي موعد الامتحان في: ${dateTimeFormat.format(exam.endDate!.toLocal())}",
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.amber,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: AppSizes.s16),

            // Latest attempt result banner (when student has submitted)
            if (_hasViewableResult) ...[
              _buildLatestAttemptBanner(),
              const SizedBox(height: AppSizes.s12),
            ],

            // Action Buttons (View Result / Start Exam) with State Handling
            _buildActions(status),
          ],
        ),
      ),
    );
  }

  Widget _buildLatestAttemptBanner() {
    final latest = overview!.latestAttempt!;
    final scorePct = latest.scorePercentage;
    final isPassed = scorePct >= 50;
    final scoreColor = latest.needsTeacherReview
        ? AppColors.amber
        : (isPassed ? AppColors.success : AppColors.error);
    final dateFormat = DateFormat("d MMM yyyy - hh:mm a", "ar");
    final dateStr = latest.submittedAt != null
        ? dateFormat.format(latest.submittedAt!.toLocal())
        : "تم التسليم";

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scoreColor.withValues(alpha: 0.08),
            scoreColor.withValues(alpha: 0.03),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scoreColor.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: scoreColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: scoreColor.withValues(alpha: 0.3)),
            ),
            child: Center(
              child: Text(
                "${scorePct.toStringAsFixed(0)}%",
                style: AppTextStyles.label.copyWith(
                  color: scoreColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      latest.needsTeacherReview
                          ? Icons.rate_review_rounded
                          : Icons.verified_rounded,
                      size: 14,
                      color: scoreColor,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        latest.needsTeacherReview
                            ? "نتيجة محاولتك الأخيرة - قيد مراجعة المعلم"
                            : "نتيجة محاولتك الأخيرة",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.label.copyWith(
                          color: scoreColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 11.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  "${latest.finalScore.toStringAsFixed(1)} من ${latest.maxScore > 0 ? latest.maxScore.toStringAsFixed(1) : "-"} • $dateStr",
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultButton({bool isPrimary = false}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onViewResult,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? AppColors.primary : AppColors.primary50,
          foregroundColor: isPrimary ? Colors.white : AppColors.primary,
          disabledBackgroundColor: AppColors.backgroundMuted,
          disabledForegroundColor: AppColors.textDisabled,
          padding: const EdgeInsets.symmetric(vertical: 11),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: isPrimary
                ? BorderSide.none
                : const BorderSide(color: AppColors.primary200),
          ),
          elevation: 0,
        ),
        icon: Icon(
          Icons.bar_chart_rounded,
          size: 18,
          color: isPrimary ? Colors.white : AppColors.primary,
        ),
        label: Text(
          "عرض النتيجة والتفاصيل",
          style: AppTextStyles.label.copyWith(
            color: isPrimary ? Colors.white : AppColors.primary,
            fontWeight: FontWeight.w800,
            fontSize: 13.5,
          ),
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onStart,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 11),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        icon: const Icon(Icons.arrow_forward_rounded, size: 18),
        label: Text(
          "بدء الامتحان الآن",
          style: AppTextStyles.label.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 13.5,
          ),
        ),
      ),
    );
  }

  Widget _buildLockedButton({
    required String label,
    required IconData icon,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.backgroundMuted,
          disabledBackgroundColor: AppColors.backgroundMuted,
          disabledForegroundColor: AppColors.textDisabled,
          padding: const EdgeInsets.symmetric(vertical: 11),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          style: AppTextStyles.label.copyWith(
            color: AppColors.textDisabled,
            fontWeight: FontWeight.w800,
            fontSize: 13.5,
          ),
        ),
      ),
    );
  }

  Widget _buildActions(ExamAccessStatus status) {
    final canViewResult = _hasViewableResult && onViewResult != null;

    // No attempts left: results become the primary action
    if (!_hasAttemptsLeft) {
      return canViewResult
          ? _buildResultButton(isPrimary: true)
          : _buildLockedButton(
              label: "لا توجد محاولات متبقية",
              icon: Icons.block_rounded,
            );
    }

    switch (status) {
      case ExamAccessStatus.expired:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildLockedButton(
              label: "انتهت فترة الامتحان",
              icon: Icons.lock_clock_rounded,
            ),
            if (canViewResult) ...[
              const SizedBox(height: 8),
              _buildResultButton(),
            ],
          ],
        );
      case ExamAccessStatus.upcoming:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildLockedButton(
              label: "لم يبدأ موعد الامتحان بعد",
              icon: Icons.lock_outline_rounded,
            ),
            if (canViewResult) ...[
              const SizedBox(height: 8),
              _buildResultButton(),
            ],
          ],
        );
      case ExamAccessStatus.active:
        if (canViewResult) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildStartButton(),
              const SizedBox(height: 8),
              _buildResultButton(),
            ],
          );
        }
        return _buildStartButton();
    }
  }

  Widget _buildStatusBadge(ExamAccessStatus status) {
    Color color;
    Color bgColor;
    String label;
    IconData icon;

    switch (status) {
      case ExamAccessStatus.active:
        color = AppColors.chemistryBiology;
        bgColor = AppColors.chemistryBiology.withValues(alpha: 0.12);
        label = "متاح الآن";
        icon = Icons.check_circle_rounded;
      case ExamAccessStatus.upcoming:
        color = AppColors.mathPhysics;
        bgColor = AppColors.mathPhysics.withValues(alpha: 0.12);
        label = "قريباً";
        icon = Icons.schedule_rounded;
      case ExamAccessStatus.expired:
        color = AppColors.error;
        bgColor = AppColors.error.withValues(alpha: 0.12);
        label = "منتهي الصلاحية";
        icon = Icons.cancel_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.label.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String text,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTextStyles.label.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
