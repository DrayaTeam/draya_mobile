import 'package:draya_mobile/core/enums/cubit_status.dart';
import 'package:draya_mobile/core/widgets/custom_app_bar.dart';
import 'package:draya_mobile/features/teacher/teacher_channel/presentation/cubit/teacher_channel_cubit.dart';
import 'package:draya_mobile/features/teacher/teacher_channel/presentation/cubit/teacher_channel_state.dart';
import 'package:draya_mobile/features/teacher/teacher_channel/presentation/widgets/add_reply_dialog.dart';
import 'package:draya_mobile/features/teacher/teacher_channel/presentation/widgets/reply_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class QuestionDetailsScreen extends StatelessWidget {
  final String classroomId;
  final String questionId;

  const QuestionDetailsScreen({
    super.key,
    required this.classroomId,
    required this.questionId,
  });

  @override
  Widget build(BuildContext context) {
    return _QuestionDetailsContent(
      classroomId: classroomId,
      questionId: questionId,
    );
  }
}

class _QuestionDetailsContent extends StatefulWidget {
  final String classroomId;
  final String questionId;

  const _QuestionDetailsContent({
    required this.classroomId,
    required this.questionId,
  });

  @override
  State<_QuestionDetailsContent> createState() =>
      _QuestionDetailsContentState();
}

class _QuestionDetailsContentState extends State<_QuestionDetailsContent> {
  @override
  void initState() {
    super.initState();
    context.read<TeacherChannelCubit>().getQuestionDetails(
      classroomId: widget.classroomId,
      questionId: widget.questionId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "تفاصيل السؤال"),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddReplyDialog(context),
        tooltip: 'أضف رد',
        child: const Icon(Icons.reply),
      ),
      body: BlocBuilder<TeacherChannelCubit, TeacherChannelState>(
        builder: (context, state) {
          if (state.questionDetailsStatus == CubitStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.questionDetailsStatus == CubitStatus.error) {
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
                      context.read<TeacherChannelCubit>().getQuestionDetails(
                        classroomId: widget.classroomId,
                        questionId: widget.questionId,
                      );
                    },
                    child: const Text('حاول مرة أخرى'),
                  ),
                ],
              ),
            );
          }

          final questionDetails = state.questionDetails;
          if (questionDetails == null) {
            return const Center(
              child: Text('لم يتم العثور على السؤال'),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            questionDetails.question.content,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat(
                                  'MMM d, HH:mm',
                                  'ar',
                                ).format(questionDetails.question.createdAt),
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap:
                                        state.votingQuestionId ==
                                            widget.questionId
                                        ? null
                                        : () {
                                            if (questionDetails
                                                .question
                                                .hasVoted) {
                                              context
                                                  .read<TeacherChannelCubit>()
                                                  .unvoteQuestion(
                                                    classroomId:
                                                        widget.classroomId,
                                                    questionId:
                                                        widget.questionId,
                                                  );
                                            } else {
                                              context
                                                  .read<TeacherChannelCubit>()
                                                  .voteQuestion(
                                                    classroomId:
                                                        widget.classroomId,
                                                    questionId:
                                                        widget.questionId,
                                                  );
                                            }
                                          },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.thumb_up_outlined,
                                          size: 18,
                                          color:
                                              questionDetails.question.hasVoted
                                              ? Theme.of(
                                                  context,
                                                ).colorScheme.primary
                                              : Colors.grey[600],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          questionDetails.question.voteCount
                                              .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    questionDetails
                                                        .question
                                                        .hasVoted
                                                    ? Theme.of(
                                                        context,
                                                      ).colorScheme.primary
                                                    : Colors.grey[600],
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'الردود (${questionDetails.replies.length})',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
              ),

              if (questionDetails.replies.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        'لا توجد ردود بعد',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final reply = questionDetails.replies[index];
                      return ReplyCardWidget(reply: reply);
                    },
                    childCount: questionDetails.replies.length,
                  ),
                ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 80),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddReplyDialog(BuildContext context) {
    final cubit = context.read<TeacherChannelCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: cubit,
          child: BlocListener<TeacherChannelCubit, TeacherChannelState>(
            listener: (listenerContext, state) {
              if (state.createReplyStatus == CubitStatus.success) {
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم نشر الرد بنجاح')),
                );
              } else if (state.createReplyStatus == CubitStatus.error) {
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
            child: BlocBuilder<TeacherChannelCubit, TeacherChannelState>(
              builder: (_, state) {
                return AddReplyDialog(
                  questionId: widget.questionId,
                  isLoading: state.createReplyStatus == CubitStatus.loading,
                  onSubmit: (content) {
                    cubit.createReply(
                      classroomId: widget.classroomId,
                      questionId: widget.questionId,
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
