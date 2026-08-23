import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/helpers/app_dialog_helper.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/core/view_models/drawer_model.dart";
import "package:draya_mobile/core/widgets/app_drawer.dart";
import "package:draya_mobile/core/widgets/app_error_dialog.dart";
import "package:draya_mobile/core/widgets/custom_app_bar.dart";
import "package:draya_mobile/features/teacher/dashboard/presentation/cubit/teacher_dashboard_cubit.dart";
import "package:draya_mobile/features/teacher/dashboard/presentation/cubit/teacher_dashboard_state.dart";
import "package:draya_mobile/features/teacher/dashboard/presentation/widgets/teacher_dashboard_metrics_grid.dart";
import "package:draya_mobile/features/teacher/dashboard/presentation/widgets/teacher_dashboard_needs_attention_section.dart";
import "package:draya_mobile/features/teacher/dashboard/presentation/widgets/teacher_dashboard_recent_submissions_section.dart";
import "package:draya_mobile/features/teacher/dashboard/presentation/widgets/teacher_dashboard_weekly_chart.dart";
import "package:draya_mobile/features/teacher/dashboard/presentation/widgets/teacher_dashboard_welcome_card.dart";
import "package:draya_mobile/features/teacher/profile/presentation/cubit/teacher_profile_cubit.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await Future.wait([
      context.read<TeacherProfileCubit>().getTeacherProfile(),
      context.read<TeacherDashboardCubit>().getTeacherDashboard(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: "لوحة التحكم"),
      drawer: AppDrawer(drawerItemsList: getTeacherDrawerItemsList()),
      body: BlocListener<TeacherDashboardCubit, TeacherDashboardState>(
        listener: (BuildContext context, TeacherDashboardState state) {
          if (state.status == CubitStatus.error &&
              state.apiErrorModel != null &&
              state.teacherDashboardModel == null) {
            AppDialogHelper.display(
              context,
              AppErrorDialog(apiErrorModel: state.apiErrorModel!),
            );
          }
        },
        child: BlocBuilder<TeacherDashboardCubit, TeacherDashboardState>(
          builder: (BuildContext context, TeacherDashboardState state) {
            if (state.status == CubitStatus.loading &&
                state.teacherDashboardModel == null) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary700,
                ),
              );
            }

            if (state.status == CubitStatus.error &&
                state.teacherDashboardModel == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFFECACA)),
                        ),
                        child: const Icon(
                          Icons.error_outline_rounded,
                          color: Color(0xFFDC2626),
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "حدث خطأ أثناء تحميل بيانات لوحة التحكم",
                        style: AppTextStyles.h4.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.apiErrorModel?.error?.message ??
                            "يرجى التحقق من اتصالك بالإنترنت والمحاولة مجدداً.",
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _fetchData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: Text(
                          "إعادة المحاولة",
                          style: AppTextStyles.button.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state.teacherDashboardModel == null) {
              return const SizedBox.shrink();
            }

            final dashboard = state.teacherDashboardModel!;
            final teacherProfile =
                context.watch<TeacherProfileCubit>().state.teacher;

            return RefreshIndicator(
              color: AppColors.primary700,
              backgroundColor: Colors.white,
              onRefresh: _fetchData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Welcome Banner
                    _StaggeredEntrance(
                      index: 0,
                      child: TeacherDashboardWelcomeCard(
                        teacherName: teacherProfile?.fullName,
                        examsAwaitingReview: dashboard.examsAwaitingReview,
                        reportsReadyForReview: dashboard.reportsReadyForReview,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Metrics Grid (activeStudents, classAverage, examsAwaitingReview, reportsReadyForReview, newMessagesCount)
                    _StaggeredEntrance(
                      index: 1,
                      child: TeacherDashboardMetricsGrid(
                        activeStudents: dashboard.activeStudents,
                        classAverage: dashboard.classAverage,
                        examsAwaitingReview: dashboard.examsAwaitingReview,
                        reportsReadyForReview: dashboard.reportsReadyForReview,
                        newMessagesCount: dashboard.newMessagesCount,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Weekly Submissions Activity Chart
                    _StaggeredEntrance(
                      index: 2,
                      child: TeacherDashboardWeeklyChart(
                        weeklyActivity: dashboard.weeklySubmissionsActivity,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Students Needing Attention
                    _StaggeredEntrance(
                      index: 3,
                      child: TeacherDashboardNeedsAttentionSection(
                        students: dashboard.needsAttentionList,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Recent Submissions Activity Feed
                    _StaggeredEntrance(
                      index: 4,
                      child: TeacherDashboardRecentSubmissionsSection(
                        submissions: dashboard.recentSubmissions,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StaggeredEntrance extends StatelessWidget {
  final int index;
  final Widget child;

  const _StaggeredEntrance({required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 550),
      curve: Interval(
        (index * 0.12).clamp(0.0, 0.6),
        1.0,
        curve: Curves.easeOutCubic,
      ),
      builder: (context, t, child) => Opacity(
        opacity: t.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, (1 - t) * 24),
          child: child,
        ),
      ),
      child: child,
    );
  }
}
