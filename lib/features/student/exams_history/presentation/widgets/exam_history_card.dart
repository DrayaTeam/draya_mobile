import "package:draya_mobile/core/router/app_routes.dart";
import "package:draya_mobile/core/helpers/app_navigator.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/features/student/exams_history/domain/entity/student_exam_history.dart";
import "package:flutter/material.dart";

import "attempt_history_tile.dart";

class ExamHistoryCard extends StatefulWidget {
  final StudentExamWithAttempts exam;

  const ExamHistoryCard({super.key, required this.exam});

  @override
  State<ExamHistoryCard> createState() => _ExamHistoryCardState();
}

class _ExamHistoryCardState extends State<ExamHistoryCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _expandController;
  bool _expanded = false;

  StudentExamWithAttempts get exam => widget.exam;

  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  Color get _statusColor {
    if (exam.attempts.any((a) => a.needsTeacherReview)) return AppColors.amber;
    switch (exam.attemptStatus) {
      case ExamAttemptStatus.completed:
        return AppColors.success;
      case ExamAttemptStatus.inProgress:
        return AppColors.primary;
      case ExamAttemptStatus.pendingGrading:
        return AppColors.amber;
      case ExamAttemptStatus.notStarted:
      case ExamAttemptStatus.unknown:
        return AppColors.textSecondary;
    }
  }

  IconData get _statusIcon {
    if (exam.attempts.any((a) => a.needsTeacherReview)) {
      return Icons.rate_review_rounded;
    }
    switch (exam.attemptStatus) {
      case ExamAttemptStatus.completed:
        return Icons.verified_rounded;
      case ExamAttemptStatus.inProgress:
        return Icons.play_circle_rounded;
      case ExamAttemptStatus.pendingGrading:
        return Icons.hourglass_top_rounded;
      case ExamAttemptStatus.notStarted:
        return Icons.schedule_rounded;
      case ExamAttemptStatus.unknown:
        return Icons.help_outline_rounded;
    }
  }

  String get _statusLabel {
    if (exam.canResume) return "قابل للاستكمال";
    if (exam.attempts.any((a) => a.needsTeacherReview)) {
      return "قيد مراجعة المعلم";
    }
    return exam.attemptStatus.toDisplayString();
  }

  void _toggleExpanded() {
    setState(() {
      _expanded = !_expanded;
      if (_expanded) {
        _expandController.forward();
      } else {
        _expandController.reverse();
      }
    });
  }

  void _openExam() {
    AppNavigator.push(
      context: context,
      path: AppRoutes.studentExamDetailsPage,
      extra: {"examId": exam.id},
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasAttempts = exam.attempts.isNotEmpty;
    final bestPercent = exam.bestAttempt?.scorePercent;
    final displayScore = exam.latestScorePercent ?? bestPercent;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.s16),
        border: Border.all(
          color: _expanded
              ? _statusColor.withValues(alpha: 0.4)
              : AppColors.border,
          width: _expanded ? 1.3 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: _expanded ? 0.06 : 0.03),
            blurRadius: _expanded ? 16 : 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: hasAttempts ? _toggleExpanded : null,
              borderRadius: BorderRadius.circular(AppSizes.s16),
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.s14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status-colored icon tile
                    Container(
                      width: AppSizes.s40,
                      height: AppSizes.s40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            _statusColor.withValues(alpha: 0.85),
                            _statusColor,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(AppSizes.s14),
                        boxShadow: [
                          BoxShadow(
                            color: _statusColor.withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(_statusIcon, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: AppSizes.s12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exam.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.h5.copyWith(fontSize: 14.5),
                          ),
                          const SizedBox(height: AppSizes.s4),
                          if (exam.classroomName != null)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.school_rounded,
                                  size: 12,
                                  color: AppColors.textDisabled,
                                ),
                                const SizedBox(width: 3),
                                Flexible(
                                  child: Text(
                                    exam.classroomName!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.label.copyWith(
                                      fontSize: 11,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSizes.s6),
                              ],
                            ),
                          const SizedBox(height: AppSizes.s6),
                          Row(
                            children: [
                              // Status pill
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.s8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      _statusColor.withValues(alpha: 0.1),
                                  borderRadius:
                                      BorderRadius.circular(AppSizes.s6),
                                ),
                                child: Text(
                                  _statusLabel,
                                  style: AppTextStyles.label.copyWith(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: _statusColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSizes.s6),
                              Text(
                                "${exam.usedAttempts}/${exam.allowedAttempts ?? "-"} محاولات",
                                style: AppTextStyles.label.copyWith(
                                  fontSize: 11,
                                  color: AppColors.textDisabled,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSizes.s8),
                    // Score ring
                    if (displayScore != null && displayScore > 0)
                      _ScoreRing(percent: displayScore)
                    else
                      Padding(
                        padding: const EdgeInsets.only(top: AppSizes.s10),
                        child: Icon(
                          Icons.chevron_left_rounded,
                          color: AppColors.textDisabled,
                          size: hasAttempts ? 24 : 0,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (hasAttempts) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.s14,
                0,
                AppSizes.s14,
                AppSizes.s4,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _expanded
                        ? "إخفاء سجل المحاولات"
                        : "عرض سجل المحاولات (${exam.attempts.length})",
                    style: AppTextStyles.label.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary700,
                    ),
                  ),
                  RotationTransition(
                    turns:
                        Tween(begin: 0.0, end: 0.5).animate(_expandController),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: AppColors.primary700,
                    ),
                  ),
                ],
              ),
            ),
            SizeTransition(
              sizeFactor: CurvedAnimation(
                parent: _expandController,
                curve: Curves.easeOutCubic,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.s12,
                  0,
                  AppSizes.s12,
                  AppSizes.s12,
                ),
                child: Column(
                  children: [
                    ...exam.attempts.asMap().entries.map(
                          (entry) => Padding(
                            padding:
                                const EdgeInsets.only(bottom: AppSizes.s8),
                            child: AttemptHistoryTile(
                              attempt: entry.value,
                              index: entry.key,
                              examId: exam.id,
                            ),
                          ),
                        ),
                    if (exam.canResume || exam.canRetake)
                      SizedBox(
                        width: double.infinity,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.centerRight,
                              end: Alignment.centerLeft,
                              colors: [
                                AppColors.primary700,
                                AppColors.primary500,
                              ],
                            ),
                            borderRadius:
                                BorderRadius.circular(AppSizes.s12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary700
                                    .withValues(alpha: 0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: _openExam,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSizes.s10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppSizes.s12),
                              ),
                            ),
                            icon: Icon(
                              exam.canResume
                                  ? Icons.play_arrow_rounded
                                  : Icons.replay_rounded,
                              size: 18,
                            ),
                            label: Text(
                              exam.canResume
                                  ? "متابعة الامتحان"
                                  : "أداء الامتحان مرة أخرى",
                              style: AppTextStyles.button.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Circular animated score indicator, color-coded by performance.
class _ScoreRing extends StatelessWidget {
  final double percent;

  const _ScoreRing({required this.percent});

  Color get _color {
    if (percent >= 75) return AppColors.success;
    if (percent >= 50) return AppColors.amber;
    return AppColors.error;
  }

  String get _formatted =>
      percent % 1 == 0 ? percent.toInt().toString() : percent.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: percent / 100),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) => CustomPaint(
        painter: _ScoreRingPainter(color: _color, progress: value),
        child: Container(
          width: AppSizes.s48,
          height: AppSizes.s48,
          alignment: Alignment.center,
          child: Text(
            _formatted,
            style: AppTextStyles.label.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: _color,
            ),
          ),
        ),
      ),
    );
  }
}

class _ScoreRingPainter extends CustomPainter {
  final Color color;
  final double progress;

  _ScoreRingPainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
      const stroke = 4.5;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - stroke) / 2;

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = color.withValues(alpha: 0.12);

    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        colors: [color.withValues(alpha: 0.65), color],
        transform: const GradientRotation(-1.57),
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, trackPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.57,
      2 * 3.14159 * progress.clamp(0.0, 1.0),
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ScoreRingPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.progress != progress;
}
