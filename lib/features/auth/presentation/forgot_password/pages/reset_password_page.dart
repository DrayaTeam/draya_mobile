import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/helpers/app_dialog_helper.dart";
import "package:draya_mobile/core/helpers/app_loading.dart";
import "package:draya_mobile/core/helpers/app_navigator.dart";
import "package:draya_mobile/core/router/app_routes.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/validation/password_validator.dart";
import "package:draya_mobile/core/validation/validation_result.dart";
import "package:draya_mobile/core/widgets/app_elevated_button.dart";
import "package:draya_mobile/core/widgets/app_error_dialog.dart";
import "package:draya_mobile/core/widgets/app_label.dart";
import "package:draya_mobile/core/widgets/app_text_form_field.dart";
import "package:draya_mobile/features/auth/data/models/confirm_password_reset_model.dart";
import "package:draya_mobile/features/auth/presentation/forgot_password/widgets/password_reset_header.dart";
import "package:draya_mobile/features/auth/presentation/signin/cubit/confirm_password_reset_cubit.dart";
import "package:draya_mobile/features/auth/presentation/signin/cubit/confirm_password_reset_state.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class ResetPasswordPage extends StatefulWidget {
  final String email;
  final String token;

  const ResetPasswordPage({
    super.key,
    required this.email,
    required this.token,
  });

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      context.read<ConfirmPasswordResetCubit>().confirmPasswordReset(
        confirmPasswordResetModel: ConfirmPasswordResetModel(
          token: widget.token,
          newPassword: _newPasswordController.text,
        ),
      );
    }
  }

  void _backToSignin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("تم تغيير كلمة المرور بنجاح"),
        backgroundColor: AppColors.success,
      ),
    );

    AppNavigator.goAndRemove(context: context, path: AppRoutes.signinPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("كلمة المرور الجديدة")),
      body: SafeArea(
        child: BlocListener<ConfirmPasswordResetCubit, ConfirmPasswordResetState>(
          listener: (context, state) {
            switch (state.status) {
              case CubitStatus.loading:
                AppLoading.show();
                break;
              case CubitStatus.success:
                AppLoading.hide();
                _backToSignin();
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
                      currentStep: 2,
                      title: "أنشئ كلمة مرور جديدة",
                      subtitle:
                          "أنت على وشك الانتهاء! يرجى إدخال كلمة مرور جديدة وتأكيدها لحماية حسابك.",
                    ),
                    const SizedBox(height: AppSizes.s32),
                    const AppLabel(label: "كلمة المرور الجديدة*"),
                    const SizedBox(height: AppSizes.s8),
                    AppTextFormField(
                      controller: _newPasswordController,
                      hintText: "••••••••••••",
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Icons.lock_outline,
                      isObscure: true,
                      validator: (value) {
                        final result = PasswordValidator.validate(
                          password: value,
                        );

                        if (result is Invalid) {
                          return result.message;
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.s16),
                    const AppLabel(label: "تأكيد كلمة المرور*"),
                    const SizedBox(height: AppSizes.s8),
                    AppTextFormField(
                      controller: _confirmPasswordController,
                      hintText: "••••••••••••",
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      prefixIcon: Icons.lock_person_outlined,
                      isObscure: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "يرجى تأكيد كلمة المرور";
                        }

                        if (value != _newPasswordController.text) {
                          return "كلمتا المرور غير متطابقتين";
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.s32),
                    AppElevatedButton(
                      onPressed: _resetPassword,
                      label: "تغيير كلمة المرور",
                      icon: const Icon(Icons.check_rounded, size: 20),
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
