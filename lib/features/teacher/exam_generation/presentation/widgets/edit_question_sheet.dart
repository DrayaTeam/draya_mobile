import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/core/widgets/app_elevated_button.dart";
import "package:draya_mobile/core/widgets/app_text_form_field.dart";
import "package:draya_mobile/features/teacher/exam_generation/data/models/teacher_exam_models.dart";
import "package:flutter/material.dart";

class EditQuestionSheet extends StatefulWidget {
  final TeacherExamQuestionModel? initialQuestion;
  final ValueChanged<TeacherExamQuestionModel> onSave;

  const EditQuestionSheet({
    super.key,
    this.initialQuestion,
    required this.onSave,
  });

  static Future<void> show({
    required BuildContext context,
    TeacherExamQuestionModel? initialQuestion,
    required ValueChanged<TeacherExamQuestionModel> onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => EditQuestionSheet(
        initialQuestion: initialQuestion,
        onSave: onSave,
      ),
    );
  }

  @override
  State<EditQuestionSheet> createState() => _EditQuestionSheetState();
}

class _EditQuestionSheetState extends State<EditQuestionSheet> {
  late final TextEditingController _textController;
  late final TextEditingController _rubricController;
  late String _selectedType;
  late String _selectedDifficulty;
  late List<TeacherExamQuestionOptionModel> _options;

  @override
  void initState() {
    super.initState();
    final q = widget.initialQuestion;
    _textController = TextEditingController(text: q?.text ?? "");
    _rubricController = TextEditingController(text: q?.rubric ?? "");
    _selectedType = q?.type ?? "MultipleChoice";
    _selectedDifficulty = q?.difficulty ?? "easy";

    if (q?.options != null && q!.options.isNotEmpty) {
      _options = List.from(q.options);
    } else if (_selectedType == "TrueFalse") {
      _options = const [
        TeacherExamQuestionOptionModel(text: "صح", isCorrect: true),
        TeacherExamQuestionOptionModel(text: "خطأ", isCorrect: false),
      ];
    } else {
      _options = [
        const TeacherExamQuestionOptionModel(
          text: "الخيار الأول",
          isCorrect: true,
        ),
        const TeacherExamQuestionOptionModel(
          text: "الخيار الثاني",
          isCorrect: false,
        ),
        const TeacherExamQuestionOptionModel(
          text: "الخيار الثالث",
          isCorrect: false,
        ),
        const TeacherExamQuestionOptionModel(
          text: "الخيار الرابع",
          isCorrect: false,
        ),
      ];
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _rubricController.dispose();
    super.dispose();
  }

  bool get _isEditing => widget.initialQuestion != null;

  void _save() {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("يرجى كتابة نص السؤال"),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    final newQuestion = TeacherExamQuestionModel(
      id: widget.initialQuestion?.id ?? "",
      text: text,
      type: _selectedType,
      difficulty: _selectedDifficulty,
      rubric: _rubricController.text.trim().isNotEmpty
          ? _rubricController.text.trim()
          : null,
      options:
          (_selectedType == "MultipleChoice" || _selectedType == "TrueFalse")
          ? _options
          : [],
    );

    widget.onSave(newQuestion);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSizes.s20,
        right: AppSizes.s20,
        top: AppSizes.s20,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.s24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderStrong,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary50,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    _isEditing
                        ? Icons.edit_note_rounded
                        : Icons.add_task_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  _isEditing ? "تعديل بيانات السؤال" : "إضافة سؤال جديد",
                  style: AppTextStyles.h5.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    fontSize: 15.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: AppColors.border),
            const SizedBox(height: 16),

            // Question Text Input
            Text(
              "نص السؤال:",
              style: AppTextStyles.label.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            AppTextFormField(
              controller: _textController,
              hintText: "اكتب نص السؤال هنا...",
              maxLine: 2,
            ),
            const SizedBox(height: 16),

            // Type & Difficulty Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "نوع السؤال:",
                        style: AppTextStyles.label.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedType,
                        isExpanded: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.border,
                            ),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: "MultipleChoice",
                            child: Text(
                              "اختيار من متعدد",
                              style: TextStyle(fontSize: 12.5),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "TrueFalse",
                            child: Text(
                              "صح أم خطأ",
                              style: TextStyle(fontSize: 12.5),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "Essay",
                            child: Text(
                              "سؤال مقالي",
                              style: TextStyle(fontSize: 12.5),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "ShortAnswer",
                            child: Text(
                              "إجابة قصيرة",
                              style: TextStyle(fontSize: 12.5),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "FillInTheBlank",
                            child: Text(
                              "أكمل الفراغ",
                              style: TextStyle(fontSize: 12.5),
                            ),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedType = val;
                              if (val == "TrueFalse") {
                                _options = const [
                                  TeacherExamQuestionOptionModel(
                                    text: "صح",
                                    isCorrect: true,
                                  ),
                                  TeacherExamQuestionOptionModel(
                                    text: "خطأ",
                                    isCorrect: false,
                                  ),
                                ];
                              }
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "الصعوبة:",
                        style: AppTextStyles.label.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedDifficulty,
                        isExpanded: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.border,
                            ),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: "easy",
                            child: Text(
                              "سهل",
                              style: TextStyle(fontSize: 12.5),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "medium",
                            child: Text(
                              "متوسط",
                              style: TextStyle(fontSize: 12.5),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "hard",
                            child: Text(
                              "متقدم",
                              style: TextStyle(fontSize: 12.5),
                            ),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedDifficulty = val;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Options Editor (for MCQ or TrueFalse)
            if (_selectedType == "MultipleChoice" ||
                _selectedType == "TrueFalse") ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "الخيارات (حدد الإجابة الصحيحة):",
                    style: AppTextStyles.label.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (_selectedType == "MultipleChoice")
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _options.add(
                            TeacherExamQuestionOptionModel(
                              text: "خيار ${_options.length + 1}",
                              isCorrect: false,
                            ),
                          );
                        });
                      },
                      icon: const Icon(Icons.add_rounded, size: 16),
                      label: const Text(
                        "إضافة خيار",
                        style: TextStyle(fontSize: 11.5),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              ..._options.asMap().entries.map((entry) {
                final idx = entry.key;
                final opt = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      RadioGroup<int>(
                        groupValue: _options.indexWhere((o) => o.isCorrect),
                        onChanged: (int? value) {
                          if (value == null) return;

                          setState(() {
                            for (int i = 0; i < _options.length; i++) {
                              _options[i] = _options[i].copyWith(
                                isCorrect: i == value,
                              );
                            }
                          });
                        },
                        child: Column(
                          children: List.generate(
                            _options.length,
                            (idx) => Radio<int>(
                              value: idx,
                              activeColor: AppColors.chemistryBiology,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          initialValue: opt.text,
                          decoration: InputDecoration(
                            hintText: "نص الخيار...",
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: AppColors.border,
                              ),
                            ),
                          ),
                          onChanged: (val) {
                            _options[idx] = opt.copyWith(text: val);
                          },
                        ),
                      ),
                      if (_selectedType == "MultipleChoice" &&
                          _options.length > 2)
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            size: 20,
                            color: AppColors.error,
                          ),
                          onPressed: () {
                            setState(() {
                              _options.removeAt(idx);
                            });
                          },
                        ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 12),
            ] else ...[
              // Rubric Input
              Text(
                "معيار الإجابة النموذجية / الـ Rubric (اختياري):",
                style: AppTextStyles.label.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              AppTextFormField(
                controller: _rubricController,
                hintText: "أدخل النقاط الأساسية والمعايير لتقييم الإجابة...",
                maxLine: 2,
              ),
              const SizedBox(height: 16),
            ],

            const SizedBox(height: 16),
            AppElevatedButton(
              onPressed: _save,
              label: _isEditing ? "حفظ التعديلات" : "إضافة السؤال",
            ),
          ],
        ),
      ),
    );
  }
}
