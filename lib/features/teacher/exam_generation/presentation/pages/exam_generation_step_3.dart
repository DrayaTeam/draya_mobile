import 'package:draya_mobile/core/helpers/app_extensions.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/core/view_models/drawer_model.dart';
import 'package:draya_mobile/core/widgets/app_card_container_empty.dart';
import 'package:draya_mobile/core/widgets/app_drawer.dart';
import 'package:draya_mobile/core/widgets/app_elevated_button.dart';
import 'package:draya_mobile/core/widgets/app_outlined_button.dart';
import 'package:draya_mobile/core/widgets/app_text_form_field.dart';
import 'package:draya_mobile/core/widgets/custom_app_bar.dart';
import 'package:draya_mobile/features/teacher/exam_generation/presentation/widgets/exam_generation_steps.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExamGenerationStep3 extends StatefulWidget {
  const ExamGenerationStep3({super.key});

  @override
  State<ExamGenerationStep3> createState() => _ExamGenerationStep3State();
}

class _ExamGenerationStep3State extends State<ExamGenerationStep3> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _textEditingControllerStartDate;
  late final TextEditingController _textEditingControllerEndDate;
  late final TextEditingController _textEditingControllerExamDuration;

  Future<DateTime?> _pickDate() async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
  }

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey();
    _textEditingControllerStartDate = TextEditingController();
    _textEditingControllerEndDate = TextEditingController();
    _textEditingControllerExamDuration = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingControllerStartDate.dispose();
    _textEditingControllerEndDate.dispose();
    _textEditingControllerExamDuration.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "انشاء امتحان الخطوة 3"),
      drawer: AppDrawer(drawerItemsList: getTeacherDrawerItemsList()),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ExamGenerationSteps(currentStep: 3),
              const SizedBox(height: AppSizes.s20),
              AppCardContainerEmpty(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "اعدادات توزيع الامتحان",
                          style: context.textTheme.labelLarge,
                        ),
                        const SizedBox(height: AppSizes.s12),
                        const Text("تاريخ بداية الامتحان:"),
                        const SizedBox(height: AppSizes.s8),
                        AppTextFormField(
                          controller: _textEditingControllerStartDate,
                          hintText: "yyyy/MM/dd",
                          isReadOnly: true,
                          onTap: () async {
                            final picked = await _pickDate();

                            if (picked != null) {
                              _textEditingControllerStartDate.text = DateFormat(
                                "yyyy/MM/dd",
                              ).format(picked);
                            }
                          },
                        ),
                        const SizedBox(height: AppSizes.s12),
                        const Text("تاريخ انتهاء الامتحان:"),
                        const SizedBox(height: AppSizes.s8),
                        AppTextFormField(
                          controller: _textEditingControllerEndDate,
                          hintText: "yyyy/MM/dd",
                          isReadOnly: true,
                          onTap: () async {
                            final picked = await _pickDate();

                            if (picked != null) {
                              _textEditingControllerEndDate.text = DateFormat(
                                "yyyy/MM/dd",
                              ).format(picked);
                            }
                          },
                        ),
                        const SizedBox(height: AppSizes.s12),
                        const Text("مدة الحل بالدقائق:"),
                        const SizedBox(height: AppSizes.s8),
                        AppTextFormField(
                          controller: _textEditingControllerExamDuration,
                          hintText: "45",
                          keyboardType: const TextInputType.numberWithOptions(),
                          validator: (duration) {
                            if (int.parse(duration ?? "0") < 0) {
                              return "المدة يجب ان تكون اكبر من 0";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSizes.s20),
                        AppElevatedButton(
                          onPressed: () {},
                          label: "جدولة وتوزيع الامتحان",
                        ),
                        const SizedBox(height: AppSizes.s12),
                        AppOutlinedButton(
                          onPressed: () {},
                          label: "الرجوع لتعديل الاسئلة",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
