import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/helpers/app_dialog_helper.dart";
import "package:draya_mobile/core/helpers/app_loading.dart";
import "package:draya_mobile/core/helpers/app_navigator.dart";
import "package:draya_mobile/core/router/app_routes.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/validation/email_validator.dart";
import "package:draya_mobile/core/validation/validation_result.dart";
import "package:draya_mobile/core/widgets/app_elevated_button.dart";
import "package:draya_mobile/core/widgets/app_error_dialog.dart";
import "package:draya_mobile/core/widgets/app_label.dart";
import "package:draya_mobile/core/widgets/app_text_form_field.dart";
import "package:draya_mobile/features/auth/data/models/request_password_reset_model.dart";
import "package:draya_mobile/features/auth/presentation/forgot_password/widgets/password_reset_header.dart";
import "package:draya_mobile/features/auth/presentation/signin/cubit/signin_cubit.dart";
import "package:draya_mobile/features/auth/presentation/signin/cubit/signin_state.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendCode() {
    if (_formKey.currentState!.validate()) {
      context.read<SigninCubit>().requestPasswordReset(
        requestPasswordResetModel: RequestPasswordResetModel(
          email: _emailController.text.trim(),
        ),
      );
    }
  }

  void _goToOtpPage(String email) {
    AppNavigator.push(
      context: context,
      path: AppRoutes.verificationCodePage,
      queryParameters: {"email": email},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("نسيت كلمة المرور")),
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
                _goToOtpPage(_emailController.text.trim());
                break;
              case CubitStatus.error:
                AppLoading.hide();
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PasswordResetHeader(
                      currentStep: 0,
                      title: "أدخل بريدك الإلكتروني",
                      subtitle:
                          "سنرسل لك رمز تحقق مكوّن من 6 أرقام لتتمكن من إعادة تعيين كلمة المرور الخاصة بحسابك.",
                    ),
                    const SizedBox(height: AppSizes.s32),
                    const AppLabel(label: "البريد الإلكتروني*"),
                    const SizedBox(height: AppSizes.s8),
                    AppTextFormField(
                      hintText: "name@example.com",
                      prefixIcon: Icons.email_outlined,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        final result = EmailValidator.validate(email: value);

                        if (result is Invalid) {
                          return result.message;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.s32),
                    BlocBuilder<SigninCubit, SigninState>(
                      buildWhen: (previous, current) =>
                          previous.requestPasswordResetStatus !=
                          current.requestPasswordResetStatus,
                      builder: (context, state) {
                        final isLoading =
                            state.requestPasswordResetStatus ==
                            CubitStatus.loading;

                        return AppElevatedButton(
                          onPressed: isLoading ? null : _sendCode,
                          label: "إرسال الرمز",
                          icon: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.surface,
                                  ),
                                )
                              : const Icon(Icons.send_rounded, size: 20),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
