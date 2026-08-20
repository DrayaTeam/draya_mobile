import "package:draya_mobile/core/helpers/app_extensions.dart";
import "package:draya_mobile/core/helpers/app_navigator.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/view_models/drawer_model.dart";
import "package:draya_mobile/core/widgets/app_drawer.dart";
import "package:draya_mobile/core/widgets/app_drop_down_form_field.dart";
import "package:draya_mobile/core/widgets/app_elevated_button.dart";
import "package:draya_mobile/core/widgets/app_text_form_field.dart";
import "package:draya_mobile/core/widgets/custom_app_bar.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/create_classroom_request_model.dart";
import "package:draya_mobile/features/teacher/classrooms/presentation/cubit/classroom_cubit.dart";
import "package:draya_mobile/features/teacher/classrooms/presentation/cubit/classroom_types_cubit.dart";
import "package:draya_mobile/features/teacher/classrooms/presentation/cubit/classroom_types_state.dart";
import "package:draya_mobile/features/teacher/classrooms/presentation/cubit/grade_levels_cubit.dart";
import "package:draya_mobile/features/teacher/classrooms/presentation/cubit/grade_levels_state.dart";
import "package:draya_mobile/features/teacher/subjects/presentation/cubit/subject_cubit.dart";
import "package:draya_mobile/features/teacher/subjects/presentation/cubit/subject_state.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";

class CreateClassroomPage extends StatefulWidget {
  const CreateClassroomPage({super.key});

  @override
  State<CreateClassroomPage> createState() => _CreateClassroomPageState();
}

class _CreateClassroomPageState extends State<CreateClassroomPage> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _textEditingControllerName;
  late final TextEditingController _textEditingControllerStartDate;
  late final TextEditingController _textEditingControllerEndDate;
  late final TextEditingController _textEditingControllerPrice;

  String? _selectedSubjectId;

  String? _selectedClassroomTypeId;

  String? _selectedGradeLevelId;

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey();

    _textEditingControllerName = TextEditingController();
    _textEditingControllerStartDate = TextEditingController();
    _textEditingControllerEndDate = TextEditingController();
    _textEditingControllerPrice = TextEditingController();

    context.read<SubjectCubit>().getSubjects();
    context.read<ClassroomTypesCubit>().getClassroomTypes();
    context.read<GradeLevelsCubit>().getGradeLevels();
  }

  @override
  void dispose() {
    _textEditingControllerName.dispose();
    _textEditingControllerStartDate.dispose();
    _textEditingControllerEndDate.dispose();
    _textEditingControllerPrice.dispose();
    super.dispose();
  }

  Future<DateTime?> _pickDate() async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
  }

  Future<void> _createClassroom() async {
    if (_formKey.currentState!.validate()) {
      await context.read<ClassroomCubit>().createClassroom(
        CreateClassroomRequestModel(
          subjectId: _selectedSubjectId!,
          name: _textEditingControllerName.text,
          classroomTypeId: _selectedClassroomTypeId!,
          gradeLevelId: _selectedGradeLevelId!,
          startDate: _startDate!,
          endDate: _endDate!,
          price: double.parse(_textEditingControllerPrice.text),
        ),
      );

      if (mounted) {
        AppNavigator.pop(context: context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "انشاء فصل دراسى"),
      drawer: AppDrawer(drawerItemsList: getTeacherDrawerItemsList()),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "اسم الفصل",
                      style: context.textTheme.labelLarge,
                    ),
                    const SizedBox(height: AppSizes.s8),
                    AppTextFormField(
                      controller: _textEditingControllerName,
                      hintText: "اسم الفصل",
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? "أدخل اسم الفصل"
                          : null,
                    ),
                    const SizedBox(height: AppSizes.s20),

                    _buildSubjectDropdown(context),
                    const SizedBox(height: AppSizes.s20),

                    _buildClassroomTypeDropdown(context),
                    const SizedBox(height: AppSizes.s20),

                    _buildGradeLevelDropdown(context),
                    const SizedBox(height: AppSizes.s20),

                    Text(
                      "تاريخ البداية",
                      style: context.textTheme.labelLarge,
                    ),
                    const SizedBox(height: AppSizes.s8),
                    AppTextFormField(
                      controller: _textEditingControllerStartDate,
                      hintText: "yyyy/MM/dd",
                      isReadOnly: true,
                      validator: (value) {
                        if (_startDate == null) {
                          return "يرجى اختيار تاريخ البداية";
                        }

                        return null;
                      },
                      onTap: () async {
                        final picked = await _pickDate();

                        if (picked != null) {
                          setState(() {
                            _startDate = picked;
                            _textEditingControllerStartDate.text = DateFormat(
                              "yyyy/MM/dd",
                            ).format(picked);

                            if (_endDate != null &&
                                !_endDate!.isAfter(_startDate!)) {
                              _endDate = null;
                              _textEditingControllerEndDate.clear();
                            }
                          });
                        }
                      },
                    ),
                    const SizedBox(height: AppSizes.s20),
                    Text(
                      "تاريخ النهاية",
                      style: context.textTheme.labelLarge,
                    ),
                    const SizedBox(height: AppSizes.s8),
                    AppTextFormField(
                      controller: _textEditingControllerEndDate,
                      hintText: "yyyy/MM/dd",
                      isReadOnly: true,
                      validator: (value) {
                        if (_endDate == null) {
                          return "يرجى اختيار تاريخ النهاية";
                        }

                        if (_startDate != null &&
                            !_endDate!.isAfter(_startDate!)) {
                          return "يجب أن يكون تاريخ النهاية بعد تاريخ البداية";
                        }

                        return null;
                      },
                      onTap: () async {
                        final picked = await _pickDate();

                        if (picked != null) {
                          setState(() {
                            _endDate = picked;
                            _textEditingControllerEndDate.text = DateFormat(
                              "yyyy/MM/dd",
                            ).format(picked);
                          });
                        }
                      },
                    ),
                    const SizedBox(height: AppSizes.s20),
                    Text(
                      "سعر الفصل",
                      style: context.textTheme.labelLarge,
                    ),
                    const SizedBox(height: AppSizes.s8),
                    AppTextFormField(
                      controller: _textEditingControllerPrice,
                      hintText: "سعر الفصل",
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "يرجى إدخال رقم";
                        }

                        final number = double.tryParse(value.trim());

                        if (number == null) {
                          return "يرجى إدخال رقم صحيح";
                        }

                        if (number <= 0) {
                          return "يجب أن يكون الرقم أكبر من صفر";
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.s20),
                    AppElevatedButton(
                      onPressed: () async {
                        await _createClassroom();
                      },
                      label: "انشئ فصل جديد",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectDropdown(BuildContext context) {
    return BlocBuilder<SubjectCubit, SubjectState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "اختر المادة الدراسية",
              style: context.textTheme.labelLarge,
            ),
            const SizedBox(height: AppSizes.s8),

            AppDropDownFormField(
              hint: "اختر المادة الدراسية",
              value: _selectedSubjectId,
              dropDownItems: state.subjects
                  .map(
                    (subject) => DropdownMenuItem<String>(
                      value: subject.id,
                      child: Text(subject.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSubjectId = value;
                });
              },
              isRequired: true,
            ),
          ],
        );
      },
    );
  }

  Widget _buildClassroomTypeDropdown(BuildContext context) {
    return BlocBuilder<ClassroomTypesCubit, ClassroomTypesState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "اختر نوع الفصل",
              style: context.textTheme.labelLarge,
            ),
            const SizedBox(height: AppSizes.s8),

            AppDropDownFormField(
              hint: "اختر نوع الفصل",
              value: _selectedClassroomTypeId,
              dropDownItems: state.classroomTypes
                  .map(
                    (classroomType) => DropdownMenuItem<String>(
                      value: classroomType.id,
                      child: Text(classroomType.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedClassroomTypeId = value;
                });
              },
              isRequired: true,
            ),
          ],
        );
      },
    );
  }

  Widget _buildGradeLevelDropdown(BuildContext context) {
    return BlocBuilder<GradeLevelsCubit, GradeLevelsState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "اختر المرحلة الدراسية",
              style: context.textTheme.labelLarge,
            ),
            const SizedBox(height: AppSizes.s8),

            AppDropDownFormField(
              hint: "اختر المرحلة الدراسية",
              value: _selectedGradeLevelId,
              dropDownItems: state.gradeLevels
                  .map(
                    (gradeLevel) => DropdownMenuItem<String>(
                      value: gradeLevel.id,
                      child: Text(gradeLevel.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGradeLevelId = value;
                });
              },
              isRequired: true,
            ),
          ],
        );
      },
    );
  }
}
