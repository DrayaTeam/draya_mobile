import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

class AttemptCard extends StatelessWidget {
  final String studentName;
  final double finalScore;
  final DateTime? submittedAt;
  final int index;

  const AttemptCard({
    super.key,
    required this.studentName,
    required this.finalScore,
    this.submittedAt,
    required this.index,
  });

  static final DateFormat _dateFormat = DateFormat.yMMMd("ar");

  static const List<Color> _medalColors = [
    Color(0xFFF59E0B),
    AppColors.textSecondary,
    Color(0xFFB45309),
  ];

  double get _clampedScore => finalScore.clamp(0, 100);

  Color get _scoreColor {
    if (_clampedScore >= 85) return AppColors.chemistryBiology;
    if (_clampedScore >= 60) return AppColors.amber;
    return AppColors.error;
  }

  String get _formattedScore =>
      finalScore % 1 == 0
          ? finalScore.toInt().toString()
          : finalScore.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    final isTopThree = index < 3;

    return Container(
      padding: const EdgeInsets.all(AppSizes.s12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.s16),
        border:
            isTopThree
                ? Border.all(color: _medalColors[index].withValues(alpha: 0.4))
                : Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isTopThree ? 0.06 : 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildRankBadge(isTopThree),
          const SizedBox(width: AppSizes.s12),
          Expanded(child: _buildStudentInfo()),
          const SizedBox(width: AppSizes.s12),
          _buildScoreBadge(),
        ],
      ),
    );
  }

  Widget _buildRankBadge(bool isTopThree) {
    if (isTopThree) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: AppSizes.s40,
            height: AppSizes.s40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  _medalColors[index],
                  _medalColors[index].withValues(alpha: 0.75),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _medalColors[index].withValues(alpha: 0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              "${index + 1}",
              style: AppTextStyles.button.copyWith(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: -6,
            left: -6,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.workspace_premium_rounded,
                size: AppSizes.s14,
                color: _medalColors[index],
              ),
            ),
          ),
        ],
      );
    }

    return Container(
      width: AppSizes.s36,
      height: AppSizes.s36,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.backgroundMuted,
        shape: BoxShape.circle,
      ),
      child: Text(
        "${index + 1}",
        style: AppTextStyles.label.copyWith(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildStudentInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                studentName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.h5.copyWith(fontSize: 14),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.s8),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.s6),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: _clampedScore / 100),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutCubic,
            builder:
                (context, value, _) => LinearProgressIndicator(
                  value: value,
                  minHeight: AppSizes.s6,
                  backgroundColor: AppColors.backgroundMuted,
                  valueColor: AlwaysStoppedAnimation<Color>(_scoreColor),
                  borderRadius: BorderRadius.circular(AppSizes.s6),
                ),
          ),
        ),
        const SizedBox(height: AppSizes.s8),
        Row(
          children: [
            const Icon(
              Icons.schedule_rounded,
              size: AppSizes.s12,
              color: AppColors.textDisabled,
            ),
            const SizedBox(width: AppSizes.s4),
            Flexible(
              child: Text(
                submittedAt != null
                    ? _dateFormat.format(submittedAt!)
                    : "لم يُسلّم بعد",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.label.copyWith(
                  fontSize: 11,
                  color: AppColors.textDisabled,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScoreBadge() {
    return Container(
      width: AppSizes.s56,
      padding: const EdgeInsets.symmetric(vertical: AppSizes.s10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [_scoreColor, _scoreColor.withValues(alpha: 0.75)],
        ),
        borderRadius: BorderRadius.circular(AppSizes.s12),
        boxShadow: [
          BoxShadow(
            color: _scoreColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            _formattedScore,
            style: AppTextStyles.h5.copyWith(color: Colors.white),
          ),
          Text(
            "درجة",
            style: AppTextStyles.label.copyWith(
              fontSize: 10,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}
