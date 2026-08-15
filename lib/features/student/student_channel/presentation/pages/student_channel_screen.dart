import 'package:draya_mobile/core/di/dependency_injection.dart';
import 'package:draya_mobile/core/enums/cubit_status.dart';
import 'package:draya_mobile/core/view_models/drawer_model.dart';
import 'package:draya_mobile/core/widgets/app_drawer.dart';
import 'package:draya_mobile/core/widgets/custom_app_bar.dart';
import 'package:draya_mobile/features/student/student_channel/presentation/cubit/student_channel_cubit.dart';
import 'package:draya_mobile/features/student/student_channel/presentation/cubit/student_channel_state.dart';
import 'package:draya_mobile/features/student/student_channel/presentation/widgets/add_question_bottom_sheet.dart';
import 'package:draya_mobile/features/student/student_channel/presentation/widgets/empty_questions_widget.dart';
import 'package:draya_mobile/features/student/student_channel/presentation/widgets/question_card_widget.dart';
import 'package:draya_mobile/features/student/student_channel/presentation/widgets/question_filter_widget.dart';
import 'package:draya_mobile/features/student/student_channel/presentation/pages/question_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      appBar: const CustomAppBar(title: "القناة الرئيسية"),
      drawer: AppDrawer(drawerItemsList: getStudentDrawerItemsList()),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddQuestionSheet(context),
        tooltip: 'اسأل سؤال جديد',
        child: const Icon(Icons.add),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextButton.icon(
                    onPressed: () =>
                        context.read<StudentChannelCubit>().getQuestions(
                          classroomId: classroomId,
                          sortBy: state.sortBy,
                          filterBy: state.filterBy,
                        ),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('هناك أسئلة جديدة — تحديث'),
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
        child: CircularProgressIndicator(),
      );
    }

    if (state.questionsStatus == CubitStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'حدث خطأ: ${state.apiErrorModel?.error?.message ?? "خطأ غير معروف"}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<StudentChannelCubit>().getQuestions(
                  classroomId: classroomId,
                );
              },
              child: const Text('حاول مرة أخرى'),
            ),
          ],
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
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<StudentChannelCubit>().getQuestions(
        classroomId: classroomId,
        sortBy: state.sortBy,
        filterBy: state.filterBy,
      ),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 96),
        itemCount:
            state.questions.length +
            (state.currentPage < state.totalPages ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.questions.length) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: OutlinedButton.icon(
                onPressed: state.isLoadingMore
                    ? null
                    : () => context.read<StudentChannelCubit>().getQuestions(
                        classroomId: classroomId,
                        page: state.currentPage + 1,
                        sortBy: state.sortBy,
                        filterBy: state.filterBy,
                      ),
                icon: state.isLoadingMore
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.keyboard_arrow_down_rounded),
                label: const Text('تحميل المزيد'),
              ),
            );
          }
          final question = state.questions[index];
          return QuestionCardWidget(
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
        },
      ),
    );
  }

  void _showAddQuestionSheet(BuildContext context) {
    final cubit = context.read<StudentChannelCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return BlocProvider.value(
          value: cubit,
          child: BlocListener<StudentChannelCubit, StudentChannelState>(
            listener: (listenerContext, state) {
              if (state.createQuestionStatus == CubitStatus.success) {
                Navigator.of(sheetContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم نشر السؤال بنجاح')),
                );
              } else if (state.createQuestionStatus == CubitStatus.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.apiErrorModel?.error?.message ?? 'حدث خطأ',
                    ),
                    backgroundColor: Colors.red,
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
