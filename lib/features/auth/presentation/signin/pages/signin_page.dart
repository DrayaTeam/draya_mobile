import 'package:draya_mobile/core/constants/app_shared_pref_keys.dart';
import 'package:draya_mobile/core/enums/cubit_status.dart';
import 'package:draya_mobile/core/helpers/app_dialog_helper.dart';
import 'package:draya_mobile/core/helpers/app_navigator.dart';
import 'package:draya_mobile/core/helpers/app_shared_pref_helper.dart';
import 'package:draya_mobile/core/helpers/app_token_helper.dart';
import 'package:draya_mobile/core/networking/dio_factory.dart';
import 'package:draya_mobile/core/router/app_routes.dart';
import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/core/validation/email_validator.dart';
import 'package:draya_mobile/core/validation/password_validator.dart';
import 'package:draya_mobile/core/validation/validation_result.dart';
import 'package:draya_mobile/core/widgets/app_check_box.dart';
import 'package:draya_mobile/core/widgets/app_custom_loading.dart';
import 'package:draya_mobile/core/widgets/app_elevated_button.dart';
import 'package:draya_mobile/core/widgets/app_error_dialog.dart';
import 'package:draya_mobile/core/widgets/app_label.dart';
import 'package:draya_mobile/core/widgets/app_logo_and_name.dart';
import 'package:draya_mobile/core/widgets/app_text_form_field.dart';
import 'package:draya_mobile/features/auth/data/models/login_request_model.dart';
import 'package:draya_mobile/features/auth/domain/entity/auth_entity.dart';
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
    _textEditingControllerEmail = TextEditingController(text: "email@mail.com");
    _textEditingControllerPassword = TextEditingController(text: "@Aa12345");
  }

  @override
  void dispose() {
    _textEditingControllerEmail.dispose();
    _textEditingControllerPassword.dispose();
    super.dispose();
  }

  void _signIn({
    required AuthEntity? authEntity,
    required bool rememberMe,
  }) async {
    await AppSharedPrefHelper.setSecuredString(
      AppSharedPrefKeys.userToken,
      authEntity?.accessToken ?? '',
    );
    await AppSharedPrefHelper.setData(
      AppSharedPrefKeys.userRole,
      authEntity?.user?.role ?? '',
    );

    await AppSharedPrefHelper.setData(
      AppSharedPrefKeys.rememberMe,
      rememberMe,
    );
    AppTokenHelper.isLoggedIn = true;
    DioFactory.setTokenIntoHeader(authEntity?.accessToken ?? '');
    if (mounted) {
      AppNavigator.goAndRemove(
        context: context,
        path: authEntity?.user?.role == 'Teacher'
            ? AppRoutes.teacherDashboardPage
            : AppRoutes.studentHomePage,
      );
    }
  }

  void _handleForgotPassword() {
    _validateEmailOnly = true;
    // todo: pass email to verification code page
    AppNavigator.push(context: context, path: AppRoutes.verificationCodePage);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SigninCubit, SigninState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch (state.status) {
          case CubitStatus.initial:
            break;
          case CubitStatus.loading:
            AppDialogHelper.display(context, const AppCustomLoading());
            break;
          case CubitStatus.error:
            AppNavigator.pop(context: context);
            AppDialogHelper.display(
              context,
              AppErrorDialog(
                apiErrorModel: state.apiErrorModel!,
                onRetry: () {},
              ),
            );
            break;
          case CubitStatus.success:
            AppNavigator.pop(context: context);
            _signIn(authEntity: state.authEntity, rememberMe: state.rememberMe);
            break;
        }
      },
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
                        BlocBuilder<SigninCubit, SigninState>(
                          buildWhen: (previous, current) =>
                              previous.rememberMe != current.rememberMe,
                          builder: (context, state) => AppCheckBox(
                            label: "تذكرني",
                            value: state.rememberMe,
                            onChanged: (value) {
                              context.read<SigninCubit>().toggleRememberMe();
                            },
                          ),
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
                        if (_formKey.currentState!.validate()) {
                          context.read<SigninCubit>().signin(
                            loginRequestModel: LoginRequestModel(
                              email: _textEditingControllerEmail.text,
                              password: _textEditingControllerPassword.text,
                            ),
                          );
                        }
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
                            AppNavigator.pushReplacement(
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
