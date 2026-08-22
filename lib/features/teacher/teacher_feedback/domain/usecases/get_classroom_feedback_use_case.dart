import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/teacher_feedback/data/models/classroom_feedback_paged_result_model.dart";
import "package:draya_mobile/features/teacher/teacher_feedback/domain/repos/teacher_feedback_repo.dart";

class ClassroomFeedbackParams {
  final String classroomId;
  final int page;
  final int pageSize;

  const ClassroomFeedbackParams({
    required this.classroomId,
    this.page = 1,
    this.pageSize = 10,
  });
}

class GetClassroomFeedbackUseCase
    implements
        AppUseCase<
          ApiResult<ClassroomFeedbackPagedResultModel>,
          ClassroomFeedbackParams
        > {
  final TeacherFeedbackRepo _repo;

  GetClassroomFeedbackUseCase(this._repo);

  @override
  Future<ApiResult<ClassroomFeedbackPagedResultModel>> call({
    ClassroomFeedbackParams? params,
  }) {
    final request = params ?? const ClassroomFeedbackParams(classroomId: "");

    return _repo.getClassroomFeedback(
      classroomId: request.classroomId,
      page: request.page,
      pageSize: request.pageSize,
    );
  }
}
