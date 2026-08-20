import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_error_model.dart";
import "package:draya_mobile/features/teacher/teacher_channel/domain/entity/question_details_entity.dart";
import "package:draya_mobile/features/teacher/teacher_channel/domain/entity/question_entity.dart";

class TeacherChannelState {
  final CubitStatus questionsStatus;
  final List<QuestionEntity> questions;
  final int currentPage;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final String sortBy;
  final String filterBy;
  final bool isLoadingMore;
  final bool hasPendingNewQuestions;

  final CubitStatus questionDetailsStatus;
  final QuestionDetailsEntity? questionDetails;

  final CubitStatus createQuestionStatus;

  final CubitStatus createReplyStatus;

  final CubitStatus voteStatus;
  final String? votingQuestionId;

  final ApiErrorModel? apiErrorModel;

  const TeacherChannelState({
    this.questionsStatus = CubitStatus.initial,
    this.questions = const [],
    this.currentPage = 1,
    this.pageSize = 20,
    this.totalCount = 0,
    this.totalPages = 0,
    this.sortBy = "recent",
    this.filterBy = "all",
    this.isLoadingMore = false,
    this.hasPendingNewQuestions = false,
    this.questionDetailsStatus = CubitStatus.initial,
    this.questionDetails,
    this.createQuestionStatus = CubitStatus.initial,
    this.createReplyStatus = CubitStatus.initial,
    this.voteStatus = CubitStatus.initial,
    this.votingQuestionId,
    this.apiErrorModel,
  });

  TeacherChannelState copyWith({
    CubitStatus? questionsStatus,
    List<QuestionEntity>? questions,
    int? currentPage,
    int? pageSize,
    int? totalCount,
    int? totalPages,
    String? sortBy,
    String? filterBy,
    bool? isLoadingMore,
    bool? hasPendingNewQuestions,
    CubitStatus? questionDetailsStatus,
    QuestionDetailsEntity? questionDetails,
    CubitStatus? createQuestionStatus,
    CubitStatus? createReplyStatus,
    CubitStatus? voteStatus,
    String? votingQuestionId,
    ApiErrorModel? apiErrorModel,
  }) {
    return TeacherChannelState(
      questionsStatus: questionsStatus ?? this.questionsStatus,
      questions: questions ?? this.questions,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalCount: totalCount ?? this.totalCount,
      totalPages: totalPages ?? this.totalPages,
      sortBy: sortBy ?? this.sortBy,
      filterBy: filterBy ?? this.filterBy,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasPendingNewQuestions:
          hasPendingNewQuestions ?? this.hasPendingNewQuestions,
      questionDetailsStatus:
          questionDetailsStatus ?? this.questionDetailsStatus,
      questionDetails: questionDetails ?? this.questionDetails,
      createQuestionStatus: createQuestionStatus ?? this.createQuestionStatus,
      createReplyStatus: createReplyStatus ?? this.createReplyStatus,
      voteStatus: voteStatus ?? this.voteStatus,
      votingQuestionId: votingQuestionId ?? this.votingQuestionId,
      apiErrorModel: apiErrorModel ?? this.apiErrorModel,
    );
  }
}
