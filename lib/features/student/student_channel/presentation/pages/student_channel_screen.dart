import "package:draya_mobile/core/di/dependency_injection.dart";
import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/core/view_models/drawer_model.dart";
import "package:draya_mobile/core/widgets/app_drawer.dart";
import "package:draya_mobile/core/widgets/custom_app_bar.dart";
import "package:draya_mobile/core/widgets/fade_in_up_animation.dart";
import "package:draya_mobile/features/student/student_channel/presentation/cubit/student_channel_cubit.dart";
import "package:draya_mobile/features/student/student_channel/presentation/cubit/student_channel_state.dart";
import "package:draya_mobile/features/student/student_channel/presentation/pages/question_details_screen.dart";
import "package:draya_mobile/features/student/student_channel/presentation/widgets/add_question_bottom_sheet.dart";
import "package:draya_mobile/features/student/student_channel/presentation/widgets/empty_questions_widget.dart";
import "package:draya_mobile/features/student/student_channel/presentation/widgets/question_card_widget.dart";
import "package:draya_mobile/features/student/student_channel/presentation/widgets/question_filter_widget.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class StudentChannelScreen extends StatelessWidget {
  final String classroomId;

  const StudentChannelScreen({
    super.key,
    required this.classroomId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<StudentChannelCubit>()
            ..initializeChannel(classroomId: classroomId),
      child: _StudentChannelContent(classroomId: classroomId),
    );
  }
}

class _StudentChannelContent extends StatelessWidget {
  final String classroomId;

  const _StudentChannelContent({required this.classroomId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: "القناة الرئيسية"),
      drawer: AppDrawer(drawerItemsList: getStudentDrawerItemsList()),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddQuestionSheet(context),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add_rounded),
        label: Text(
          "اسأل سؤالاً",
          style: AppTextStyles.button.copyWith(color: Colors.white),
        ),
      ),
      body: BlocBuilder<StudentChannelCubit, StudentChannelState>(
        builder: (context, state) {
          return Column(
            children: [
              QuestionFilterWidget(
                currentSort: state.sortBy,
                currentFilter: state.filterBy,
                onSortChanged: (sort) {
                  context.read<StudentChannelCubit>().getQuestions(
                    classroomId: classroomId,
                    sortBy: sort,
                    filterBy: state.filterBy,
                  );
                },
                onFilterChanged: (filter) {
                  context.read<StudentChannelCubit>().getQuestions(
                    classroomId: classroomId,
                    sortBy: state.sortBy,
                    filterBy: filter,
                  );
                },
              ),
              if (state.hasPendingNewQuestions)
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 10, 16, 4),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () =>
                          context.read<StudentChannelCubit>().getQuestions(
                            classroomId: classroomId,
                            sortBy: state.sortBy,
                            filterBy: state.filterBy,
                          ),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.primary300),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.refresh_rounded,
                              size: 18,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "هناك أسئلة جديدة — اضغط للتحديث",
                              style: AppTextStyles.label.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              Expanded(
                child: _buildContent(context, state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, StudentChannelState state) {
    if (state.questionsStatus == CubitStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (state.questionsStatus == CubitStatus.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  size: 36,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "تعذر تحميل الأسئلة",
                style: AppTextStyles.h4.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                state.apiErrorModel?.error?.message ?? "حدث خطأ غير متوقع",
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<StudentChannelCubit>().getQuestions(
                    classroomId: classroomId,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
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
                  "حاول مرة أخرى",
                  style: AppTextStyles.button.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (state.questions.isEmpty) {
      return EmptyQuestionsWidget(
        onRefresh: () {
          context.read<StudentChannelCubit>().getQuestions(
            classroomId: classroomId,
          );
        },
        onAction: () => _showAddQuestionSheet(context),
        actionLabel: "اسأل سؤالاً جديداً",
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
      onRefresh: () => context.read<StudentChannelCubit>().getQuestions(
        classroomId: classroomId,
        sortBy: state.sortBy,
        filterBy: state.filterBy,
      ),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 96),
        itemCount:
            state.questions.length +
            (state.currentPage < state.totalPages ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.questions.length) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: SizedBox(
                  width: 200,
                  child: OutlinedButton.icon(
                    onPressed: state.isLoadingMore
                        ? null
                        : () => context.read<StudentChannelCubit>().getQuestions(
                            classroomId: classroomId,
                            page: state.currentPage + 1,
                            sortBy: state.sortBy,
                            filterBy: state.filterBy,
                          ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary300),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: state.isLoadingMore
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary,
                              ),
                            ),
                          )
                        : const Icon(Icons.expand_more_rounded, size: 20),
                    label: Text(
                      "تحميل المزيد",
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          final question = state.questions[index];
          final card = QuestionCardWidget(
            question: question,
            isVoting:
                state.votingQuestionId == question.id &&
                state.voteStatus == CubitStatus.loading,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<StudentChannelCubit>(),
                    child: QuestionDetailsScreen(
                      classroomId: classroomId,
                      questionId: question.id,
                    ),
                  ),
                ),
              );
            },
            onVote: () {
              if (question.hasVoted) {
                context.read<StudentChannelCubit>().unvoteQuestion(
                  classroomId: classroomId,
                  questionId: question.id,
                );
              } else {
                context.read<StudentChannelCubit>().voteQuestion(
                  classroomId: classroomId,
                  questionId: question.id,
                );
              }
            },
          );

          if (index < 5) {
            return FadeInUp(
              delay: index * 60,
              child: card,
            );
          }
          return card;
        },
      ),
    );
  }

  void _showAddQuestionSheet(BuildContext context) {
    final cubit = context.read<StudentChannelCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return BlocProvider.value(
          value: cubit,
          child: BlocListener<StudentChannelCubit, StudentChannelState>(
            listener: (listenerContext, state) {
              if (state.createQuestionStatus == CubitStatus.success) {
                Navigator.of(sheetContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "تم نشر السؤال بنجاح",
                      style: AppTextStyles.body.copyWith(color: Colors.white),
                    ),
                    backgroundColor: AppColors.primary,
                  ),
                );
              } else if (state.createQuestionStatus == CubitStatus.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.apiErrorModel?.error?.message ?? "حدث خطأ",
                      style: AppTextStyles.body.copyWith(color: Colors.white),
                    ),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            child: BlocBuilder<StudentChannelCubit, StudentChannelState>(
              builder: (_, state) {
                return AddQuestionBottomSheet(
                  isLoading: state.createQuestionStatus == CubitStatus.loading,
                  onSubmit: (content) {
                    cubit.createQuestion(
                      classroomId: classroomId,
                      content: content,
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

