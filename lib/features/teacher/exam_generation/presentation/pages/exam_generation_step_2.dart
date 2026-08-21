import "dart:math";

import "package:draya_mobile/core/di/dependency_injection.dart";
import "package:draya_mobile/core/helpers/app_navigator.dart";
import "package:draya_mobile/core/router/app_routes.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/core/view_models/drawer_model.dart";
import "package:draya_mobile/core/widgets/app_drawer.dart";
import "package:draya_mobile/core/widgets/app_outlined_button.dart";
import "package:draya_mobile/core/widgets/app_text_form_field.dart";
import "package:draya_mobile/core/widgets/custom_app_bar.dart";
import "package:draya_mobile/core/widgets/fade_in_up_animation.dart";
import "package:draya_mobile/features/teacher/exam_generation/data/models/teacher_exam_models.dart";
import "package:draya_mobile/features/teacher/exam_generation/data/source/teacher_exam_remote_data_source.dart";
import "package:draya_mobile/features/teacher/exam_generation/presentation/widgets/exam_config_summary_card.dart";
import "package:draya_mobile/features/teacher/exam_generation/presentation/widgets/exam_generation_steps.dart";
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:intl/intl.dart";

class ExamGenerationStep2 extends StatefulWidget {
  final String classroomId;
  final String? classroomName;
  final String? subjectName;
  final String sectionId;
  final String? sectionTitle;
  final String topic;
  final String difficultyLevel;
  final List<QuestionRequirementModel> questionRequirements;
  final String teacherInstructions;

  const ExamGenerationStep2({
    super.key,
    required this.classroomId,
    this.classroomName,
    this.subjectName,
    required this.sectionId,
    this.sectionTitle,
    required this.topic,
    required this.difficultyLevel,
    required this.questionRequirements,
    required this.teacherInstructions,
  });

  @override
  State<ExamGenerationStep2> createState() => _ExamGenerationStep2State();
}

class _ExamGenerationStep2State extends State<ExamGenerationStep2> {
  final _formKey = GlobalKey<FormState>();
  final _durationController = TextEditingController(text: "45");
  final _attemptsController = TextEditingController(text: "1");
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  bool _isGenerating = false;

  final List<int> _durationPresets = [15, 30, 45, 60, 90, 120];
  final List<int> _attemptsPresets = [1, 2, 3, 5];

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now();
    _startDateController.text = DateFormat("yyyy/MM/dd").format(_startDate!);
  }

  @override
  void dispose() {
    _durationController.dispose();
    _attemptsController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<DateTime?> _pickDate({DateTime? initialDate, DateTime? firstDate}) async {
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

  Future<void> _startGenerationAndProceed() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isGenerating = true);

    try {
      final remote = getIt<TeacherExamRemoteDataSource>();
      final random = Random();
      final idempotencyKey =
          "gen-${DateTime.now().millisecondsSinceEpoch}-${random.nextInt(999999)}";

      final durationMinutes = int.tryParse(_durationController.text.trim());
      final allowedAttempts = int.tryParse(_attemptsController.text.trim());
      final startDate = _startDate ?? DateTime.now();

      final request = ExamGenerationRequestModel(
        classroomId: widget.classroomId,
        sectionId: widget.sectionId,
        topic: widget.topic,
        difficultyLevel: widget.difficultyLevel,
        questionRequirements: widget.questionRequirements,
        teacherInstructions: widget.teacherInstructions,
        idempotencyKey: idempotencyKey,
        durationMinutes: durationMinutes,
        startDate: startDate,
        endDate: _endDate,
        allowedAttempts: allowedAttempts,
      );

      final response = await remote.generateExam(request);

      if (mounted) {
        setState(() => _isGenerating = false);

        await AppNavigator.push(
          context: context,
          path: AppRoutes.examGenerationPage3,
          extra: {
            "generationId": response.generationId,
            "topic": widget.topic,
            "classroomId": widget.classroomId,
            "classroomName": widget.classroomName,
            "subjectName": widget.subjectName,
            "sectionId": widget.sectionId,
            "sectionTitle": widget.sectionTitle,
            "difficultyLevel": widget.difficultyLevel,
            "questionRequirements": widget.questionRequirements,
            "durationMinutes": durationMinutes,
            "allowedAttempts": allowedAttempts,
            "startDate": startDate.toIso8601String(),
            "endDate": _endDate?.toIso8601String(),
          },
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isGenerating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "حدث خطأ أثناء بدء توليد الامتحان: ${e.toString()}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "ضبط الوقت والجدولة"),
      drawer: AppDrawer(drawerItemsList: getTeacherDrawerItemsList()),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.s16,
            vertical: AppSizes.s16,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ExamGenerationSteps(currentStep: 2),
                const SizedBox(height: AppSizes.s16),

                // Step 1 Summary Banner
                FadeInUp(
                  delay: 40,
                  child: ExamConfigSummaryCard(
                    topic: widget.topic,
                    classroomName: widget.classroomName,
                    subjectName: widget.subjectName,
                    sectionTitle: widget.sectionTitle,
                    difficultyLevel: widget.difficultyLevel,
                    questionRequirements: widget.questionRequirements,
                  ),
                ),
                const SizedBox(height: AppSizes.s16),

                // Duration & Attempts Card
                FadeInUp(
                  delay: 80,
                  child: _buildDurationAndAttemptsCard(),
                ),
                const SizedBox(height: AppSizes.s16),

                // Schedule Dates Card
                FadeInUp(
                  delay: 120,
                  child: _buildScheduleDatesCard(),
                ),
                const SizedBox(height: AppSizes.s24),

                // Primary Start Generation Button
                FadeInUp(
                  delay: 160,
                  child: _buildGenerateButton(),
                ),
                const SizedBox(height: AppSizes.s12),

                // Back Button
                FadeInUp(
                  delay: 200,
                  child: AppOutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    label: "الرجوع لتعديل المحتوى والأسئلة",
                  ),
                ),
                const SizedBox(height: AppSizes.s32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDurationAndAttemptsCard() {
    final currentDuration = int.tryParse(_durationController.text.trim());
    final currentAttempts = int.tryParse(_attemptsController.text.trim());

    return _buildCardWrapper(
      title: "مدة الامتحان وعدد المحاولات",
      icon: Icons.timer_outlined,
      children: [
        // Exam Duration Section
        Text(
          "مدة الحل بالدقائق:",
          style: AppTextStyles.label.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSizes.s8),
        AppTextFormField(
          controller: _durationController,
          hintText: "مثال: 60",
          keyboardType: const TextInputType.numberWithOptions(),
          prefixIcon: Icons.hourglass_top_rounded,
          onChanged: (_) => setState(() {}),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "يرجى إدخال مدة الامتحان بالدقائق";
            }
            final mins = int.tryParse(value.trim());
            if (mins == null || mins <= 0) {
              return "المدة يجب أن تكون رقماً موجباً أكبر من صفر";
            }
            return null;
          },
        ),
        const SizedBox(height: AppSizes.s10),

        // Quick Duration Chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _durationPresets.map((mins) {
            final isSelected = currentDuration == mins;
            return ChoiceChip(
              label: Text("$mins دقيقة"),
              selected: isSelected,
              selectedColor: AppColors.primary100,
              backgroundColor: AppColors.backgroundMuted,
              labelStyle: AppTextStyles.label.copyWith(
                fontSize: 11.5,
                color: isSelected ? AppColors.primary700 : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.primary300 : AppColors.border,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _durationController.text = mins.toString();
                  });
                }
              },
            );
          }).toList(),
        ),
        const SizedBox(height: AppSizes.s20),
        const Divider(height: 1, color: AppColors.border),
        const SizedBox(height: AppSizes.s16),

        // Allowed Attempts Section
        Text(
          "عدد المحاولات المسموحة للطالب:",
          style: AppTextStyles.label.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSizes.s8),
        AppTextFormField(
          controller: _attemptsController,
          hintText: "1",
          keyboardType: const TextInputType.numberWithOptions(),
          prefixIcon: Icons.repeat_rounded,
          onChanged: (_) => setState(() {}),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "يرجى إدخال عدد المحاولات";
            }
            final attempts = int.tryParse(value.trim());
            if (attempts == null || attempts <= 0) {
              return "عدد المحاولات يجب أن يكون رقماً موجباً";
            }
            return null;
          },
        ),
        const SizedBox(height: AppSizes.s10),

        // Quick Attempts Chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _attemptsPresets.map((attempts) {
            final isSelected = currentAttempts == attempts;
            return ChoiceChip(
              label: Text(
                attempts == 1
                    ? "محاولة واحدة"
                    : attempts == 2
                        ? "محاولتان"
                        : "$attempts محاولات",
              ),
              selected: isSelected,
              selectedColor: AppColors.primary100,
              backgroundColor: AppColors.backgroundMuted,
              labelStyle: AppTextStyles.label.copyWith(
                fontSize: 11.5,
                color: isSelected ? AppColors.primary700 : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.primary300 : AppColors.border,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _attemptsController.text = attempts.toString();
                  });
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildScheduleDatesCard() {
    return _buildCardWrapper(
      title: "فترة إتاحة الامتحان (الجدولة)",
      icon: Icons.calendar_month_rounded,
      children: [
        Text(
          "حدد تاريخ بداية ونهاية فترة استقبال إجابات الطلاب:",
          style: AppTextStyles.body.copyWith(
            color: AppColors.textSecondary,
            fontSize: 12.5,
          ),
        ),
        const SizedBox(height: AppSizes.s14),

        // Start Date Picker Field
        Text(
          "تاريخ بداية الامتحان:",
          style: AppTextStyles.label.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSizes.s6),
        AppTextFormField(
          controller: _startDateController,
          hintText: "yyyy/MM/dd (اليوم)",
          isReadOnly: true,
          prefixIcon: Icons.calendar_today_rounded,
          suffixIcon: Icons.edit_calendar_rounded,
          onTap: () async {
            final picked = await _pickDate(initialDate: _startDate);
            if (picked != null) {
              setState(() {
                _startDate = picked;
                _startDateController.text =
                    DateFormat("yyyy/MM/dd").format(picked);
                if (_endDate != null && _endDate!.isBefore(picked)) {
                  _endDate = null;
                  _endDateController.clear();
                }
              });
            }
          },
        ),
        const SizedBox(height: AppSizes.s16),

        // End Date Picker Field
        Text(
          "تاريخ انتهاء الامتحان (اختياري):",
          style: AppTextStyles.label.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSizes.s6),
        AppTextFormField(
          controller: _endDateController,
          hintText: "yyyy/MM/dd (اختياري)",
          isReadOnly: true,
          prefixIcon: Icons.event_busy_rounded,
          suffixIcon: _endDate != null
              ? Icons.clear_rounded
              : Icons.edit_calendar_rounded,
          onTap: () async {
            if (_endDate != null && _endDateController.text.isNotEmpty) {
              // Tap again to clear or pick
            }
            final firstDate = _startDate ?? DateTime.now();
            final picked = await _pickDate(
              initialDate: _endDate ?? firstDate,
              firstDate: firstDate,
            );
            if (picked != null) {
              setState(() {
                _endDate = picked;
                _endDateController.text =
                    DateFormat("yyyy/MM/dd").format(picked);
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildGenerateButton() {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: _isGenerating ? null : _startGenerationAndProceed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 6,
          shadowColor: AppColors.primary.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isGenerating) ...[
              const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "جاري بدء التوليد والاقتران...",
                style: AppTextStyles.label.copyWith(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ] else ...[
              const FaIcon(
                FontAwesomeIcons.wandMagicSparkles,
                size: 17,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Text(
                "بدء التوليد الذكي والانتقال للمراجعة",
                style: AppTextStyles.label.copyWith(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_rounded,
                size: 20,
                color: Colors.white,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCardWrapper({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.s16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(17, 24, 39, 0.04),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 18, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.h5.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.s12),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: AppSizes.s16),
          ...children,
        ],
      ),
    );
  }
}
