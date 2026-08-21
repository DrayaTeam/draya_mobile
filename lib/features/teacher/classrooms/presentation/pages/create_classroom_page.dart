import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/helpers/app_navigator.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/core/view_models/drawer_model.dart";
import "package:draya_mobile/core/widgets/app_drawer.dart";
import "package:draya_mobile/core/widgets/app_drop_down_form_field.dart";
import "package:draya_mobile/core/widgets/app_text_form_field.dart";
import "package:draya_mobile/core/widgets/custom_app_bar.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/create_classroom_request_model.dart";
import "package:draya_mobile/features/teacher/classrooms/presentation/cubit/classroom_cubit.dart";
import "package:draya_mobile/features/teacher/classrooms/presentation/cubit/classroom_state.dart";
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
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();

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

  Future<DateTime?> _pickDate({
    DateTime? initialDate,
    DateTime? firstDate,
  }) async {
    return await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  Future<void> _createClassroom() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedSubjectId == null ||
        _selectedClassroomTypeId == null ||
        _selectedGradeLevelId == null ||
        _startDate == null ||
        _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.error,
          content: Text(
            "يرجى إكمال جميع الحقول المطلوبة",
            style: AppTextStyles.body.copyWith(color: Colors.white),
          ),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await context.read<ClassroomCubit>().createClassroom(
        CreateClassroomRequestModel(
          subjectId: _selectedSubjectId!,
          name: _textEditingControllerName.text.trim(),
          classroomTypeId: _selectedClassroomTypeId!,
          gradeLevelId: _selectedGradeLevelId!,
          startDate: _startDate!,
          endDate: _endDate!,
          price: double.parse(_textEditingControllerPrice.text.trim()),
        ),
      );
    } catch (_) {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ClassroomCubit, ClassroomState>(
      listener: (context, state) {
        if (state.status == CubitStatus.error) {
          setState(() => _isSubmitting = false);
        }
        if (state.status == CubitStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.chemistryBiology,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              content: Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "تم إنشاء الفصل الدراسي بنجاح",
                    style: AppTextStyles.body.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
          AppNavigator.pop(context: context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const CustomAppBar(title: "إنشاء فصل دراسي"),
        drawer: AppDrawer(drawerItemsList: getTeacherDrawerItemsList()),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.s16,
              AppSizes.s16,
              AppSizes.s16,
              AppSizes.s36,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Hero Header
                  _buildHeroHeader(),
                  const SizedBox(height: AppSizes.s16),

                  // Section 1: Basic Info
                  _buildFormSection(
                    title: "البيانات الأساسية للفصل",
                    icon: Icons.info_outline_rounded,
                    children: [
                      _buildFieldLabel("اسم الفصل الدراسي", isRequired: true),
                      const SizedBox(height: AppSizes.s6),
                      AppTextFormField(
                        controller: _textEditingControllerName,
                        hintText: "مثال: مراجعة الأحياء للثانوية العامة",
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? "أدخل اسم الفصل الدراسي"
                            : null,
                      ),
                      const SizedBox(height: AppSizes.s16),
                      _buildSubjectDropdown(),
                      const SizedBox(height: AppSizes.s16),
                      _buildGradeLevelDropdown(),
                      const SizedBox(height: AppSizes.s16),
                      _buildClassroomTypeDropdown(),
                    ],
                  ),
                  const SizedBox(height: AppSizes.s16),

                  // Section 2: Dates & Duration
                  _buildFormSection(
                    title: "الفترة الزمنية",
                    icon: Icons.calendar_month_outlined,
                    children: [
                      Row(
                        children: [
                          // Start Date
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel(
                                  "تاريخ البداية",
                                  isRequired: true,
                                ),
                                const SizedBox(height: AppSizes.s6),
                                AppTextFormField(
                                  controller: _textEditingControllerStartDate,
                                  hintText: "yyyy/MM/dd",
                                  isReadOnly: true,
                                  prefixIcon: Icons.calendar_today_rounded,
                                  validator: (value) {
                                    if (_startDate == null) {
                                      return "اختر تاريخ البداية";
                                    }
                                    return null;
                                  },
                                  onTap: () async {
                                    final picked = await _pickDate(
                                      initialDate: _startDate,
                                    );
                                    if (picked != null) {
                                      setState(() {
                                        _startDate = picked;
                                        _textEditingControllerStartDate.text =
                                            DateFormat(
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
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSizes.s12),
                          // End Date
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel(
                                  "تاريخ النهاية",
                                  isRequired: true,
                                ),
                                const SizedBox(height: AppSizes.s6),
                                AppTextFormField(
                                  controller: _textEditingControllerEndDate,
                                  hintText: "yyyy/MM/dd",
                                  isReadOnly: true,
                                  prefixIcon: Icons.event_available_rounded,
                                  validator: (value) {
                                    if (_endDate == null) {
                                      return "اختر تاريخ النهاية";
                                    }
                                    if (_startDate != null &&
                                        !_endDate!.isAfter(_startDate!)) {
                                      return "يجب أن يكون بعد البداية";
                                    }
                                    return null;
                                  },
                                  onTap: () async {
                                    final minDate = _startDate != null
                                        ? _startDate!.add(
                                            const Duration(days: 1),
                                          )
                                        : DateTime.now();
                                    final picked = await _pickDate(
                                      initialDate: _endDate ?? minDate,
                                      firstDate: minDate,
                                    );
                                    if (picked != null) {
                                      setState(() {
                                        _endDate = picked;
                                        _textEditingControllerEndDate.text =
                                            DateFormat(
                                              "yyyy/MM/dd",
                                            ).format(picked);
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.s16),

                  // Section 3: Pricing
                  _buildFormSection(
                    title: "التسعير والاشتراك",
                    icon: Icons.payments_outlined,
                    children: [
                      _buildFieldLabel(
                        "سعر الاشتراك (بالجنيه المصري)",
                        isRequired: true,
                      ),
                      const SizedBox(height: AppSizes.s6),
                      AppTextFormField(
                        controller: _textEditingControllerPrice,
                        hintText: "مثال: 250",
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        prefixIcon: Icons.currency_pound_rounded,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "أدخل سعر الفصل الدراسي";
                          }
                          final number = double.tryParse(value.trim());
                          if (number == null) {
                            return "أدخل رقم صحيح";
                          }
                          if (number <= 0) {
                            return "يجب أن يكون السعر أكبر من صفر";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.s24),

                  // Submit Button
                  SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _isSubmitting ? null : _createClassroom,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: _isSubmitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.check_circle_outline_rounded,
                              size: 20,
                            ),
                      label: Text(
                        _isSubmitting
                            ? "جاري الإنشاء..."
                            : "إنشاء الفصل الدراسي",
                        style: AppTextStyles.button.copyWith(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroHeader() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary800, AppColors.primary600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary700.withValues(alpha: 0.22),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.add_business_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "إنشاء فصل دراسي جديد",
                  style: AppTextStyles.h4.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "أدخل تفاصيل الفصل، وحدد المادة والمرحلة لتمكين الطلاب من الانضمام",
                  style: AppTextStyles.body.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTextStyles.h5.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label, {bool isRequired = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTextStyles.label.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            fontSize: 12.5,
          ),
        ),
        if (isRequired) ...[
          const SizedBox(width: 4),
          const Text(
            "*",
            style: TextStyle(color: AppColors.error, fontSize: 13),
          ),
        ],
      ],
    );
  }

  Widget _buildSubjectDropdown() {
    return BlocBuilder<SubjectCubit, SubjectState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldLabel("المادة الدراسية", isRequired: true),
            const SizedBox(height: AppSizes.s6),
            AppDropDownFormField(
              hint: state.subjects.isEmpty
                  ? "جاري تحميل المواد..."
                  : "اختر المادة الدراسية",
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
                setState(() => _selectedSubjectId = value);
              },
              isRequired: true,
            ),
          ],
        );
      },
    );
  }

  Widget _buildClassroomTypeDropdown() {
    return BlocBuilder<ClassroomTypesCubit, ClassroomTypesState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldLabel("نوع الفصل", isRequired: true),
            const SizedBox(height: AppSizes.s6),
            AppDropDownFormField(
              hint: state.classroomTypes.isEmpty
                  ? "جاري تحميل أنواع الفصول..."
                  : "اختر نوع الفصل",
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
                setState(() => _selectedClassroomTypeId = value);
              },
              isRequired: true,
            ),
          ],
        );
      },
    );
  }

  Widget _buildGradeLevelDropdown() {
    return BlocBuilder<GradeLevelsCubit, GradeLevelsState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldLabel("المرحلة الدراسية", isRequired: true),
            const SizedBox(height: AppSizes.s6),
            AppDropDownFormField(
              hint: state.gradeLevels.isEmpty
                  ? "جاري تحميل المراحل الدراسية..."
                  : "اختر المرحلة الدراسية",
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
                setState(() => _selectedGradeLevelId = value);
              },
              isRequired: true,
            ),
          ],
        );
      },
    );
  }
}
