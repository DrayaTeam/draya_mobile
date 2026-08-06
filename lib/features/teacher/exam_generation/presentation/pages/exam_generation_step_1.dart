import 'dart:math';

import 'package:draya_mobile/core/helpers/app_extensions.dart';
import 'package:draya_mobile/core/helpers/app_navigator.dart';
import 'package:draya_mobile/core/router/app_routes.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/core/view_models/drawer_model.dart';
import 'package:draya_mobile/core/widgets/app_card_container_empty.dart';
import 'package:draya_mobile/core/widgets/app_drawer.dart';
import 'package:draya_mobile/core/widgets/app_drop_down_form_field.dart';
import 'package:draya_mobile/core/widgets/app_elevated_button.dart';
import 'package:draya_mobile/core/widgets/custom_app_bar.dart';
import 'package:draya_mobile/features/teacher/exam_generation/presentation/widgets/counter_container.dart';
import 'package:draya_mobile/features/teacher/exam_generation/presentation/widgets/exam_generation_steps.dart';
import 'package:flutter/material.dart';

class ExamGenerationStep1 extends StatefulWidget {
  const ExamGenerationStep1({super.key});

  @override
  State<ExamGenerationStep1> createState() => _ExamGenerationStep1State();
}

class _ExamGenerationStep1State extends State<ExamGenerationStep1> {
  int _numberOfQuestions = 1;
  String? _academicYear = "item1";
  String? _academicGroup = "item1";
  String? _questionsSource = "item1";
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey();
  }

  void _nextStep() {
    if (_formKey.currentState!.validate()) {
      AppNavigator.push(
        context: context,
        path: AppRoutes.examGenerationPage2,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "انشاء امتحان الخطوة 1"),
      drawer: AppDrawer(drawerItemsList: getTeacherDrawerItemsList()),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ExamGenerationSteps(currentStep: 1),
              const SizedBox(height: AppSizes.s20),
              AppCardContainerEmpty(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "عدد اسئلة الامتحان:",
                              style: context.textTheme.labelLarge,
                            ),
                            CounterContainer(
                              counter: _numberOfQuestions,
                              increase: () {
                                setState(() {
                                  _numberOfQuestions++;
                                });
                              },
                              decrease: () {
                                setState(() {
                                  _numberOfQuestions = max(
                                    1,
                                    _numberOfQuestions - 1,
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.s8),
                        const Divider(),
                        const SizedBox(height: AppSizes.s8),
                        Text(
                          "السنة الدراسية:",
                          style: context.textTheme.labelLarge,
                        ),
                        const SizedBox(height: AppSizes.s8),
                        AppDropDownFormField(
                          hint: "السنة الدراسية",
                          value: _academicYear,
                          items: [
                            "item1",
                            "item2",
                            "item3",
                            "item4",
                            "item5",
                          ],
                          onChanged: (value) {
                            setState(() {
                              _academicYear = value;
                            });
                          },
                        ),
                        const SizedBox(height: AppSizes.s20),
                        Text(
                          "المجموعة الدراسية:",
                          style: context.textTheme.labelLarge,
                        ),
                        const SizedBox(height: AppSizes.s8),
                        AppDropDownFormField(
                          hint: "المجموعة الدراسية",
                          value: _academicGroup,
                          items: [
                            "item1",
                            "item2",
                            "item3",
                            "item4",
                            "item5",
                          ],
                          onChanged: (value) {
                            setState(() {
                              _academicGroup = value;
                            });
                          },
                        ),
                        const SizedBox(height: AppSizes.s20),
                        Text(
                          "مصدر الاسئلة:",
                          style: context.textTheme.labelLarge,
                        ),
                        const SizedBox(height: AppSizes.s8),
                        AppDropDownFormField(
                          hint: "مصدر الاسئلة",
                          value: _questionsSource,
                          items: [
                            "item1",
                            "item2",
                            "item3",
                            "item4",
                            "item5",
                          ],
                          onChanged: (value) {
                            setState(() {
                              _questionsSource = value;
                            });
                          },
                        ),
                        const SizedBox(height: AppSizes.s20),
                        AppElevatedButton(
                          onPressed: () {
                            _nextStep();
                          },
                          label: "انشاء امتحان",
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
