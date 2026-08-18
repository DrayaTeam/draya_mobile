import 'package:draya_mobile/core/helpers/app_navigator.dart';
import 'package:draya_mobile/core/router/app_routes.dart';
import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/core/theme/app_text_styles.dart';
import 'package:draya_mobile/core/widgets/custom_app_bar.dart';
import 'package:draya_mobile/features/student/teachers/data/models/payment_status_model.dart';
import 'package:draya_mobile/features/student/teachers/presentation/cubit/payment_verification_cubit.dart';
import 'package:draya_mobile/features/student/teachers/presentation/cubit/payment_verification_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentResultPage extends StatefulWidget {
  final String transactionId;

  const PaymentResultPage({
    super.key,
    required this.transactionId,
  });

  @override
  State<PaymentResultPage> createState() => _PaymentResultPageState();
}

class _PaymentResultPageState extends State<PaymentResultPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );

    // Start verification immediately
    context.read<PaymentVerificationCubit>().verifyPayment(
      widget.transactionId,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'نتيجة الدفع'),
      body: SafeArea(
        child: BlocConsumer<PaymentVerificationCubit, PaymentVerificationState>(
          listener: (context, state) {
            if (state.status == PaymentVerificationStatus.completed ||
                state.status == PaymentVerificationStatus.failed ||
                state.status == PaymentVerificationStatus.timeout) {
              _animController.forward(from: 0.0);
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.s24,
                vertical: AppSizes.s32,
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildContent(context, state),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, PaymentVerificationState state) {
    switch (state.status) {
      case PaymentVerificationStatus.initial:
      case PaymentVerificationStatus.polling:
        return _buildPollingView(state.retryCount);
      case PaymentVerificationStatus.completed:
        return _buildSuccessView(context, state.paymentStatus);
      case PaymentVerificationStatus.failed:
        return _buildFailedView(context, state.paymentStatus);
      case PaymentVerificationStatus.timeout:
        return _buildTimeoutView(context);
      case PaymentVerificationStatus.error:
        return _buildErrorView(context, state);
    }
  }

  Widget _buildPollingView(int attempt) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: AppColors.primary100,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary500.withValues(alpha: 0.15),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Center(
            child: SizedBox(
              width: 44,
              height: 44,
              child: CircularProgressIndicator(
                strokeWidth: 3.5,
                color: AppColors.primary700,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSizes.s32),
        Text(
          'جاري تأكيد عملية الدفع...',
          style: AppTextStyles.h3.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSizes.s12),
        Text(
          'يرجى الانتظار قليلاً بينما نتحقق من حالة الدفع مع البنك.',
          style: AppTextStyles.body.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        // if (attempt > 1) ...[
        //   const SizedBox(height: AppSizes.s16),
        //   Container(
        //     padding: const EdgeInsets.symmetric(
        //       horizontal: AppSizes.s16,
        //       vertical: AppSizes.s8,
        //     ),
        //     decoration: BoxDecoration(
        //       color: AppColors.backgroundMuted,
        //       borderRadius: BorderRadius.circular(999),
        //       border: Border.all(color: AppColors.border),
        //     ),
        //     child: Text(
        //       'محاولة $attempt من ${PaymentVerificationCubit.maxRetryAttempts}',
        //       style: AppTextStyles.label.copyWith(
        //         color: AppColors.textSecondary,
        //       ),
        //     ),
        //   ),
        // ],
      ],
    );
  }

  Widget _buildSuccessView(
    BuildContext context,
    PaymentStatusModel? paymentStatus,
  ) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.success.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: AppColors.success,
              size: 56,
            ),
          ),
          const SizedBox(height: AppSizes.s24),
          Text(
            'تم الدفع بنجاح!',
            style: AppTextStyles.h2.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.s8),
          Text(
            'تم تسجيلك في الفصل الدراسي بنجاح.',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.s24),
          if (paymentStatus != null) _buildDetailsCard(paymentStatus),
          const SizedBox(height: AppSizes.s32),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              onPressed: () => _navigateToClassroom(context, paymentStatus),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.s12),
                ),
              ),
              icon: const Icon(Icons.arrow_forward_rounded, size: 20),
              label: Text(
                'الانتقال إلى الفصل',
                style: AppTextStyles.button.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFailedView(
    BuildContext context,
    PaymentStatusModel? paymentStatus,
  ) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.error.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.cancel_rounded,
              color: AppColors.error,
              size: 56,
            ),
          ),
          const SizedBox(height: AppSizes.s24),
          Text(
            'فشلت عملية الدفع',
            style: AppTextStyles.h2.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.s8),
          Text(
            'لم تكتمل عملية الدفع أو تم إلغاؤها. يرجى المحاولة مرة أخرى.',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.s32),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              onPressed: () {
                AppNavigator.pop(context: context);
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.s12),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: Text(
                'العودة للفصول',
                style: AppTextStyles.button.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeoutView(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.amber.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.amber.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.access_time_filled_rounded,
              color: AppColors.amber,
              size: 56,
            ),
          ),
          const SizedBox(height: AppSizes.s24),
          Text(
            'العملية قيد المعالجة',
            style: AppTextStyles.h2.copyWith(
              color: AppColors.amber,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.s8),
          Text(
            'قد تستغرق المعالجة بضع دقائق إضافية. سيتم تحديث حالة اشتراكك تلقائياً بمجرد التأكيد.',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.s32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.read<PaymentVerificationCubit>().verifyPayment(
                      widget.transactionId,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppSizes.s16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.s12),
                    ),
                  ),
                  child: const Text('إعادة الفحص'),
                ),
              ),
              const SizedBox(width: AppSizes.s12),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    AppNavigator.goAndRemove(
                      context: context,
                      path: AppRoutes.studentHomePage,
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary700,
                    padding: const EdgeInsets.symmetric(vertical: AppSizes.s16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.s12),
                    ),
                  ),
                  child: const Text('الصفحة الرئيسية'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(
    BuildContext context,
    PaymentVerificationState state,
  ) {
    final errorMessage =
        state.apiErrorModel?.error?.message ??
        'حدث خطأ أثناء التحقق من حالة الدفع.';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.error_outline_rounded,
            color: AppColors.error,
            size: 44,
          ),
        ),
        const SizedBox(height: AppSizes.s20),
        Text(
          'تعذر التحقق من الدفع',
          style: AppTextStyles.h4.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSizes.s8),
        Text(
          errorMessage,
          style: AppTextStyles.body.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSizes.s24),
        FilledButton.icon(
          onPressed: () {
            context.read<PaymentVerificationCubit>().verifyPayment(
              widget.transactionId,
            );
          },
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary700,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.s12),
            ),
          ),
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('إعادة المحاولة'),
        ),
      ],
    );
  }

  Widget _buildDetailsCard(PaymentStatusModel status) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.s16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.s16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(17, 24, 39, 0.04),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildRow('رقم المعاملة', status.paymentTransactionId),
          const Divider(height: AppSizes.s16),
          _buildRow('المبلغ', '${status.grossAmount.toStringAsFixed(0)} جنيه'),
          const Divider(height: AppSizes.s16),
          _buildRow(
            'حالة الاشتراك',
            status.isEnrolled ? 'تم الاشتراك' : 'غير مكتمل',
            valueColor: status.isEnrolled ? AppColors.success : AppColors.error,
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: AppTextStyles.body.copyWith(
              color: valueColor ?? AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _navigateToClassroom(
    BuildContext context,
    PaymentStatusModel? paymentStatus,
  ) {
    final classroomId = paymentStatus?.classroomId;
    if (classroomId != null && classroomId.isNotEmpty) {
      AppNavigator.pushReplacement(
        context: context,
        path: AppRoutes.studentEnrolledClassroomsPage,
      );
    } else {
      AppNavigator.pushReplacement(
        context: context,
        path: AppRoutes.studentEnrolledClassroomsPage,
      );
    }
  }
}
