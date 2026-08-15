import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/student/student_channel/data/models/question_paged_result_model.dart';
import 'package:draya_mobile/features/student/student_channel/domain/repos/student_channel_repo.dart';

class GetQuestionsParams {
  final String classroomId;
  final int page;
  final int pageSize;
  final String sortBy;
  final String filterBy;

  GetQuestionsParams({
    required this.classroomId,
    this.page = 1,
    this.pageSize = 20,
    this.sortBy = 'recent',
    this.filterBy = 'all',
  });
}

class GetQuestionsUseCase {
  final StudentChannelRepo _repository;

  GetQuestionsUseCase(this._repository);

  Future<ApiResult<QuestionPagedResultModel>> call({
    required GetQuestionsParams params,
  }) =>
      _repository.getQuestions(
        params.classroomId,
        page: params.page,
        pageSize: params.pageSize,
        sortBy: params.sortBy,
        filterBy: params.filterBy,
      );
}
