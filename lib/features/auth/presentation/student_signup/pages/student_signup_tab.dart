import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/helpers/app_dialog_helper.dart";
import "package:draya_mobile/core/helpers/app_loading.dart";
import "package:draya_mobile/core/helpers/app_navigator.dart";
import "package:draya_mobile/core/router/app_routes.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/validation/email_validator.dart";
import "package:draya_mobile/core/validation/password_validator.dart";
import "package:draya_mobile/core/validation/phone_validator.dart";
import "package:draya_mobile/core/validation/validation_result.dart";
import "package:draya_mobile/core/widgets/app_elevated_button.dart";
import "package:draya_mobile/core/widgets/app_error_dialog.dart";
import "package:draya_mobile/core/widgets/app_label.dart";
import "package:draya_mobile/core/widgets/app_text_form_field.dart";
import "package:draya_mobile/features/auth/data/models/register_student_request_model.dart";
import "package:draya_mobile/features/auth/domain/entity/auth_entity.dart";
import "package:draya_mobile/features/auth/presentation/student_signup/cubit/student_signup_cubit.dart";
import "package:draya_mobile/features/auth/presentation/student_signup/cubit/student_signup_state.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";

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
  late final TextEditingController _textEditingControllerParentGuardianName;
  late final TextEditingController _textEditingControllerParentGuardianPhone;
  late final TextEditingController _textEditingControllerParentGuardianEmail;
  late final TextEditingController _textEditingControllerDateOfBirth;

  DateTime? _dateOfBirth;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey();
    _textEditingControllerEmail = TextEditingController();
    _textEditingControllerPassword = TextEditingController();
    _textEditingControllerConfirmPassword = TextEditingController();
    _textEditingControllerFullName = TextEditingController();
    _textEditingControllerParentGuardianName = TextEditingController();
    _textEditingControllerParentGuardianPhone = TextEditingController();
    _textEditingControllerParentGuardianEmail = TextEditingController();
    _textEditingControllerDateOfBirth = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingControllerEmail.dispose();
    _textEditingControllerPassword.dispose();
    _textEditingControllerConfirmPassword.dispose();
    _textEditingControllerFullName.dispose();
    _textEditingControllerParentGuardianName.dispose();
    _textEditingControllerParentGuardianPhone.dispose();
    _textEditingControllerParentGuardianEmail.dispose();
    _textEditingControllerDateOfBirth.dispose();
    super.dispose();
  }

  Future<DateTime?> _pickDate() async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
  }

  void _signUp({required AuthEntity? authEntity}) {
    AppNavigator.goAndRemove(
      context: context,
      path: authEntity?.user?.role == "Teacher"
          ? AppRoutes.teacherDashboardPage
          : AppRoutes.studentHomePage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StudentSignupCubit, StudentSignupState>(
      listener: (context, state) {
        switch (state.status) {
          case CubitStatus.loading:
            AppLoading.show();
            break;
          case CubitStatus.success:
            AppLoading.hide();
            _signUp(authEntity: state.authEntity);
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
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.s24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSizes.s16,
              children: [
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
                const AppLabel(label: "تاريخ الميلاد*"),
                AppTextFormField(
                  controller: _textEditingControllerDateOfBirth,
                  hintText: "yyyy/MM/dd",
                  isReadOnly: true,
                  validator: (value) {
                    if (_dateOfBirth == null) {
                      return "يرجى اختيار تاريخ الميلاد";
                    }

                    return null;
                  },
                  onTap: () async {
                    final picked = await _pickDate();

                    if (picked != null) {
                      setState(() {
                        _dateOfBirth = picked;
                        _textEditingControllerDateOfBirth.text = DateFormat(
                          "yyyy/MM/dd",
                        ).format(picked);
                      });
                    }
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
                const AppLabel(label: "الاسم الكامل للوالد*"),
                AppTextFormField(
                  controller: _textEditingControllerParentGuardianName,
                  hintText: "أدخل اسمك ثلاثياً",
                  keyboardType: TextInputType.name,
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
                const AppLabel(label: "رقم الهاتف للوالد"),
                AppTextFormField(
                  controller: _textEditingControllerParentGuardianPhone,
                  hintText: "010xxxxxxx / 011xxxxxxx / 012xxxxxxx / 015xxxxxxx",
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.phone_outlined,
                  validator: (value) {
                    final result = PhoneValidator.validate(phone: value);
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
                              parentGuardianName:
                                  _textEditingControllerParentGuardianName.text,
                              parentGuardianPhone:
                                  _textEditingControllerParentGuardianPhone
                                      .text,
                              parentGuardianEmail:
                                  _textEditingControllerParentGuardianEmail
                                      .text,
                              password: _textEditingControllerPassword.text,
                              confirmPassword:
                                  _textEditingControllerConfirmPassword.text,
                              dateOfBirth: _dateOfBirth!,
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
