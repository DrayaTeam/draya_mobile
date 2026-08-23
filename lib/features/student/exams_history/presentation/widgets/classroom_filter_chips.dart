import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/features/student/exams_history/domain/entity/student_exam_history.dart";
import "package:flutter/material.dart";

class ClassroomExamGroup {
  final String? classroomId;
  final String name;
  final int examCount;

  const ClassroomExamGroup({
    required this.classroomId,
    required this.name,
    required this.examCount,
  });
}

List<ClassroomExamGroup> buildClassroomGroups(
  List<StudentExamWithAttempts> exams,
) {
  final map = <String?, ClassroomExamGroup>{};
  for (final exam in exams) {
    final existing = map[exam.classroomId];
    if (existing != null) {
      map[exam.classroomId] = ClassroomExamGroup(
        classroomId: existing.classroomId,
        name: existing.name,
        examCount: existing.examCount + 1,
      );
    } else {
      map[exam.classroomId] = ClassroomExamGroup(
        classroomId: exam.classroomId,
        name: exam.classroomName ?? "فصل دراسي",
        examCount: 1,
      );
    }
  }
  return map.values.toList();
}

class ClassroomFilterChips extends StatelessWidget {
  final List<StudentExamWithAttempts> exams;
  final String? selectedClassroomId;
  final ValueChanged<String?> onSelected;

  const ClassroomFilterChips({
    super.key,
    required this.exams,
    required this.selectedClassroomId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final groups = buildClassroomGroups(exams);

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        children: [
          _buildChip(
            label: "الكل (${exams.length})",
            isSelected: selectedClassroomId == null,
            icon: Icons.apps_rounded,
          ),
          ...groups.map(
            (g) => _buildChip(
              label: "${g.name} (${g.examCount})",
              isSelected: selectedClassroomId == g.classroomId,
              icon: Icons.school_rounded,
              value: g.classroomId,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool isSelected,
    required IconData icon,
    String? value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: ChoiceChip(
          avatar: Icon(
            icon,
            size: 14,
            color: isSelected ? Colors.white : AppColors.primary700,
          ),
          label: Text(
            label,
            style: AppTextStyles.label.copyWith(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          selected: isSelected,
          selectedColor: AppColors.primary700,
          backgroundColor: AppColors.surface,
          showCheckmark: false,
          side: BorderSide(
            color: isSelected ? AppColors.primary700 : AppColors.borderStrong,
            width: isSelected ? 1.4 : 1,
          ),
          elevation: isSelected ? 3 : 0,
          pressElevation: 2,
          onSelected: (_) => onSelected(isSelected ? null : value),
        ),
      ),
    );
  }
}
