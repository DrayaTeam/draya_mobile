import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/helpers/app_token_helper.dart";
import "package:draya_mobile/core/networking/api_constants.dart";
import "package:draya_mobile/core/networking/api_error_model.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/core/signalr/signalr_events.dart";
import "package:draya_mobile/core/signalr/signalr_service.dart";
import "package:draya_mobile/features/student/student_channel/data/models/question_model.dart";
import "package:draya_mobile/features/student/student_channel/data/models/reply_model.dart";
import "package:draya_mobile/features/student/student_channel/domain/entity/question_details_entity.dart";
import "package:draya_mobile/features/student/student_channel/domain/entity/question_entity.dart";
import "package:draya_mobile/features/student/student_channel/domain/entity/reply_entity.dart";
import "package:draya_mobile/features/student/student_channel/domain/usecases/create_question_use_case.dart";
import "package:draya_mobile/features/student/student_channel/domain/usecases/create_reply_use_case.dart";
import "package:draya_mobile/features/student/student_channel/domain/usecases/get_question_details_use_case.dart";
import "package:draya_mobile/features/student/student_channel/domain/usecases/get_questions_use_case.dart";
import "package:draya_mobile/features/student/student_channel/domain/usecases/unvote_question_use_case.dart";
import "package:draya_mobile/features/student/student_channel/domain/usecases/vote_question_use_case.dart";
import "package:draya_mobile/features/student/student_channel/presentation/cubit/student_channel_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class StudentChannelCubit extends Cubit<StudentChannelState> {
  StudentChannelCubit(
    this._getQuestions,
    this._createQuestion,
    this._getDetails,
    this._createReply,
    this._vote,
    this._unvote,
    this._signalR,
  ) : super(const StudentChannelState());

  final GetQuestionsUseCase _getQuestions;
  final CreateQuestionUseCase _createQuestion;
  final GetQuestionDetailsUseCase _getDetails;
  final CreateReplyUseCase _createReply;
  final VoteQuestionUseCase _vote;
  final UnvoteQuestionUseCase _unvote;
  final SignalRService _signalR;
  String _classroomId = "";
  bool _listening = false;

  Future<void> initializeChannel({required String classroomId}) async {
    _classroomId = classroomId;
    _listenToRealtimeEvents();
    await _connectToRealtimeChannel();
    await getQuestions(classroomId: classroomId);
  }

  Future<void> _connectToRealtimeChannel() async {
    final token = await AppTokenHelper.getAccessToken();
    if (token == null || token.isEmpty) return;
    try {
      final apiUri = Uri.parse(ApiConstants.baseUrl);
      await _signalR.connect(
        hubUrl: apiUri.replace(path: "/hubs/qa", query: null).toString(),
        token: token,
      );
      await _signalR.joinClassroom(_classroomId);
    } catch (_) {
      // REST remains available when a real-time connection cannot be opened.
    }
  }

  Future<void> getQuestions({
    required String classroomId,
    int page = 1,
    String? sortBy,
    String? filterBy,
  }) async {
    final sort = sortBy ?? state.sortBy;
    final filter = filterBy ?? state.filterBy;
    final loadingMore = page > 1;
    emit(
      state.copyWith(
        questionsStatus: loadingMore
            ? state.questionsStatus
            : CubitStatus.loading,
        isLoadingMore: loadingMore,
        currentPage: page,
        sortBy: sort,
        filterBy: filter,
        apiErrorModel: null,
      ),
    );
    final result = await _getQuestions.call(
      params: GetQuestionsParams(
        classroomId: classroomId,
        page: page,
        pageSize: state.pageSize,
        sortBy: sort,
        filterBy: filter,
      ),
    );
    result.when(
      success: (paged) {
        final received = paged.items.map((item) => item.toEntity()).toList();
        final questions = loadingMore
            ? [
                ...state.questions,
                ...received.where((item) => !state.questions.contains(item)),
              ]
            : received;
        emit(
          state.copyWith(
            questionsStatus: CubitStatus.success,
            isLoadingMore: false,
            questions: questions,
            currentPage: paged.page,
            totalCount: paged.totalCount,
            totalPages: paged.totalPages,
            hasPendingNewQuestions: false,
          ),
        );
      },
      failure: (error) => emit(
        state.copyWith(
          questionsStatus: loadingMore
              ? CubitStatus.success
              : CubitStatus.error,
          isLoadingMore: false,
          apiErrorModel: error,
        ),
      ),
    );
  }

  Future<void> createQuestion({
    required String classroomId,
    required String content,
  }) async {
    if (content.trim().isEmpty) return _validationError(isQuestion: true);
    emit(
      state.copyWith(
        createQuestionStatus: CubitStatus.loading,
        apiErrorModel: null,
      ),
    );
    final result = await _createQuestion.call(
      params: CreateQuestionParams(
        classroomId: classroomId,
        content: content.trim(),
      ),
    );
    result.when(
      success: (model) {
        final question = model.toEntity();
        final addToList =
            state.sortBy == "recent" && !state.questions.contains(question);
        emit(
          state.copyWith(
            createQuestionStatus: CubitStatus.success,
            questions: addToList
                ? [question, ...state.questions]
                : state.questions,
            totalCount: addToList ? state.totalCount + 1 : state.totalCount,
          ),
        );
      },
      failure: (error) => emit(
        state.copyWith(
          createQuestionStatus: CubitStatus.error,
          apiErrorModel: error,
        ),
      ),
    );
  }

  Future<void> getQuestionDetails({
    required String classroomId,
    required String questionId,
  }) async {
    emit(
      state.copyWith(
        questionDetailsStatus: CubitStatus.loading,
        apiErrorModel: null,
      ),
    );
    final result = await _getDetails.call(
      params: GetQuestionDetailsParams(
        classroomId: classroomId,
        questionId: questionId,
      ),
    );
    result.when(
      success: (details) => emit(
        state.copyWith(
          questionDetailsStatus: CubitStatus.success,
          questionDetails: QuestionDetailsEntity(
            question: details.question.toEntity(),
            replies: details.replies.map((reply) => reply.toEntity()).toList(),
          ),
        ),
      ),
      failure: (error) => emit(
        state.copyWith(
          questionDetailsStatus: CubitStatus.error,
          apiErrorModel: error,
        ),
      ),
    );
  }

  Future<void> createReply({
    required String classroomId,
    required String questionId,
    required String content,
  }) async {
    if (content.trim().isEmpty) return _validationError(isQuestion: false);
    emit(
      state.copyWith(
        createReplyStatus: CubitStatus.loading,
        apiErrorModel: null,
      ),
    );
    final result = await _createReply.call(
      params: CreateReplyParams(
        classroomId: classroomId,
        questionId: questionId,
        content: content.trim(),
      ),
    );
    result.when(
      success: (model) {
        _addReply(model.toEntity());
        emit(state.copyWith(createReplyStatus: CubitStatus.success));
      },
      failure: (error) => emit(
        state.copyWith(
          createReplyStatus: CubitStatus.error,
          apiErrorModel: error,
        ),
      ),
    );
  }

  void _validationError({required bool isQuestion}) => emit(
    state.copyWith(
      createQuestionStatus: isQuestion
          ? CubitStatus.error
          : state.createQuestionStatus,
      createReplyStatus: isQuestion
          ? state.createReplyStatus
          : CubitStatus.error,
      apiErrorModel: ApiErrorModel(
        retry: false,
        error: ErrorModel(
          message: isQuestion
              ? "يرجى إدخال محتوى السؤال"
              : "يرجى إدخال محتوى الرد",
        ),
      ),
    ),
  );

  Future<void> voteQuestion({
    required String classroomId,
    required String questionId,
  }) => _changeVote(classroomId, questionId, true);
  Future<void> unvoteQuestion({
    required String classroomId,
    required String questionId,
  }) => _changeVote(classroomId, questionId, false);

  Future<void> _changeVote(
    String classroomId,
    String questionId,
    bool shouldVote,
  ) async {
    final original = _questionById(questionId);
    if (original == null || original.hasVoted == shouldVote) return;
    _replaceQuestion(
      original.copyWith(
        voteCount: (original.voteCount + (shouldVote ? 1 : -1)).clamp(
          0,
          1 << 31,
        ),
        hasVoted: shouldVote,
      ),
    );
    emit(
      state.copyWith(
        voteStatus: CubitStatus.loading,
        votingQuestionId: questionId,
        apiErrorModel: null,
      ),
    );
    final result = shouldVote
        ? await _vote.call(
            params: VoteQuestionParams(
              classroomId: classroomId,
              questionId: questionId,
            ),
          )
        : await _unvote.call(
            params: UnvoteQuestionParams(
              classroomId: classroomId,
              questionId: questionId,
            ),
          );
    result.when(
      success: (_) => emit(
        state.copyWith(voteStatus: CubitStatus.success, votingQuestionId: null),
      ),
      failure: (error) {
        _replaceQuestion(original);
        emit(
          state.copyWith(
            voteStatus: CubitStatus.error,
            votingQuestionId: null,
            apiErrorModel: error,
          ),
        );
      },
    );
  }

  QuestionEntity? _questionById(String id) {
    if (state.questionDetails?.question.id == id) {
      return state.questionDetails!.question;
    }
    for (final question in state.questions) {
      if (question.id == id) return question;
    }
    return null;
  }

  void _replaceQuestion(QuestionEntity updated) {
    final details = state.questionDetails;
    emit(
      state.copyWith(
        questions: state.questions
            .map((q) => q.id == updated.id ? updated : q)
            .toList(),
        questionDetails: details?.question.id == updated.id
            ? QuestionDetailsEntity(
                question: updated,
                replies: details!.replies,
              )
            : details,
      ),
    );
  }

  void _addReply(ReplyEntity reply) {
    final details = state.questionDetails;
    if (details == null ||
        details.question.id != reply.questionId ||
        details.replies.contains(reply)) {
      return;
    }
    final replies = [...details.replies, reply];
    final question = details.question.copyWith(
      replyCount: replies.length,
      hasTeacherAnswer:
          details.question.hasTeacherAnswer || reply.isTeacherAnswer,
    );
    emit(
      state.copyWith(
        questions: state.questions
            .map((q) => q.id == question.id ? question : q)
            .toList(),
        questionDetails: QuestionDetailsEntity(
          question: question,
          replies: replies,
        ),
      ),
    );
  }

  void _listenToRealtimeEvents() {
    if (_listening) return;
    _listening = true;
    _signalR.onQuestionCreated(_onQuestionCreated);
    _signalR.onQuestionReplied(_onQuestionReplied);
    _signalR.onQuestionVoteUpdated(_onQuestionVoteUpdated);
  }

  void _onQuestionCreated(QuestionCreatedEvent event) {
    if (isClosed || event.classroomId != _classroomId) return;
    if (state.sortBy != "recent") {
      emit(state.copyWith(hasPendingNewQuestions: true));
      return;
    }
    final question = QuestionEntity(
      id: event.questionId,
      classroomId: event.classroomId,
      authorId: event.authorId,
      content: event.content,
      createdAt: event.createdAt,
      voteCount: 0,
      replyCount: 0,
      hasTeacherAnswer: false,
      hasVoted: false,
      isAuthor: false,
    );
    if (!state.questions.contains(question)) {
      emit(
        state.copyWith(
          questions: [question, ...state.questions],
          totalCount: state.totalCount + 1,
        ),
      );
    }
  }

  void _onQuestionReplied(QuestionRepliedEvent event) {
    if (isClosed || event.classroomId != _classroomId) return;
    final detailsOpen = state.questionDetails?.question.id == event.questionId;
    _addReply(
      ReplyEntity(
        id: event.replyId,
        questionId: event.questionId,
        authorId: event.authorId,
        content: event.content,
        createdAt: event.createdAt,
        isTeacherAnswer: event.isTeacherAnswer,
        isAuthor: false,
      ),
    );
    if (!detailsOpen) {
      final question = _questionById(event.questionId);
      if (question != null) {
        _replaceQuestion(
          question.copyWith(
            replyCount: question.replyCount + 1,
            hasTeacherAnswer:
                question.hasTeacherAnswer || event.isTeacherAnswer,
          ),
        );
      }
    }
  }

  void _onQuestionVoteUpdated(QuestionVoteUpdatedEvent event) {
    if (isClosed || event.classroomId != _classroomId) return;
    final question = _questionById(event.questionId);
    if (question != null) {
      _replaceQuestion(question.copyWith(voteCount: event.voteCount));
    }
  }

  @override
  Future<void> close() async {
    _signalR.offEvent("QuestionCreated");
    _signalR.offEvent("QuestionReplied");
    _signalR.offEvent("QuestionVoteUpdated");
    if (_classroomId.isNotEmpty) await _signalR.leaveClassroom(_classroomId);
    await _signalR.disconnect();
    return super.close();
  }
}
