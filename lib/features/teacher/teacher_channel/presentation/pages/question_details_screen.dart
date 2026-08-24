import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/core/widgets/custom_app_bar.dart";
import "package:draya_mobile/core/widgets/tappable_network_image.dart";
import "package:draya_mobile/features/teacher/teacher_channel/presentation/cubit/teacher_channel_cubit.dart";
import "package:draya_mobile/features/teacher/teacher_channel/presentation/cubit/teacher_channel_state.dart";
import "package:draya_mobile/features/teacher/teacher_channel/presentation/widgets/add_reply_dialog.dart";
import "package:draya_mobile/features/teacher/teacher_channel/presentation/widgets/reply_card_widget.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";

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
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: "تفاصيل السؤال"),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddReplyDialog(context),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.reply_rounded),
        label: Text(
          "أضف رد",
          style: AppTextStyles.button.copyWith(color: Colors.white),
        ),
      ),
      body: BlocBuilder<TeacherChannelCubit, TeacherChannelState>(
        builder: (context, state) {
          if (state.questionDetailsStatus == CubitStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state.questionDetailsStatus == CubitStatus.error) {
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
                      "حدث خطأ في تحميل تفاصيل السؤال",
                      style: AppTextStyles.h4.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      state.apiErrorModel?.error?.message ?? "خطأ غير معروف",
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<TeacherChannelCubit>().getQuestionDetails(
                          classroomId: widget.classroomId,
                          questionId: widget.questionId,
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
                        "إعادة المحاولة",
                        style: AppTextStyles.button.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final questionDetails = state.questionDetails;
          if (questionDetails == null) {
            return Center(
              child: Text(
                "لم يتم العثور على السؤال",
                style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
              ),
            );
          }

          final dateFormat = DateFormat("d MMMM yyyy، HH:mm", "ar");
          final isVoting = state.votingQuestionId == widget.questionId &&
              state.voteStatus == CubitStatus.loading;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: questionDetails.question.hasTeacherAnswer
                                ? AppColors.primary300
                                : AppColors.border,
                            width: questionDetails.question.hasTeacherAnswer ? 1.5 : 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: questionDetails.question.isAuthor
                                              ? [AppColors.primary600, AppColors.primary400]
                                              : [AppColors.backgroundMuted, AppColors.borderStrong],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        questionDetails.question.isAuthor
                                            ? Icons.person_rounded
                                            : Icons.account_circle_outlined,
                                        size: 22,
                                        color: questionDetails.question.isAuthor
                                            ? Colors.white
                                            : AppColors.foregroundMuted,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              questionDetails.question.isAuthor ? "سؤالك" : "سؤال طالب",
                                              style: AppTextStyles.label.copyWith(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          dateFormat.format(questionDetails.question.createdAt),
                                          style: AppTextStyles.label.copyWith(
                                            fontSize: 11,
                                            color: AppColors.textSecondary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                if (questionDetails.question.hasTeacherAnswer)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary50,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: AppColors.primary300),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.verified_rounded,
                                          size: 14,
                                          color: AppColors.primary,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "إجابة المدرس",
                                          style: AppTextStyles.label.copyWith(
                                            fontSize: 11,
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              questionDetails.question.content,
                              style: AppTextStyles.body.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                                height: 1.6,
                              ),
                            ),
                            if (questionDetails.question.imageUrl != null &&
                                questionDetails.question.imageUrl!
                                    .trim()
                                    .isNotEmpty) ...[
                              const SizedBox(height: 14),
                              TappableNetworkImage(
                                imageUrl: questionDetails.question.imageUrl!,
                                width: double.infinity,
                                height: 220,
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ],
                            const SizedBox(height: 18),
                            const Divider(color: AppColors.border, height: 1),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: isVoting
                                        ? null
                                        : () {
                                            if (questionDetails.question.hasVoted) {
                                              context
                                                  .read<TeacherChannelCubit>()
                                                  .unvoteQuestion(
                                                    classroomId: widget.classroomId,
                                                    questionId: widget.questionId,
                                                  );
                                            } else {
                                              context
                                                  .read<TeacherChannelCubit>()
                                                  .voteQuestion(
                                                    classroomId: widget.classroomId,
                                                    questionId: widget.questionId,
                                                  );
                                            }
                                          },
                                    borderRadius: BorderRadius.circular(20),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: questionDetails.question.hasVoted
                                            ? AppColors.primary50
                                            : AppColors.backgroundSecondary,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: questionDetails.question.hasVoted
                                              ? AppColors.primary300
                                              : AppColors.border,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (isVoting)
                                            const SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(
                                                  AppColors.primary,
                                                ),
                                              ),
                                            )
                                          else
                                            Icon(
                                              questionDetails.question.hasVoted
                                                  ? Icons.thumb_up_rounded
                                                  : Icons.thumb_up_alt_outlined,
                                              size: 18,
                                              color: questionDetails.question.hasVoted
                                                  ? AppColors.primary
                                                  : AppColors.foregroundMuted,
                                            ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "${questionDetails.question.voteCount} تصويت",
                                            style: AppTextStyles.label.copyWith(
                                              fontSize: 13,
                                              fontWeight: questionDetails.question.hasVoted
                                                  ? FontWeight.w800
                                                  : FontWeight.w600,
                                              color: questionDetails.question.hasVoted
                                                  ? AppColors.primary
                                                  : AppColors.foregroundMuted,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.backgroundSecondary,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.chat_bubble_outline_rounded,
                                        size: 16,
                                        color: AppColors.foregroundMuted,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        "${questionDetails.replies.length} ردود",
                                        style: AppTextStyles.label.copyWith(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.foregroundMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            "الردود",
                            style: AppTextStyles.h4.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "${questionDetails.replies.length}",
                              style: AppTextStyles.label.copyWith(
                                fontSize: 12,
                                color: AppColors.primary700,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (questionDetails.replies.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: AppColors.primary50,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primary200),
                            ),
                            child: const Icon(
                              Icons.chat_bubble_outline_rounded,
                              size: 28,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            "لا توجد ردود بعد",
                            style: AppTextStyles.h5.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "كن أول من يضيف رداً أو يقدم حلاً لهذا السؤال!",
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
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
                child: SizedBox(height: 90),
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
                  SnackBar(
                    content: Text(
                      "تم نشر الرد بنجاح",
                      style: AppTextStyles.body.copyWith(color: Colors.white),
                    ),
                    backgroundColor: AppColors.primary,
                  ),
                );
              } else if (state.createReplyStatus == CubitStatus.error) {
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
            child: BlocBuilder<TeacherChannelCubit, TeacherChannelState>(
              builder: (_, state) {
                return AddReplyDialog(
                  questionId: widget.questionId,
                  isLoading: state.createReplyStatus == CubitStatus.loading,
                  onSubmit: (content, image) {
                    cubit.createReply(
                      classroomId: widget.classroomId,
                      questionId: widget.questionId,
                      content: content,
                      image: image,
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
