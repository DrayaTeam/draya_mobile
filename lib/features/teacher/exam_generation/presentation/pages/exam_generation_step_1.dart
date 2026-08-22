import "package:draya_mobile/core/di/dependency_injection.dart";
import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/helpers/app_navigator.dart";
import "package:draya_mobile/core/router/app_routes.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/core/view_models/drawer_model.dart";
import "package:draya_mobile/core/widgets/app_drawer.dart";
import "package:draya_mobile/core/widgets/app_drop_down_form_field.dart";
import "package:draya_mobile/core/widgets/app_text_form_field.dart";
import "package:draya_mobile/core/widgets/custom_app_bar.dart";
import "package:draya_mobile/core/widgets/fade_in_up_animation.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/classroom_model.dart";
import "package:draya_mobile/features/teacher/classrooms/presentation/cubit/classroom_cubit.dart";
import "package:draya_mobile/features/teacher/classrooms/presentation/cubit/classroom_state.dart";
import "package:draya_mobile/features/teacher/exam_generation/data/models/teacher_exam_models.dart";
import "package:draya_mobile/features/teacher/exam_generation/presentation/widgets/exam_generation_steps.dart";
import "package:draya_mobile/features/teacher/sections/data/models/section_model.dart";
import "package:draya_mobile/features/teacher/sections/presentation/cubit/section_cubit.dart";
import "package:draya_mobile/features/teacher/sections/presentation/cubit/section_state.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";

enum ExamLanguage {
  arabic(
    "العربية 🇪🇬",
    "ar",
    "Please write all questions, options, and model answers in Arabic language.",
  ),
  english(
    "English 🇬🇧",
    "en",
    "Please write all questions, options, and model answers in English language.",
  );

  final String title;
  final String code;
  final String instructionPrompt;

  const ExamLanguage(this.title, this.code, this.instructionPrompt);
}

class _QuestionTypeConfig {
  final String typeKey;
  final String labelArabic;
  final String description;
  final IconData icon;
  final Color color;
  bool isEnabled;
  int count;

  _QuestionTypeConfig({
    required this.typeKey,
    required this.labelArabic,
    required this.description,
    required this.icon,
    required this.color,
    this.isEnabled = true,
    this.count = 3,
  });
}

class ExamGenerationStep1 extends StatefulWidget {
  const ExamGenerationStep1({super.key});

  @override
  State<ExamGenerationStep1> createState() => _ExamGenerationStep1State();
}

class _ExamGenerationStep1State extends State<ExamGenerationStep1>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _topicController = TextEditingController();
  final _teacherInstructionsController = TextEditingController();

  ClassroomModel? _selectedClassroom;
  SectionModel? _selectedSection;
  String _difficultyLevel = "easy"; // easy, medium, hard
  ExamLanguage _selectedLanguage = ExamLanguage.arabic;

  late final List<_QuestionTypeConfig> _questionTypes;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<String> _quickInstructionTags = [
    "التركيز على التطبيق العملي",
    "أسئلة تحليلية واستنتاجية",
    "تجنب الأسئلة الحفظية المباشرة",
    "سيناريوهات وحالات واقعية",
  ];

  @override
  void initState() {
    super.initState();
    context.read<ClassroomCubit>().getClassrooms();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _questionTypes = [
      _QuestionTypeConfig(
        typeKey: "MCQ",
        labelArabic: "اختيار من متعدد (MCQ)",
        description: "4 خيارات مع إجابة صحيحة واحدة",
        icon: Icons.radio_button_checked_rounded,
        color: AppColors.primary,
        isEnabled: true,
        count: 3,
      ),
      _QuestionTypeConfig(
        typeKey: "TrueFalse",
        labelArabic: "صح أم خطأ (True/False)",
        description: "تقييم العبارات بالصحة أو الخطأ",
        icon: Icons.check_circle_outline_rounded,
        color: AppColors.chemistryBiology,
        isEnabled: true,
        count: 2,
      ),
      _QuestionTypeConfig(
        typeKey: "ShortAnswer",
        labelArabic: "إجابة قصيرة (Short Answer)",
        description: "إجابة مباشرة من سطر إلى سطرين",
        icon: Icons.short_text_rounded,
        color: AppColors.cyan,
        isEnabled: false,
        count: 2,
      ),
      _QuestionTypeConfig(
        typeKey: "Essay",
        labelArabic: "سؤال مقالي (Essay)",
        description: "شرح تفصيلي مصحح بالذكاء الاصطناعي",
        icon: Icons.article_outlined,
        color: AppColors.ai700,
        isEnabled: false,
        count: 1,
      ),
      _QuestionTypeConfig(
        typeKey: "FillInTheBlank",
        labelArabic: "أكمل الفراغ (Fill in the Blank)",
        description: "إكمال الكلمات والمفاهيم الناقصة",
        icon: Icons.space_bar_rounded,
        color: AppColors.amber,
        isEnabled: false,
        count: 2,
      ),
    ];
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _topicController.dispose();
    _teacherInstructionsController.dispose();
    super.dispose();
  }

  int get _totalQuestionsCount => _questionTypes
      .where((t) => t.isEnabled)
      .fold(0, (sum, t) => sum + t.count);

  void _proceedToStep2() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedClassroom == null) {
      _showErrorSnackBar("يرجى اختيار الفصل الدراسي أولاً");
      return;
    }

    if (_selectedSection == null) {
      _showErrorSnackBar("يرجى اختيار القسم التابع للفصل الدراسي");
      return;
    }

    final activeRequirements = _questionTypes
        .where((t) => t.isEnabled && t.count > 0)
        .map((t) => QuestionRequirementModel(type: t.typeKey, count: t.count))
        .toList();

    if (activeRequirements.isEmpty) {
      _showErrorSnackBar("يرجى تفعيل نوع واحد على الأقل من الأسئلة");
      return;
    }

    final combinedInstructions = StringBuffer();
    combinedInstructions.writeln(_selectedLanguage.instructionPrompt);
    if (_teacherInstructionsController.text.trim().isNotEmpty) {
      combinedInstructions.writeln(
        _teacherInstructionsController.text.trim(),
      );
    }

    AppNavigator.push(
      context: context,
      path: AppRoutes.examGenerationPage2,
      extra: {
        "classroomId": _selectedClassroom!.classroomId,
        "classroomName": _selectedClassroom!.name,
        "subjectName": _selectedClassroom!.subjectName,
        "sectionId": _selectedSection!.id,
        "sectionTitle": _selectedSection!.title,
        "topic": _topicController.text.trim(),
        "difficultyLevel": _difficultyLevel,
        "questionRequirements": activeRequirements,
        "teacherInstructions": combinedInstructions.toString().trim(),
      },
    );
  }

  void _showErrorSnackBar(String message) {
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
                message,
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SectionCubit>(
          create: (_) => getIt<SectionCubit>(),
        ),
      ],
      child: Scaffold(
        appBar: const CustomAppBar(title: "إنشاء امتحان بالذكاء الاصطناعي"),
        drawer: AppDrawer(drawerItemsList: getTeacherDrawerItemsList()),
        body: SafeArea(
          child: Builder(
            builder: (context) {
              return SingleChildScrollView(
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
                      const ExamGenerationSteps(currentStep: 1),
                      const SizedBox(height: AppSizes.s16),

                      // AI Header Banner
                      FadeInUp(
                        delay: 40,
                        child: _buildAiHeaderBanner(),
                      ),
                      const SizedBox(height: AppSizes.s16),

                      // Classroom & Section Selector Card
                      FadeInUp(
                        delay: 80,
                        child: _buildClassroomAndSectionCard(context),
                      ),
                      const SizedBox(height: AppSizes.s16),

                      // Topic & Difficulty & Language Card
                      FadeInUp(
                        delay: 120,
                        child: _buildTopicAndSettingsCard(),
                      ),
                      const SizedBox(height: AppSizes.s16),

                      // Question Types & Distribution Card
                      FadeInUp(
                        delay: 160,
                        child: _buildQuestionTypesCard(),
                      ),
                      const SizedBox(height: AppSizes.s16),

                      // Extra Teacher Instructions Card
                      FadeInUp(
                        delay: 200,
                        child: _buildTeacherInstructionsCard(),
                      ),
                      const SizedBox(height: AppSizes.s24),

                      // Next: Schedule & Time Settings Button
                      FadeInUp(
                        delay: 240,
                        child: _buildNextButton(),
                      ),
                      const SizedBox(height: AppSizes.s32),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAiHeaderBanner() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.ai900,
            AppColors.ai700,
            AppColors.primary700,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.ai700.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: -20,
            top: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSizes.s16),
            child: Row(
              children: [
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.wandMagicSparkles,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "توليد ذكي ومقترن بملفات القسم (RAG)",
                        style: AppTextStyles.h5.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 14.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "يستخرج محرك الذكاء الاصطناعي المفاهيم من ملفات القسم المختار ويبني أسئلة دقيقة.",
                        style: AppTextStyles.body.copyWith(
                          color: Colors.white.withValues(alpha: 0.88),
                          fontSize: 11.5,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassroomAndSectionCard(BuildContext context) {
    return _buildCardWrapper(
      title: "الفصل والقسم الدراسي",
      icon: Icons.school_rounded,
      children: [
        Text(
          "الفصل الدراسي:",
          style: AppTextStyles.label.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSizes.s8),
        BlocBuilder<ClassroomCubit, ClassroomState>(
          builder: (context, state) {
            if (state.status == CubitStatus.loading &&
                state.classrooms.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(12),
                child: Center(
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  ),
                ),
              );
            }

            final classrooms = state.classrooms;
            if (classrooms.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.backgroundMuted,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Text("لا توجد فصول دراسية متاحة حالياً"),
              );
            }

            return AppDropDownFormField(
              hint: "اختر الفصل الدراسي",
              value: _selectedClassroom?.classroomId,
              dropDownItems: classrooms.map((c) {
                return DropdownMenuItem<String>(
                  value: c.classroomId,
                  child: Text("${c.name} (${c.subjectName})"),
                );
              }).toList(),
              onChanged: (classroomId) {
                if (classroomId != null) {
                  final classroom = classrooms.firstWhere(
                    (c) => c.classroomId == classroomId,
                  );
                  setState(() {
                    _selectedClassroom = classroom;
                    _selectedSection = null;
                  });
                  context.read<SectionCubit>().getSections(
                        classroomId: classroom.classroomId,
                      );
                }
              },
            );
          },
        ),
        const SizedBox(height: AppSizes.s16),
        Text(
          "القسم الدراسي (مصدر المادة العلمية):",
          style: AppTextStyles.label.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSizes.s8),
        BlocBuilder<SectionCubit, SectionState>(
          builder: (context, state) {
            if (_selectedClassroom == null) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.backgroundMuted,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      size: 16,
                      color: AppColors.textDisabled,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "اختر فصلاً دراسياً أولاً لعرض الأقسام",
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textDisabled,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state.getSectionsStatus == CubitStatus.loading) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary50,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.primary200),
                ),
                child: const Row(
                  children: [
                    SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text("جاري تحميل أقسام الفصل..."),
                  ],
                ),
              );
            }

            final sections = state.sections;
            if (sections.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.amber.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.amber,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "هذا الفصل لا يحتوي على أقسام دراسية بها ملفات حتى الآن.",
                        style: AppTextStyles.body.copyWith(
                          fontSize: 12,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return AppDropDownFormField(
              hint: "اختر القسم الدراسي",
              value: _selectedSection?.id,
              dropDownItems: sections.map((s) {
                return DropdownMenuItem<String>(
                  value: s.id,
                  child: Text(s.title),
                );
              }).toList(),
              onChanged: (sectionId) {
                if (sectionId != null) {
                  setState(() {
                    _selectedSection = sections.firstWhere(
                      (s) => s.id == sectionId,
                    );
                  });
                }
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildTopicAndSettingsCard() {
    return _buildCardWrapper(
      title: "تفاصيل الامتحان ومستوى الصعوبة",
      icon: Icons.tune_rounded,
      children: [
        Text(
          "موضوع الامتحان / عنوان الوحدة:",
          style: AppTextStyles.label.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSizes.s8),
        AppTextFormField(
          controller: _topicController,
          hintText: "مثال: مقدمة في الحاويات و Docker Storage",
          prefixIcon: Icons.title_rounded,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "يرجى كتابة موضوع أو عنوان الامتحان";
            }
            return null;
          },
        ),
        const SizedBox(height: AppSizes.s16),

        // Difficulty Selector
        Text(
          "مستوى الصعوبة:",
          style: AppTextStyles.label.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSizes.s8),
        Row(
          children: [
            _buildDifficultyChip(
              key: "easy",
              label: "سهل",
              icon: Icons.sentiment_satisfied_alt_rounded,
              color: AppColors.chemistryBiology,
            ),
            const SizedBox(width: 8),
            _buildDifficultyChip(
              key: "medium",
              label: "متوسط",
              icon: Icons.sentiment_neutral_rounded,
              color: AppColors.amber,
            ),
            const SizedBox(width: 8),
            _buildDifficultyChip(
              key: "hard",
              label: "متقدم",
              icon: Icons.psychology_alt_rounded,
              color: AppColors.error,
            ),
          ],
        ),
        const SizedBox(height: AppSizes.s16),

        // Language Selector
        Text(
          "لغة الأسئلة والإجابات:",
          style: AppTextStyles.label.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSizes.s8),
        Row(
          children: ExamLanguage.values.map((lang) {
            final isSelected = _selectedLanguage == lang;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedLanguage = lang;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(
                    left: lang == ExamLanguage.arabic ? 8 : 0,
                    right: lang == ExamLanguage.english ? 8 : 0,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? AppColors.primary50 : AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: isSelected ? 1.8 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked_rounded
                            : Icons.radio_button_off_rounded,
                        size: 18,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textDisabled,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        lang.title,
                        style: AppTextStyles.label.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.w800
                              : FontWeight.w600,
                          color: isSelected
                              ? AppColors.primary700
                              : AppColors.textPrimary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDifficultyChip({
    required String key,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = _difficultyLevel == key;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _difficultyLevel = key;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.12)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? color : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 22,
                color: isSelected ? color : AppColors.textDisabled,
              ),
              const SizedBox(height: 5),
              Text(
                label,
                style: AppTextStyles.label.copyWith(
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? color : AppColors.textSecondary,
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionTypesCard() {
    return _buildCardWrapper(
      title: "توزيع ونوعية الأسئلة",
      icon: Icons.checklist_rounded,
      trailing: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, anim) =>
            ScaleTransition(scale: anim, child: child),
        child: Container(
          key: ValueKey<int>(_totalQuestionsCount),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primary700],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.25),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            "المجموع: $_totalQuestionsCount أسئلة",
            style: AppTextStyles.label.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
          ),
        ),
      ),
      children: [
        Text(
          "حدد أنواع الأسئلة وعددها المطلوب توليدها:",
          style: AppTextStyles.body.copyWith(
            color: AppColors.textSecondary,
            fontSize: 12.5,
          ),
        ),
        const SizedBox(height: AppSizes.s12),
        ..._questionTypes.map((typeConfig) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: typeConfig.isEnabled
                  ? AppColors.surface
                  : AppColors.backgroundMuted,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: typeConfig.isEnabled
                    ? typeConfig.color.withValues(alpha: 0.4)
                    : AppColors.border,
                width: typeConfig.isEnabled ? 1.5 : 1,
              ),
              boxShadow: typeConfig.isEnabled
                  ? [
                      BoxShadow(
                        color: typeConfig.color.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Checkbox(
                  value: typeConfig.isEnabled,
                  activeColor: typeConfig.color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  onChanged: (val) {
                    setState(() {
                      typeConfig.isEnabled = val ?? false;
                    });
                  },
                ),
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: typeConfig.isEnabled
                        ? typeConfig.color.withValues(alpha: 0.12)
                        : AppColors.border.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    typeConfig.icon,
                    size: 18,
                    color: typeConfig.isEnabled
                        ? typeConfig.color
                        : AppColors.textDisabled,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        typeConfig.labelArabic,
                        style: AppTextStyles.label.copyWith(
                          color: typeConfig.isEnabled
                              ? AppColors.textPrimary
                              : AppColors.textDisabled,
                          fontWeight: typeConfig.isEnabled
                              ? FontWeight.w800
                              : FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        typeConfig.description,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textDisabled,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                if (typeConfig.isEnabled)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildMiniIconButton(
                        icon: Icons.remove,
                        color: typeConfig.color,
                        onPressed: () {
                          if (typeConfig.count > 1) {
                            setState(() {
                              typeConfig.count--;
                            });
                          }
                        },
                      ),
                      Container(
                        constraints: const BoxConstraints(minWidth: 32),
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, anim) =>
                              ScaleTransition(scale: anim, child: child),
                          child: Text(
                            "${typeConfig.count}",
                            key: ValueKey<int>(typeConfig.count),
                            textAlign: TextAlign.center,
                            style: AppTextStyles.h5.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: typeConfig.color,
                            ),
                          ),
                        ),
                      ),
                      _buildMiniIconButton(
                        icon: Icons.add,
                        color: typeConfig.color,
                        onPressed: () {
                          setState(() {
                            typeConfig.count++;
                          });
                        },
                      ),
                    ],
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildMiniIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
      ),
    );
  }

  Widget _buildTeacherInstructionsCard() {
    return _buildCardWrapper(
      title: "توجيهات إضافية للمعلم (اختياري)",
      icon: Icons.auto_awesome_rounded,
      children: [
        Text(
          "اكتب أي ملاحظات أو معايير خاصة بالصياغة للذكاء الاصطناعي:",
          style: AppTextStyles.body.copyWith(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: AppSizes.s8),
        AppTextFormField(
          controller: _teacherInstructionsController,
          hintText:
              "مثال: التركيز على الحالات العملية، تجنب الأسئلة المباشرة...",
          maxLine: 3,
        ),
        const SizedBox(height: AppSizes.s12),
        Text(
          "اقتراحات سريعة:",
          style: AppTextStyles.label.copyWith(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSizes.s6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: _quickInstructionTags.map((tag) {
            return ActionChip(
              label: Text(
                tag,
                style: AppTextStyles.label.copyWith(
                  fontSize: 11,
                  color: AppColors.primary700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: AppColors.primary50,
              side: const BorderSide(color: AppColors.primary200),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onPressed: () {
                final currentText = _teacherInstructionsController.text.trim();
                if (currentText.isEmpty) {
                  _teacherInstructionsController.text = tag;
                } else if (!currentText.contains(tag)) {
                  _teacherInstructionsController.text =
                      "$currentText • $tag";
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: _proceedToStep2,
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
            Text(
              "التالي: ضبط الوقت والجدولة",
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
        ),
      ),
    );
  }

  Widget _buildCardWrapper({
    required String title,
    required IconData icon,
    Widget? trailing,
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
              ?trailing,
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
