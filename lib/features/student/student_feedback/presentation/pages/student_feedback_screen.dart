import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/core/view_models/drawer_model.dart";
import "package:draya_mobile/core/widgets/app_drawer.dart";
import "package:draya_mobile/core/widgets/custom_app_bar.dart";
import "package:draya_mobile/core/widgets/fade_in_up_animation.dart";
import "package:draya_mobile/features/student/student_feedback/presentation/cubit/student_feedback_cubit.dart";
import "package:draya_mobile/features/student/student_feedback/presentation/cubit/student_feedback_state.dart";
import "package:draya_mobile/features/student/student_feedback/presentation/widgets/feedback_classroom_card.dart";
import "package:draya_mobile/features/student/student_feedback/presentation/widgets/rate_classroom_bottom_sheet.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class StudentFeedbackScreen extends StatefulWidget {
  const StudentFeedbackScreen({super.key});

  @override
  State<StudentFeedbackScreen> createState() => _StudentFeedbackScreenState();
}

class _StudentFeedbackScreenState extends State<StudentFeedbackScreen> {
  int _lastSubmittedCount = 0;

  @override
  void initState() {
    super.initState();
    context.read<StudentFeedbackCubit>().loadEligibleClassrooms();
    _lastSubmittedCount =
        context.read<StudentFeedbackCubit>().state.submittedClassroomIds.length;
  }

  void _openRateSheet(String classroomId, String classroomName) {
    final cubit = context.read<StudentFeedbackCubit>();
    RateClassroomBottomSheet.show(
      context,
      classroomName: classroomName,
      onSubmit: (rating, comment) => cubit.submitFeedback(
        classroomId: classroomId,
        rating: rating,
        comment: comment,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "التقييمات"),
      drawer: AppDrawer(drawerItemsList: getStudentDrawerItemsList()),
      backgroundColor: AppColors.background,
      body:
          BlocConsumer<
            StudentFeedbackCubit,
            StudentFeedbackState
          >(
            listener: (context, state) {
              if (state.submittedClassroomIds.length >
                  _lastSubmittedCount) {
                _lastSubmittedCount = state.submittedClassroomIds.length;
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "تم إرسال تقييمك بنجاح، شكراً لمشاركتك رأيك!",
                      style: AppTextStyles.body
                          .copyWith(color: Colors.white),
                    ),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }

              if (state.status == CubitStatus.error &&
                  state.apiErrorModel?.error?.message != null) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.apiErrorModel!.error!.message!,
                      style: AppTextStyles.body.copyWith(color: Colors.white),
                    ),
                    backgroundColor: AppColors.error,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state.status == CubitStatus.loading &&
                  state.classrooms.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (state.status == CubitStatus.error &&
                  state.classrooms.isEmpty) {
                return _ErrorState(
                  message: state.apiErrorModel?.error?.message ??
                      "تعذر تحميل الفصول الدراسية.",
                  onRetry: () => context
                      .read<StudentFeedbackCubit>()
                      .loadEligibleClassrooms(),
                );
              }

              final classrooms = state.classrooms;

              if (classrooms.isEmpty) {
                return const _EmptyState();
              }

              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () => context
                    .read<StudentFeedbackCubit>()
                    .loadEligibleClassrooms(),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                  children: [
                    const _HeaderCard(),
                    const SizedBox(height: 18),
                    ...classrooms.asMap().entries.map((entry) {
                      final index = entry.key;
                      final classroom = entry.value;
                      final card = Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: FeedbackClassroomCard(
                          classroom: classroom,
                          alreadySubmitted:
                              state.hasSubmitted(classroom.classroomId),
                          onRate: () => _openRateSheet(
                            classroom.classroomId,
                            classroom.name,
                          ),
                        ),
                      );

                      if (index < 6) {
                        return FadeInUp(delay: index * 50, child: card);
                      }
                      return card;
                    }),
                  ],
                ),
              );
            },
          ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary800, AppColors.primary600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary700.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.reviews_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "رأيك يهمنا",
                  style: AppTextStyles.h4.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "قيّم فصولك الدراسية وساعدنا على تطوير تجربة التعلم.",
                  style: AppTextStyles.body.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13,
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

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 32,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "حدث خطأ في تحميل الفصول",
              style: AppTextStyles.h5.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style:
                  AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(
                "إعادة المحاولة",
                style: AppTextStyles.button.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.primary50,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary200, width: 1.5),
              ),
              child: const Icon(
                Icons.reviews_outlined,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "لا توجد فصول لتقييمها بعد",
              style: AppTextStyles.h4.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "انضم إلى فصل دراسي أولاً، ثم شاركنا رأيك هنا.",
              textAlign: TextAlign.center,
              style:
                  AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
