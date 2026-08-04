import 'package:draya_mobile/core/helpers/app_navigator.dart';
import 'package:draya_mobile/core/router/app_routes.dart';
import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/core/validation/email_validator.dart';
import 'package:draya_mobile/core/validation/password_validator.dart';
import 'package:draya_mobile/core/validation/validation_result.dart';
import 'package:draya_mobile/core/widgets/app_check_box.dart';
import 'package:draya_mobile/core/widgets/app_elevated_button.dart';
import 'package:draya_mobile/core/widgets/app_label.dart';
import 'package:draya_mobile/core/widgets/app_logo_and_name.dart';
import 'package:draya_mobile/core/widgets/app_text_form_field.dart';
import 'package:draya_mobile/features/auth/presentation/signin/cubit/signin_cubit.dart';
import 'package:draya_mobile/features/auth/presentation/signin/cubit/signin_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({
    super.key,
  });

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _textEditingControllerEmail;
  late final TextEditingController _textEditingControllerPassword;
  bool _validateEmailOnly = false;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey();
    _textEditingControllerEmail = TextEditingController();
    _textEditingControllerPassword = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingControllerEmail.dispose();
    _textEditingControllerPassword.dispose();
    super.dispose();
  }

  void _signIn() {
    _validateEmailOnly = false;
    if (_formKey.currentState!.validate()) {
      AppNavigator.goAndRemove(
        context: context,
        path: AppRoutes.teacherDashboardPage,
      );
    }
  }

  void _handleForgotPassword() {
    _validateEmailOnly = true;
    if (_formKey.currentState!.validate()) {
      // todo: pass email to verification code page
      AppNavigator.push(context: context, path: AppRoutes.verificationCodePage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SigninCubit, SigninState>(
      listener: (context, state) {},
      child: Scaffold(
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
                    const SizedBox(height: AppSizes.s64),
                    Text(
                      "تسجيل الدخول",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppSizes.s4),
                    Text(
                      "أهلاً بك مجدداً! يرجى إدخال البريد الإلكتروني وكلمة المرور للمتابعة.",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.foregroundMuted,
                      ),
                    ),
                    const SizedBox(height: AppSizes.s32),
                    const AppLabel(label: "البريد الإلكتروني*"),
                    const SizedBox(height: AppSizes.s8),
                    AppTextFormField(
                      hintText: "name@example.com",
                      prefixIcon: Icons.email_outlined,
                      controller: _textEditingControllerEmail,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        final result = EmailValidator.validate(email: value);

                        if (result is Invalid) {
                          return result.message;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.s16),
                    const AppLabel(label: "كلمة المرور*"),
                    const SizedBox(height: AppSizes.s8),
                    AppTextFormField(
                      controller: _textEditingControllerPassword,
                      hintText: "••••••••••••",
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Icons.lock_outline,
                      isObscure: true,
                      validator: (value) {
                        if (_validateEmailOnly) return null;

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppCheckBox(
                          label: "تذكرني",
                          value: false,
                          onChanged: (value) {},
                        ),
                        TextButton(
                          onPressed: () {
                            _handleForgotPassword();
                          },
                          child: const Text("نسيت كلمة المرور؟"),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.s16),
                    AppElevatedButton(
                      onPressed: () {
                        _signIn();
                      },
                      label: "تسجيل الدخول",
                    ),
                    const SizedBox(height: AppSizes.s16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("ليس لديك حساب؟"),
                        TextButton(
                          onPressed: () {
                            AppNavigator.push(
                              context: context,
                              path: AppRoutes.signupPage,
                            );
                          },
                          child: const Text(
                            "أنشئ حساباً جديداً",
                          ),
                        ),
                      ],
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
