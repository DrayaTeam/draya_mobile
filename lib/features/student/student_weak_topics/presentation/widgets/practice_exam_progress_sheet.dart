import "package:draya_mobile/core/helpers/app_navigator.dart";
import "package:draya_mobile/core/router/app_routes.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/features/student/student_weak_topics/presentation/cubit/student_weak_topics_cubit.dart";
import "package:draya_mobile/features/student/student_weak_topics/presentation/cubit/student_weak_topics_state.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class PracticeExamProgressSheet extends StatelessWidget {
  final String topicName;

  const PracticeExamProgressSheet({
    super.key,
    required this.topicName,
  });

  static Future<void> show({
    required BuildContext context,
    required String topicName,
    required StudentWeakTopicsCubit cubit,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: PracticeExamProgressSheet(topicName: topicName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentWeakTopicsCubit, StudentWeakTopicsState>(
      builder: (context, state) {
        final status = state.examGenerationStatus;
        final isFinished = status == PracticeExamGenerationStatus.completed;
        final isFailed = status == PracticeExamGenerationStatus.failed;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              // Animated Status Icon
              if (isFinished)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFBBF7D0)),
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF059669),
                    size: 48,
                  ),
                )
              else if (isFailed)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1F2),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFFECDD3)),
                  ),
                  child: const Icon(
                    Icons.error_outline_rounded,
                    color: Color(0xFFE11D48),
                    size: 48,
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.ai50,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.ai300),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: AppColors.ai700,
                    size: 44,
                  ),
                ),

              const SizedBox(height: 18),

              // Status Title
              Text(
                isFinished
                    ? "تم تجهيز الامتحان التدريبي!"
                    : isFailed
                        ? "تعذر إنشاء الامتحان"
                        : "جاري إنشاء امتحان تدريبي ذكي",
                textAlign: TextAlign.center,
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 6),

              // Topic description
              Text(
                "موضوع: $topicName",
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.ai700,
                  fontWeight: FontWeight.w700,
                  fontSize: 13.5,
                ),
              ),
              const SizedBox(height: 12),

              // Explanation text / subtext
              Text(
                isFinished
                    ? "تم توليد أسئلة مخصصة لقياس مدى استيعابك للمفهوم بعد مراجعته. يمكنك البدء الآن."
                    : isFailed
                        ? (state.examGenerationError ??
                            "حدث خطأ أثناء بناء الأسئلة. يرجى المحاولة مرة أخرى.")
                        : "يقوم الذكاء الاصطناعي بتحليل المادة التدريبية وصياغة أسئلة تدريبية مخصصة...",
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  height: 1.45,
                ),
              ),

              const SizedBox(height: 20),

              // Progress bar if generating
              if (!isFinished && !isFailed) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: LinearProgressIndicator(
                    minHeight: 6,
                    backgroundColor: Color(0xFFF1F5F9),
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.ai700),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "يرجى الانتظار قليلاً...",
                  style: TextStyle(
                    color: AppColors.textDisabled,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Actions
              if (isFinished) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final examId = state.generatedExamId;
                      Navigator.pop(context); // close progress sheet
                      if (examId != null && examId.isNotEmpty) {
                        AppNavigator.push(
                          context: context,
                          path: AppRoutes.studentExamDetailsPage,
                          extra: {
                            "examId": examId,
                            "classroomName": "امتحان تدريبي - $topicName",
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF059669),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow_rounded, size: 20),
                        SizedBox(width: 8),
                        Text(
                          "بدء الامتحان التدريبي الآن",
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else if (isFailed) ...[
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context
                              .read<StudentWeakTopicsCubit>()
                              .startPracticeExamGeneration(
                                topicName: topicName,
                              );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: const Text(
                          "إعادة المحاولة",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("إغلاق"),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "المتابعة في الخلفية",
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ],
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
