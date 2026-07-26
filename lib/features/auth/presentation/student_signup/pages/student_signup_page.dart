import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/features/auth/domain/enums/user_role.dart';
import 'package:draya_mobile/features/auth/domain/validation/email_validator.dart';
import 'package:draya_mobile/features/auth/domain/validation/password_validator.dart';
import 'package:draya_mobile/features/auth/domain/validation/validation_result.dart';
import 'package:draya_mobile/features/auth/presentation/signin/pages/signin_page.dart';
import 'package:draya_mobile/features/auth/presentation/student_signup/cubit/student_signup_cubit.dart';
import 'package:draya_mobile/features/auth/presentation/student_signup/cubit/student_signup_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentSignupPage extends StatefulWidget {
  const StudentSignupPage({super.key});

  @override
  State<StudentSignupPage> createState() => _StudentSignupPageState();
}

class _StudentSignupPageState extends State<StudentSignupPage> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _textEditingControllerEmail;
  late final TextEditingController _textEditingControllerPassword;
  late final TextEditingController _textEditingControllerConfirmPassword;
  bool _isPasswordVisible = false;

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
    return BlocListener<StudentSignupCubit, StudentSignupState>(
      listener: (context, state) {
        if (state is NavigateToSignin) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const SigninPage(userRole: UserRole.student),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Student Sign up"),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.s8),
            child: Form(
              key: _formKey,
              child: Column(
                spacing: AppSizes.s16,
                children: [
                  const SizedBox(height: AppSizes.s20),
                  TextFormField(
                    controller: _textEditingControllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus!.unfocus();
                    },
                    decoration: const InputDecoration(
                      labelText: "Email",
                      hintText: "Enter your email",
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      final result = EmailValidator.validate(email: value);

                      if (result is Invalid) {
                        return result.message;
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _textEditingControllerPassword,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus!.unfocus();
                    },
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Enter your password",
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    obscureText: !_isPasswordVisible,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  TextFormField(
                    controller: _textEditingControllerConfirmPassword,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus!.unfocus();
                    },
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      hintText: "Enter your password again",
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    obscureText: !_isPasswordVisible,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (_textEditingControllerPassword.text !=
                          _textEditingControllerConfirmPassword.text) {
                        return "password mismatch";
                      }

                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _signUp();
                    },
                    child: const Text("Sign up"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("already have an account?"),
                      TextButton(
                        onPressed: () {
                          context.read<StudentSignupCubit>().navigateToSignin();
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
      ),
    );
  }
}
