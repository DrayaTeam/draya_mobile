import "dart:async";

import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/helpers/app_dialog_helper.dart";
import "package:draya_mobile/core/helpers/app_loading.dart";
import "package:draya_mobile/core/helpers/app_navigator.dart";
import "package:draya_mobile/core/router/app_routes.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/widgets/app_elevated_button.dart";
import "package:draya_mobile/core/widgets/app_error_dialog.dart";
import "package:draya_mobile/features/auth/data/models/request_password_reset_model.dart";
import "package:draya_mobile/features/auth/presentation/forgot_password/widgets/password_reset_header.dart";
import "package:draya_mobile/features/auth/presentation/signin/cubit/signin_cubit.dart";
import "package:draya_mobile/features/auth/presentation/signin/cubit/signin_state.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class OtpVerificationPage extends StatefulWidget {
  final String email;

  const OtpVerificationPage({super.key, required this.email});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  static const int _otpLength = 6;
  static const int _resendSeconds = 60;

  late final TextEditingController _otpController;
  late final FocusNode _otpFocusNode;
  Timer? _resendTimer;
  int _remainingSeconds = 0;
  bool _showError = false;

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
    _otpFocusNode = FocusNode();
    _otpFocusNode.addListener(() {
      if (mounted) setState(() {});
    });
    _startResendCooldown();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _otpController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  void _startResendCooldown() {
    _remainingSeconds = _resendSeconds;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        _remainingSeconds--;

        if (_remainingSeconds <= 0) {
          _remainingSeconds = 0;
          timer.cancel();
        }
      });
    });
  }

  void _onOtpChanged(String value) {
    final digits = value.replaceAll(RegExp(r"\D"), "");

    final clamped = digits.length > _otpLength
        ? digits.substring(0, _otpLength)
        : digits;

    if (clamped != value) {
      _otpController.value = TextEditingValue(
        text: clamped,
        selection: TextSelection.collapsed(offset: clamped.length),
      );
    }

    if (_showError) {
      setState(() => _showError = false);
    } else {
      setState(() {});
    }
  }

  void _verify() {
    if (_otpController.text.length < _otpLength) {
      setState(() => _showError = true);
      HapticFeedback.heavyImpact();
      return;
    }

    AppNavigator.push(
      context: context,
      path: AppRoutes.resetPasswordPage,
      queryParameters: {"email": widget.email},
      extra: _otpController.text,
    );
  }

  void _resendCode() {
    context.read<SigninCubit>().requestPasswordReset(
      requestPasswordResetModel: RequestPasswordResetModel(
        email: widget.email,
      ),
    );
    _startResendCooldown();
  }

  String get _maskedEmail {
    final parts = widget.email.split("@");

    if (parts.length != 2 || parts[0].isEmpty) {
      return widget.email;
    }

    final name = parts[0];
    final visible = name.length <= 2 ? name : name.substring(0, 2);

    return "$visible•••@${parts[1]}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("رمز التحقق")),
      body: SafeArea(
        child: BlocListener<SigninCubit, SigninState>(
          listenWhen: (previous, current) =>
              previous.requestPasswordResetStatus !=
              current.requestPasswordResetStatus,
          listener: (context, state) {
            switch (state.requestPasswordResetStatus) {
              case CubitStatus.loading:
                AppLoading.show();
                break;
              case CubitStatus.success:
                AppLoading.hide();
                break;
              case CubitStatus.error:
                AppLoading.hide();
                _startResendCooldown();
                AppDialogHelper.display(
                  context,
                  AppErrorDialog(apiErrorModel: state.apiErrorModel!),
                );
                break;
              default:
                break;
            }
          },
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.s24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PasswordResetHeader(
                    currentStep: 1,
                    title: "أدخل رمز التحقق",
                    subtitle:
                        "أرسلنا رمز التحقق إلى $_maskedEmail، يرجى إدخاله للمتابعة.",
                  ),
                  const SizedBox(height: AppSizes.s32),
                  GestureDetector(
                    onTap: () => _otpFocusNode.requestFocus(),
                    child: _buildOtpBoxes(context),
                  ),
                  if (_showError)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSizes.s8),
                      child: Text(
                        "يرجى إدخال رمز التحقق المكوّن من $_otpLength أرقام",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  const SizedBox(height: AppSizes.s24),
                  _buildHiddenTextField(),
                  const SizedBox(height: AppSizes.s32),
                  AppElevatedButton(
                    onPressed: _verify,
                    label: "تحقق",
                    icon: const Icon(Icons.verified_outlined, size: 20),
                  ),
                  const SizedBox(height: AppSizes.s16),
                  Center(child: _buildResendRow()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBoxes(BuildContext context) {
    final text = _otpController.text;
    final hasFocus = _otpFocusNode.hasFocus;

    return Row(
      children: List.generate(_otpLength, (index) {
        final isFilled = index < text.length;
        final isActive =
            index == text.length.clamp(0, _otpLength - 1) && hasFocus;

        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.symmetric(horizontal: AppSizes.s4),
            height: 56,
            decoration: BoxDecoration(
              color: isFilled
                  ? AppColors.primary100.withValues(alpha: 0.4)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.s12),
              border: Border.all(
                color: _showError
                    ? AppColors.error
                    : isActive
                    ? AppColors.primary500
                    : isFilled
                    ? AppColors.primary100
                    : AppColors.borderStrong,
                width: isActive ? 1.5 : 1,
              ),
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                transitionBuilder:
                    (
                      Widget child,
                      Animation<double> animation,
                    ) => ScaleTransition(scale: animation, child: child),
                child: isFilled
                    ? Text(
                        text[index],
                        key: ValueKey("digit-$index-${text[index]}"),
                        style: Theme.of(context).textTheme.headlineSmall!
                            .copyWith(color: AppColors.primary900),
                      )
                    : isActive
                    ? Container(
                        key: const ValueKey("cursor"),
                        width: 2,
                        height: 24,
                        color: AppColors.primary500,
                      )
                    : const SizedBox(key: ValueKey("empty")),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHiddenTextField() {
    return Opacity(
      opacity: 0,
      child: SizedBox(
        height: 1,
        child: TextField(
          controller: _otpController,
          focusNode: _otpFocusNode,
          autofocus: true,
          keyboardType: TextInputType.number,
          maxLength: _otpLength,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: _onOtpChanged,
          decoration: const InputDecoration(counterText: ""),
        ),
      ),
    );
  }

  Widget _buildResendRow() {
    final canResend = _remainingSeconds == 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "لم يصلك الرمز؟",
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(color: AppColors.foregroundMuted),
        ),
        const SizedBox(width: AppSizes.s4),
        TextButton(
          onPressed: canResend ? _resendCode : null,
          child: Text(
            canResend ? "إعادة الإرسال" : "إعادة الإرسال بعد $_remainingSeconds ث",
          ),
        ),
      ],
    );
  }
}
