import 'package:draya_mobile/core/helpers/app_extensions.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/core/view_models/drawer_model.dart';
import 'package:draya_mobile/core/widgets/app_drawer.dart';
import 'package:draya_mobile/core/widgets/app_elevated_button.dart';
import 'package:draya_mobile/core/widgets/app_expandable_question_card.dart';
import 'package:draya_mobile/core/widgets/app_outlined_button.dart';
import 'package:draya_mobile/core/widgets/custom_app_bar.dart';
import 'package:draya_mobile/features/teacher/exam_generation/presentation/widgets/exam_generation_steps.dart';
import 'package:flutter/material.dart';

class ExamGenerationStep2 extends StatefulWidget {
  const ExamGenerationStep2({super.key});

  @override
  State<ExamGenerationStep2> createState() => _ExamGenerationStep2State();
}

class _ExamGenerationStep2State extends State<ExamGenerationStep2> {
  final List<
    ({
      String title,
      String subtitle,
      String label,
      List<String> choices,
    })
  >
  _questions = [
    (
      title: "Question #1",
      subtitle: "Question #1 content",
      label: "Easy",
      choices: [
        "Choice #1",
        "Choice #2",
        "Choice #3",
        "Choice #4",
      ],
    ),
    (
      title: "Question #2",
      subtitle: "Question #2 content",
      label: "Medium",
      choices: [
        "Choice #1",
        "Choice #2",
        "Choice #3",
        "Choice #4",
      ],
    ),
    (
      title: "Question #3",
      subtitle: "Question #3 content",
      label: "Hard",
      choices: [
        "Choice #1",
        "Choice #2",
        "Choice #3",
        "Choice #4",
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "انشاء امتحان الخطوة 2"),
      drawer: AppDrawer(drawerItemsList: getTeacherDrawerItemsList()),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ExamGenerationSteps(currentStep: 2),
              const SizedBox(height: AppSizes.s20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "مراجعة الاسئلة",
                    style: context.textTheme.labelLarge,
                  ),
                  const Spacer(),
                  Flexible(
                    flex: 2,
                    child: AppOutlinedButton(
                      onPressed: () {},
                      label: "اضافة سؤال",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.s20),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final question = _questions[index];

                  return AppExpandableQuestionCard(
                    title: question.title,
                    subtitle: question.subtitle,
                    label: question.label,
                    onDelete: () {},
                    children: question.choices
                        .map((choice) => Text(choice))
                        .toList(),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: AppSizes.s12);
                },
                itemCount: _questions.length,
              ),
              const SizedBox(height: AppSizes.s20),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AppElevatedButton(
                    onPressed: () {},
                    label: "تاكيد الاسئلة ومتابعة التوزيع",
                  ),
                  const SizedBox(height: AppSizes.s20),
                  AppOutlinedButton(
                    onPressed: () {},
                    label: "الرجوع لتغيير الاعدادات",
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
