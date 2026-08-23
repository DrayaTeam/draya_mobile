import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/features/student/exams_history/presentation/cubit/exams_history_cubit.dart";
import "package:draya_mobile/features/student/exams_history/presentation/cubit/exams_history_state.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "classroom_filter_chips.dart";
import "exam_history_card.dart";
import "exams_history_stats_header.dart";

class ExamsHistoryBody extends StatefulWidget {
  const ExamsHistoryBody({super.key});

  @override
  State<ExamsHistoryBody> createState() => _ExamsHistoryBodyState();
}

class _ExamsHistoryBodyState extends State<ExamsHistoryBody> {
  @override
  void initState() {
    super.initState();
    context.read<ExamsHistoryCubit>().getExamsHistory();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExamsHistoryCubit, ExamsHistoryState>(
      builder: (context, state) {
        if ((state.status == CubitStatus.initial ||
                state.status == CubitStatus.loading) &&
            state.exams.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (state.status == CubitStatus.error ||
            state.status == CubitStatus.initial ||
            state.exams.isEmpty) {
          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () =>
                context.read<ExamsHistoryCubit>().getExamsHistory(),
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: constraints.maxHeight,
                  child: _buildEmptyState(state),
                ),
              ),
            ),
          );
        }

        final filteredExams = state.selectedClassroomId == null
            ? state.exams
            : state.exams
                .where((e) => e.classroomId == state.selectedClassroomId)
                .toList();

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => context.read<ExamsHistoryCubit>().getExamsHistory(),
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent - 200) {
                context.read<ExamsHistoryCubit>().loadMore();
              }
              return false;
            },
            child: ListView(
              padding: const EdgeInsets.all(AppSizes.s16),
              children: [
                ExamsHistoryStatsHeader(exams: filteredExams),
                const SizedBox(height: AppSizes.s16),
                ClassroomFilterChips(
                  exams: state.exams,
                  selectedClassroomId: state.selectedClassroomId,
                  onSelected: (classroomId) => context
                      .read<ExamsHistoryCubit>()
                      .selectClassroom(classroomId),
                ),
                const SizedBox(height: AppSizes.s12),
                ...filteredExams.asMap().entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSizes.s12),
                        child: ExamHistoryCard(exam: entry.value),
                      ),
                    ),
                if (!state.hasReachedMax)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSizes.s16),
                    child: Center(
                      child: SizedBox(
                        width: AppSizes.s24,
                        height: AppSizes.s24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  )
                else if (filteredExams.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSizes.s24),
                    child: Text(
                      "لا توجد امتحانات في هذا الفصل",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body.copyWith(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(ExamsHistoryState state) {
    final isError = state.status == CubitStatus.error;
    return Padding(
      padding: const EdgeInsets.all(AppSizes.s32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  (isError ? AppColors.error : AppColors.amber)
                      .withValues(alpha: 0.16),
                  (isError ? AppColors.error : AppColors.amber)
                      .withValues(alpha: 0.06),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: (isError ? AppColors.error : AppColors.amber)
                    .withValues(alpha: 0.25),
              ),
            ),
            child: Icon(
              isError ? Icons.error_outline_rounded : Icons.history_rounded,
              size: 38,
              color: isError ? AppColors.error : AppColors.amber,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isError ? "حدث خطأ" : "لا يوجد سجل محاولات بعد",
            style: AppTextStyles.h5.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isError
                ? "تعذر تحميل سجل المحاولات، حاول مرة أخرى"
                : "بعد أداء أي امتحان ستظهر هنا جميع محاولاتك ودرجاتها.",
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12.5,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () =>
                context.read<ExamsHistoryCubit>().getExamsHistory(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.s12),
              ),
              elevation: 0,
            ),
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: Text(
              "تحديث",
              style: AppTextStyles.button.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
