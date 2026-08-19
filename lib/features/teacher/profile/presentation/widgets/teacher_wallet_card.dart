import 'package:draya_mobile/core/enums/cubit_status.dart';
import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/core/theme/app_text_styles.dart';
import 'package:draya_mobile/core/widgets/app_custom_loading.dart';
import 'package:draya_mobile/features/teacher/wallet/data/models/balance_model.dart';
import 'package:draya_mobile/features/teacher/wallet/presentation/cubit/wallet_cubit.dart';
import 'package:draya_mobile/features/teacher/wallet/presentation/cubit/wallet_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherWalletCard extends StatelessWidget {
  final VoidCallback? onRefresh;

  const TeacherWalletCard({
    super.key,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, state) {
        if (state.status == CubitStatus.loading && state.teacherBalance == null) {
          return _buildLoadingState(context);
        }

        if (state.status == CubitStatus.error && state.teacherBalance == null) {
          return _buildErrorState(context);
        }

        final balance = state.teacherBalance ??
            const BalanceModel(
              earnedBalance: 0,
              purchasedBalance: 0,
              availableEarnedBalance: 0,
            );

        return _buildCard(context, balance, state.status == CubitStatus.loading);
      },
    );
  }

  Widget _buildCard(BuildContext context, BalanceModel balance, bool isRefreshing) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [
            AppColors.primary900,
            AppColors.primary800,
            AppColors.primary700,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary900.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: -2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Decorative background patterns
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.07),
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              left: -30,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary400.withValues(alpha: 0.12),
                ),
              ),
            ),
            Positioned(
              top: 50,
              left: 40,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.04),
                ),
              ),
            ),

            // Card Content
            Padding(
              padding: const EdgeInsets.all(AppSizes.s20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Badge Pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.s12,
                          vertical: AppSizes.s4 + 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.primary300,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: AppSizes.s8),
                            Text(
                              "محفظة المعلم الرقمية",
                              style: AppTextStyles.label.copyWith(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Refresh button or indicator
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onRefresh,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(AppSizes.s8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: isRefreshing
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(
                                    Icons.refresh_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSizes.s20),

                  // Main Balance Title
                  Text(
                    "الرصيد المتاح للسحب",
                    style: AppTextStyles.body.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: AppSizes.s4),

                  // Main Balance Value
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        balance.availableEarnedBalance.toStringAsFixed(2),
                        style: AppTextStyles.h1.copyWith(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: AppSizes.s8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.s8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary300.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.primary300.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          "ج.م",
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.primary100,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSizes.s24),

                  // Sub-Balances Glassmorphic Grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildBalanceMetricItem(
                          icon: Icons.trending_up_rounded,
                          iconColor: const Color(0xFF4ADE80), // vibrant green
                          title: "الرصيد المكتسب",
                          value: "${balance.earnedBalance.toStringAsFixed(1)} ج.م",
                        ),
                      ),
                      const SizedBox(width: AppSizes.s12),
                      Expanded(
                        child: _buildBalanceMetricItem(
                          icon: Icons.account_balance_wallet_outlined,
                          iconColor: const Color(0xFF60A5FA), // bright blue
                          title: "الرصيد المشحون",
                          value: "${balance.purchasedBalance.toStringAsFixed(1)} ج.م",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceMetricItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.s12,
        vertical: AppSizes.s12,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.s8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 18,
            ),
          ),
          const SizedBox(width: AppSizes.s8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.label.copyWith(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.body.copyWith(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
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

  Widget _buildLoadingState(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      padding: const EdgeInsets.all(AppSizes.s24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppColors.primary900.withValues(alpha: 0.85),
      ),
      child: const Center(
        child: AppCustomLoading(),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.s20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.backgroundMuted,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.error,
            size: 32,
          ),
          const SizedBox(height: AppSizes.s8),
          Text(
            "تعذر تحميل بيانات المحفظة",
            style: AppTextStyles.label.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.s8),
          TextButton.icon(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text("إعادة المحاولة"),
          ),
        ],
      ),
    );
  }
}
