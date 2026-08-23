import "dart:math" as math;

import "package:draya_mobile/core/di/dependency_injection.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/features/teacher/exam_generation/data/models/teacher_exam_models.dart";
import "package:draya_mobile/features/teacher/exam_generation/data/source/teacher_exam_remote_data_source.dart";
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";

enum _QuotaLoadStatus { loading, success, error }

/// Self-contained card that fetches and displays the teacher's
/// AI exam generation quota (GET /exams/quota).
class AiQuotaCard extends StatefulWidget {
  final EdgeInsetsGeometry? margin;

  const AiQuotaCard({super.key, this.margin});

  @override
  State<AiQuotaCard> createState() => _AiQuotaCardState();
}

class _AiQuotaCardState extends State<AiQuotaCard>
    with SingleTickerProviderStateMixin {
  _QuotaLoadStatus _status = _QuotaLoadStatus.loading;
  AiQuotaModel? _quota;
  bool _isRefreshing = false;

  late final AnimationController _shimmerController;

  TeacherExamRemoteDataSource get _remote =>
      getIt<TeacherExamRemoteDataSource>();

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _loadQuota();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  Future<void> _loadQuota() async {
    if (_isRefreshing) return;
    _isRefreshing = true;
    if (mounted && _status == _QuotaLoadStatus.error) {
      setState(() => _status = _QuotaLoadStatus.loading);
    }
    try {
      final quota = await _remote.getQuota();
      if (mounted) {
        setState(() {
          _quota = quota;
          _status = _QuotaLoadStatus.success;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _status = _QuotaLoadStatus.error);
      }
    } finally {
      _isRefreshing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: switch (_status) {
          _QuotaLoadStatus.loading => _buildLoadingSkeleton(),
          _QuotaLoadStatus.error => _buildErrorState(),
          _QuotaLoadStatus.success => _buildSuccessCard(),
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Success state — polished gradient card with animated usage ring.
  // ---------------------------------------------------------------------------

  Widget _buildSuccessCard() {
    final quota = _quota!;
    final hasFree = quota.hasFreeRemaining;
    final remainingFraction =
        quota.freeMonthlyQuota <= 0 ? 0.0 : quota.remainingFreeQuota / quota.freeMonthlyQuota;

    final gradientColors = hasFree
        ? const [AppColors.ai900, AppColors.ai700, AppColors.primary700]
        : const [Color(0xFF92400E), AppColors.amber, Color(0xFFFBBF24)];

    final accentGlow = hasFree ? AppColors.ai700 : AppColors.amber;

    return Semantics(
      label:
          "رصيد الذكاء الاصطناعي: متبقٍ ${quota.remainingFreeQuota} من ${quota.freeMonthlyQuota} امتحان مجاني",
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: accentGlow.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              left: -24,
              top: -24,
              child: _decorativeCircle(110),
            ),
            Positioned(
              right: -18,
              bottom: -30,
              child: _decorativeCircle(90),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSizes.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildUsageRing(
                        remainingFraction: remainingFraction,
                        quota: quota,
                        hasFree: hasFree,
                      ),
                      const SizedBox(width: AppSizes.s16),
                      Expanded(child: _buildHeaderText(quota, hasFree)),
                      _buildRefreshButton(),
                    ],
                  ),
                  const SizedBox(height: AppSizes.s14),
                  _buildInfoChips(quota, hasFree),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _decorativeCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.06),
      ),
    );
  }

  Widget _buildUsageRing({
    required double remainingFraction,
    required AiQuotaModel quota,
    required bool hasFree,
  }) {
    final ringColor = hasFree ? Colors.white : Colors.white;
    final trackColor = Colors.white.withValues(alpha: 0.22);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: remainingFraction.clamp(0.0, 1.0)),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, _) {
        return SizedBox(
          width: 76,
          height: 76,
          child: CustomPaint(
            painter: _QuotaRingPainter(
              progress: animatedValue,
              trackColor: trackColor,
              progressColor: ringColor,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${quota.remainingFreeQuota}",
                    style: AppTextStyles.h3.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    "متبقي",
                    style: AppTextStyles.label.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderText(AiQuotaModel quota, bool hasFree) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const FaIcon(
              FontAwesomeIcons.wandMagicSparkles,
              color: Colors.white,
              size: 13,
            ),
            const SizedBox(width: 6),
            Text(
              "رصيد الذكاء الاصطناعي",
              style: AppTextStyles.h5.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          hasFree
              ? "متبقي لك ${quota.remainingFreeQuota} من ${quota.freeMonthlyQuota} امتحانات مجانية هذا الشهر."
              : "انتهت حصتك المجانية لهذا الشهر، وسيتم خصم ${quota.formattedPrice} ج.م من محفظتك لكل امتحان جديد.",
          style: AppTextStyles.body.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 11.5,
            height: 1.45,
          ),
        ),
      ],
    );
  }

  Widget _buildRefreshButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _loadQuota,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
          ),
          child: const Icon(
            Icons.refresh_rounded,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChips(AiQuotaModel quota, bool hasFree) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildChip(
          icon: Icons.check_circle_outline_rounded,
          text: "استُخدم ${quota.freeExamsUsed}/${quota.freeMonthlyQuota}",
        ),
        _buildChip(
          icon: Icons.monetization_on_outlined,
          text: "الامتحان الإضافي: ${quota.formattedPrice} ج.م",
        ),
        if (!hasFree)
          _buildChip(
            icon: quota.hasSufficientBalanceForPaid
                ? Icons.account_balance_wallet_rounded
                : Icons.warning_amber_rounded,
            text: quota.hasSufficientBalanceForPaid
                ? "رصيد محفظتك يكفي"
                : "رصيد المحفظة غير كافٍ للامتحانات المدفوعة",
            color: quota.hasSufficientBalanceForPaid
                ? const Color(0xFFDCFCE7)
                : const Color(0xFFFEE2E2),
            textColor: quota.hasSufficientBalanceForPaid
                ? const Color(0xFF166534)
                : const Color(0xFF991B1B),
            borderColor: quota.hasSufficientBalanceForPaid
                ? const Color(0xFF86EFAC)
                : const Color(0xFFFCA5A5),
          ),
      ],
    );
  }

  Widget _buildChip({
    required IconData icon,
    required String text,
    Color? color,
    Color? textColor,
    Color? borderColor,
  }) {
    final bgColor = color ?? Colors.white.withValues(alpha: 0.16);
    final fgColor = textColor ?? Colors.white;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: borderColor ?? Colors.white.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: fgColor, size: 13),
          const SizedBox(width: 6),
          Text(
            text,
            style: AppTextStyles.label.copyWith(
              color: fgColor,
              fontWeight: FontWeight.w800,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Loading skeleton.
  // ---------------------------------------------------------------------------

  Widget _buildLoadingSkeleton() {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, _) {
        final opacity =
            0.5 + 0.25 * math.sin(_shimmerController.value * math.pi);
        return Container(
          height: 150,
          decoration: BoxDecoration(
            color: AppColors.ai50.withValues(alpha: opacity + 0.2),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.ai100),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: AppColors.ai700,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "جاري تحميل رصيد الذكاء الاصطناعي...",
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.ai700,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Error state.
  // ---------------------------------------------------------------------------

  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.cloud_off_rounded,
              size: 18,
              color: AppColors.error,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "تعذر تحميل رصيد الذكاء الاصطناعي",
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: _loadQuota,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.ai700,
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: Text(
              "إعادة المحاولة",
              style: AppTextStyles.label.copyWith(
                color: AppColors.ai700,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuotaRingPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;

  const _QuotaRingPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 7.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - strokeWidth) / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    if (progress > 0) {
      final rect = Rect.fromCircle(center: center, radius: radius);
      canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * progress, false,
          progressPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _QuotaRingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.trackColor != trackColor ||
      oldDelegate.progressColor != progressColor;
}
