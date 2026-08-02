import 'package:draya_mobile/core/helpers/app_navigator.dart';
import 'package:draya_mobile/core/router/app_routes.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/core/validation/email_validator.dart';
import 'package:draya_mobile/core/validation/password_validator.dart';
import 'package:draya_mobile/core/validation/validation_result.dart';
import 'package:draya_mobile/core/widgets/app_elevated_button.dart';
import 'package:draya_mobile/core/widgets/app_label.dart';
import 'package:draya_mobile/core/widgets/app_logo_and_name.dart';
import 'package:draya_mobile/core/widgets/app_text_form_field.dart';
import 'package:draya_mobile/features/auth/presentation/teacher_signup/cubit/teacher_signup_cubit.dart';
import 'package:draya_mobile/features/auth/presentation/teacher_signup/cubit/teacher_signup_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherSignupTab extends StatefulWidget {
  const TeacherSignupTab({super.key});

  @override
  State<TeacherSignupTab> createState() => _TeacherSignupTabState();
}

class _TeacherSignupTabState extends State<TeacherSignupTab> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _textEditingControllerEmail;
  late final TextEditingController _textEditingControllerPassword;
  late final TextEditingController _textEditingControllerConfirmPassword;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey();
    _textEditingControllerEmail = TextEditingController();
    _textEditingControllerPassword = TextEditingController();
    _textEditingControllerConfirmPassword = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingControllerEmail.dispose();
    _textEditingControllerPassword.dispose();
    _textEditingControllerConfirmPassword.dispose();
    super.dispose();
  }

  void _signUp() {
    if (_formKey.currentState!.validate()) {}
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TeacherSignupCubit, TeacherSignupState>(
      listener: (context, state) {},
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.s8),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSizes.s16,
              children: [
                const AppLogoAndName(),
                const SizedBox(height: AppSizes.s20),
                const AppLabel(label: "Email"),
                AppTextFormField(
                  controller: _textEditingControllerEmail,
                  hintText: "Enter your email address",
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
                const AppLabel(label: "Password"),
                AppTextFormField(
                  controller: _textEditingControllerPassword,
                  hintText: "Enter your password",
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
                const AppLabel(label: "Confirm Password"),
                AppTextFormField(
                  controller: _textEditingControllerConfirmPassword,
                  hintText: "Confirm your password",
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
                    _signUp();
                  },
                  label: "Sign Up",
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        AppNavigator.pushReplacement(
                          context: context,
                          path: AppRoutes.signinPage,
                        );
                      },
                      child: const Text("Sign in"),
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
