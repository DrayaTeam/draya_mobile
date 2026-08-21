import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/features/student/home/domain/entity/student_dashboard.dart";
import "package:flutter/material.dart";
import "student_home_alerts_section.dart";
import "student_home_course_and_exam_section.dart";
import "student_home_focus_section.dart";
import "student_home_learning_summary.dart";
import "student_home_upcoming_exams_section.dart";
import "student_home_welcome_card.dart";

class StudentHomeBody extends StatelessWidget {
  final StudentDashboard? studentDashboard;
  final String? studentName;
  final bool isLoading;
  final VoidCallback? onRetry;

  const StudentHomeBody({
    super.key,
    this.studentDashboard,
    this.studentName,
    this.isLoading = false,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (studentDashboard == null && isLoading) {
      return const _StudentHomeLoadingSkeleton();
    }

    if (studentDashboard == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: AppColors.error,
              ),
              const SizedBox(height: 16),
              Text(
                "تعذر تحميل بيانات الصفحة الرئيسية",
                style: AppTextStyles.h4.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "يرجى التحقق من اتصال الإنترنت والمحاولة مرة أخرى",
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              if (onRetry != null)
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text("إعادة المحاولة"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    final data = studentDashboard!;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.only(bottom: 48),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // 1. Welcome Card
          StudentHomeWelcomeCard(
            studentName: studentName,
            upcomingExamsCount: data.upcomingExams.length,
            streakDays: data.currentStreak,
          ),
          const SizedBox(height: 20),
          // 2. Learning Summary Card (Streak + Average + Lessons)
          StudentHomeLearningSummary(
            currentStreak: data.currentStreak,
            overallAverage: data.overallAverage,
            completedLessonsCount: data.completedLessonsCount,
          ),
          const SizedBox(height: 20),
          // 3. Urgent Alerts
          StudentHomeAlertsSection(
            urgentAlerts: data.urgentAlerts,
          ),
          const SizedBox(height: 20),
          // 4. Subscribed Packages & Subject Average
          StudentHomeCourseAndExamSection(
            subscribedPackagesCount: data.subscribedPackagesCount,
            overallAverage: data.overallAverage,
          ),
          if (data.pointsNeedingFocus.isNotEmpty) ...[
            const SizedBox(height: 36),
            // 5. Points Needing Focus (AI Revision)
            StudentHomeFocusSection(
              pointsNeedingFocus: data.pointsNeedingFocus,
            ),
          ],
          // if (data.dailyLessons.isNotEmpty) ...[
          //   const SizedBox(height: 20),
          //   // 6. Daily Lessons
          //   StudentHomeDailyLessonsSection(
          //     dailyLessons: data.dailyLessons,
          //   ),
          // ],
          if (data.upcomingExams.isNotEmpty) ...[
            const SizedBox(height: 20),
            // 7. Upcoming Exams
            StudentHomeUpcomingExamsSection(
              upcomingExams: data.upcomingExams,
            ),
          ],
        ],
      ),
    );
  }
}

class _StudentHomeLoadingSkeleton extends StatelessWidget {
  const _StudentHomeLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          _skeletonBox(height: 280, borderRadius: 24),
          const SizedBox(height: 20),
          _skeletonBox(height: 200, borderRadius: 24),
          const SizedBox(height: 20),
          _skeletonBox(height: 120, borderRadius: 24),
          const SizedBox(height: 20),
          _skeletonBox(height: 140, borderRadius: 22),
        ],
      ),
    );
  }

  Widget _skeletonBox({required double height, required double borderRadius}) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
