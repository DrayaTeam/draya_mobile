import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/features/teacher/dashboard/data/models/needs_attention_list_item_model.dart";
import "package:flutter/material.dart";

class TeacherDashboardNeedsAttentionSection extends StatelessWidget {
  final List<NeedsAttentionListItemModel> students;

  const TeacherDashboardNeedsAttentionSection({
    super.key,
    required this.students,
  });

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r"\s+"));
    if (parts.isEmpty || parts.first.isEmpty) return "ط";
    if (parts.length == 1) return parts.first[0];
    return "${parts.first[0]}${parts.last[0]}";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 18,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEA580C),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "طلاب يحتاجون لمتابعة",
                      style: AppTextStyles.h4.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    if (students.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "${students.length}",
                          style: AppTextStyles.label.copyWith(
                            color: const Color(0xFFDC2626),
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text(
                    "أداء دون 55% في التقييمات الأخيرة",
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            // TextButton.icon(
            //   onPressed: () {
            //     context.push(AppRoutes.studentsListPage);
            //   },
            //   label: Text(
            //     "عرض الكل",
            //     style: AppTextStyles.button.copyWith(
            //       color: AppColors.primary700,
            //       fontSize: 13,
            //       fontWeight: FontWeight.w700,
            //     ),
            //   ),
            //   icon: const Icon(
            //     Icons.arrow_back_ios_new_rounded,
            //     size: 13,
            //     color: AppColors.primary700,
            //   ),
            //   iconAlignment: IconAlignment.start,
            // ),
          ],
        ),
        const SizedBox(height: 12),
        if (students.isEmpty)
          _buildEmptySuccessCard()
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: students.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final student = students[index];
              return _buildStudentCard(context, student);
            },
          ),
      ],
    );
  }

  Widget _buildStudentCard(
    BuildContext context,
    NeedsAttentionListItemModel student,
  ) {
    final avg = student.overallAverage;
    final progress = (avg / 100.0).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFFED7AA),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEA580C).withValues(alpha: 0.04),
            offset: const Offset(0, 4),
            blurRadius: 12,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar Initial
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFEDD5), Color(0xFFFDBA74)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                _getInitials(student.studentName),
                style: AppTextStyles.h4.copyWith(
                  color: const Color(0xFF9A3412),
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Student details and progress
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        student.studentName,
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFFECACA),
                        ),
                      ),
                      child: Text(
                        "${avg.toStringAsFixed(avg.truncateToDouble() == avg ? 0 : 1)}%",
                        style: AppTextStyles.label.copyWith(
                          color: const Color(0xFFDC2626),
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: const Color(0xFFF3F4F6),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFEA580C),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySuccessCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFDCFCE7),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              color: Color(0xFF16A34A),
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "أداء الطلاب ممتاز! 🎉",
                  style: AppTextStyles.label.copyWith(
                    color: const Color(0xFF15803D),
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "لا يوجد طلاب بأداء يقل عن 55% حالياً.",
                  style: AppTextStyles.body.copyWith(
                    color: const Color(0xFF166534),
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
