import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/helpers/app_dialog_helper.dart";
import "package:draya_mobile/core/helpers/app_extensions.dart";
import "package:draya_mobile/core/helpers/app_loading.dart";
import "package:draya_mobile/core/helpers/app_navigator.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/validation/password_validator.dart";
import "package:draya_mobile/core/validation/validation_result.dart";
import "package:draya_mobile/core/widgets/app_elevated_button.dart";
import "package:draya_mobile/core/widgets/app_error_dialog.dart";
import "package:draya_mobile/core/widgets/app_label.dart";
import "package:draya_mobile/core/widgets/app_logo_and_name.dart";
import "package:draya_mobile/core/widgets/app_text_form_field.dart";
import "package:draya_mobile/features/auth/data/models/confirm_password_reset_model.dart";
import "package:draya_mobile/features/auth/presentation/signin/cubit/confirm_password_reset_cubit.dart";
import "package:draya_mobile/features/auth/presentation/signin/cubit/confirm_password_reset_state.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class VerificationCodePage extends StatefulWidget {
  final String email;
  const VerificationCodePage({super.key, required this.email});

  @override
  State<VerificationCodePage> createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _textEditingControllerEmail;
  late final TextEditingController _textEditingControllerVerificationCode;
  late final TextEditingController _textEditingControllerNewPassword;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey();
    _textEditingControllerEmail = TextEditingController(text: widget.email);
    _textEditingControllerVerificationCode = TextEditingController();
    _textEditingControllerNewPassword = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingControllerEmail.dispose();
    _textEditingControllerVerificationCode.dispose();
    _textEditingControllerNewPassword.dispose();
    super.dispose();
  }

  void _changePassword() {
    if (_formKey.currentState!.validate()) {
      context.read<ConfirmPasswordResetCubit>().confirmPasswordReset(
        confirmPasswordResetModel: ConfirmPasswordResetModel(
          token: _textEditingControllerVerificationCode.text,
          newPassword: _textEditingControllerNewPassword.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConfirmPasswordResetCubit, ConfirmPasswordResetState>(
      listener: (BuildContext context, ConfirmPasswordResetState state) {
        switch (state.status) {
          case CubitStatus.loading:
            AppLoading.show();
            break;
          case CubitStatus.success:
            AppLoading.hide();
            AppNavigator.pop<bool>(context: context, result: true);
            break;
          case CubitStatus.error:
            AppLoading.hide();
            AppDialogHelper.display(
              context,
              AppErrorDialog(
                apiErrorModel: state.apiErrorModel!,
              ),
            );
          default:
            break;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Verification Code"),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.s24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppLogoAndName(),
                    const SizedBox(height: AppSizes.s32),

                    const AppLabel(label: "البريد الإلكتروني*"),
                    const SizedBox(height: AppSizes.s8),
                    Text(
                      widget.email,
                      style: context.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: AppSizes.s20),

                    Text(
                      "لقد أرسلنا رمز التحقق إلى بريدك الإلكتروني. يرجى إدخاله",
                      style: context.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSizes.s8),
                    AppTextFormField(
                      hintText: "رمز التحقق",
                      prefixIcon: Icons.domain_verification_outlined,
                      controller: _textEditingControllerVerificationCode,
                      keyboardType: const TextInputType.numberWithOptions(),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "يرجى ادخال رمز التحقق";
                        }

                        if (value.length < 6) {
                          return "رمز التحقق مكون من 6 ارقام";
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.s20),

                    const AppLabel(label: "كلمة المرور الجديدة*"),
                    const SizedBox(height: AppSizes.s8),
                    AppTextFormField(
                      controller: _textEditingControllerNewPassword,
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
                    const SizedBox(height: AppSizes.s20),

                    AppElevatedButton(
                      onPressed: () {
                        _changePassword();
                      },
                      label: "تغيير كلمة المرور",
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
