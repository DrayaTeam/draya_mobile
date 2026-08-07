import 'package:draya_mobile/core/constants/app_shared_pref_keys.dart';
import 'package:draya_mobile/core/helpers/app_dialog_helper.dart';
import 'package:draya_mobile/core/helpers/app_navigator.dart';
import 'package:draya_mobile/core/helpers/app_shared_pref_helper.dart';
import 'package:draya_mobile/core/helpers/app_token_helper.dart';
import 'package:draya_mobile/core/networking/dio_factory.dart';
import 'package:draya_mobile/core/router/app_routes.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/core/validation/email_validator.dart';
import 'package:draya_mobile/core/validation/password_validator.dart';
import 'package:draya_mobile/core/validation/validation_result.dart';
import 'package:draya_mobile/core/widgets/app_custom_loading.dart';
import 'package:draya_mobile/core/widgets/app_elevated_button.dart';
import 'package:draya_mobile/core/widgets/app_error_dialog.dart';
import 'package:draya_mobile/core/widgets/app_label.dart';
import 'package:draya_mobile/core/widgets/app_logo_and_name.dart';
import 'package:draya_mobile/core/widgets/app_text_form_field.dart';
import 'package:draya_mobile/features/auth/data/models/register_student_request_model.dart';
import 'package:draya_mobile/features/auth/domain/entity/auth_entity.dart';
import 'package:draya_mobile/features/auth/presentation/student_signup/cubit/student_signup_cubit.dart';
import 'package:draya_mobile/features/auth/presentation/student_signup/cubit/student_signup_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentSignupTab extends StatefulWidget {
  const StudentSignupTab({super.key});

  @override
  State<StudentSignupTab> createState() => _StudentSignupTabState();
}

class _StudentSignupTabState extends State<StudentSignupTab> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _textEditingControllerEmail;
  late final TextEditingController _textEditingControllerPassword;
  late final TextEditingController _textEditingControllerConfirmPassword;
  late final TextEditingController _textEditingControllerFullName;
  late final TextEditingController _textEditingControllerParentGuardianEmail;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey();
    _textEditingControllerEmail = TextEditingController();
    _textEditingControllerPassword = TextEditingController();
    _textEditingControllerConfirmPassword = TextEditingController();
    _textEditingControllerFullName = TextEditingController();
    _textEditingControllerParentGuardianEmail = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingControllerEmail.dispose();
    _textEditingControllerPassword.dispose();
    _textEditingControllerConfirmPassword.dispose();
    _textEditingControllerFullName.dispose();
    _textEditingControllerParentGuardianEmail.dispose();
    super.dispose();
  }

  void _signUp({
    required AuthEntity? authEntity,
  }) async {
    await AppSharedPrefHelper.setSecuredString(
      AppSharedPrefKeys.userToken,
      authEntity?.accessToken ?? '',
    );
    await AppSharedPrefHelper.setData(
      AppSharedPrefKeys.userRole,
      authEntity?.user?.role ?? '',
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<StudentSignupCubit, StudentSignupState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        state.maybeWhen(
          orElse: () => {},
          loading: () {
            AppDialogHelper.display(context, const AppCustomLoading());
          },
          success: (authEntity) {
            AppNavigator.pop(context: context);
            _signUp(authEntity: authEntity);
          },
          failure: (apiErrorModel) {
            AppNavigator.pop(context: context);
            AppDialogHelper.display(
              context,
              AppErrorDialog(
                apiErrorModel: apiErrorModel,
                onRetry: () {},
              ),
            );
          },
        );
      },
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.s24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSizes.s16,
              children: [
                const AppLogoAndName(),
                const SizedBox(height: AppSizes.s20),
                const AppLabel(label: "الاسم الكامل*"),
                AppTextFormField(
                  controller: _textEditingControllerFullName,
                  hintText: "أدخل اسمك ثلاثياً",
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "الاسم الكامل مطلوب";
                    }
                    if (value.length < 3) {
                      return "الاسم الكامل يجب ان يكون اكثر من 3 حروف";
                    }
                    return null;
                  },
                ),
                const AppLabel(label: "البريد الالكتروني*"),
                AppTextFormField(
                  controller: _textEditingControllerEmail,
                  hintText: "name@example.com",
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.email_outlined,
                  validator: (value) {
                    final result = EmailValidator.validate(email: value);

                    if (result is Invalid) {
                      return result.message;
                    }
                    return null;
                  },
                ),
                const AppLabel(label: "البريد الالكتروني للوالد*"),
                AppTextFormField(
                  controller: _textEditingControllerParentGuardianEmail,
                  hintText: "name@example.com",
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.email_outlined,
                  validator: (value) {
                    final result = EmailValidator.validate(email: value);

                    if (result is Invalid) {
                      return result.message;
                    }
                    return null;
                  },
                ),
                const AppLabel(label: "كلمة المرور*"),
                AppTextFormField(
                  controller: _textEditingControllerPassword,
                  hintText: "••••••••",
                  prefixIcon: Icons.lock_outline,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
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
                const AppLabel(label: "تأكيد كلمة المرور*"),
                AppTextFormField(
                  controller: _textEditingControllerConfirmPassword,
                  hintText: "••••••••",
                  prefixIcon: Icons.lock_outline,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                  isObscure: true,
                  validator: (value) {
                    if (_textEditingControllerPassword.text !=
                        _textEditingControllerConfirmPassword.text) {
                      return "password mismatch";
                    }

                    return null;
                  },
                ),
                AppElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<StudentSignupCubit>().registerStudent(
                        registerStudentRequestModel:
                            RegisterStudentRequestModel(
                              fullName: _textEditingControllerFullName.text,
                              email: _textEditingControllerEmail.text,
                              parentGuardianEmail:
                                  _textEditingControllerParentGuardianEmail
                                      .text,
                              password: _textEditingControllerPassword.text,
                            ),
                      );
                    }
                  },
                  label: "إنشاء الحساب",
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("لديك حساب بالفعل؟"),
                    TextButton(
                      onPressed: () {
                        AppNavigator.pushReplacement(
                          context: context,
                          path: AppRoutes.signinPage,
                        );
                      },
                      child: const Text("تسجيل الدخول"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
