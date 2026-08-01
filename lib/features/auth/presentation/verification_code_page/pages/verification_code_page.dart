import 'package:draya_mobile/core/helpers/app_extensions.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/core/widgets/app_elevated_button.dart';
import 'package:draya_mobile/core/widgets/app_logo_and_name.dart';
import 'package:draya_mobile/core/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

class VerificationCodePage extends StatefulWidget {
  const VerificationCodePage({super.key});

  @override
  State<VerificationCodePage> createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verification Code"),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.s24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSizes.s20,
              children: [
                const AppLogoAndName(),
                const SizedBox(
                  height: AppSizes.s20,
                ),
                Text(
                  "Enter OTP code",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  "We have sent the verification code to your email address. Please enter it below",
                  style: context.textTheme.bodyMedium,
                ),
                AppTextField(
                  controller: _textEditingController,
                  hintText: "Enter Verification Code",
                ),
                const SizedBox(
                  height: AppSizes.s8,
                ),
                AppElevatedButton(onPressed: () {}, label: "Confirm"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
