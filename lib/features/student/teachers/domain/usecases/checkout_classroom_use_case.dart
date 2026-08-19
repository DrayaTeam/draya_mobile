import 'package:draya_mobile/core/helpers/app_use_case.dart';
import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/student/teachers/data/models/classroom_checkout_response_model.dart';
import 'package:draya_mobile/features/student/teachers/data/models/classroom_checkout_request_model.dart';
import 'package:draya_mobile/features/student/teachers/domain/repos/teacher_repo.dart';

class CheckoutClassroomUseCase
    implements
        AppUseCase<ApiResult<ClassroomCheckoutResponseModel>, CheckoutClassroomParams> {
  final TeacherRepo _teacherRepo;

  CheckoutClassroomUseCase(this._teacherRepo);

  @override
  Future<ApiResult<ClassroomCheckoutResponseModel>> call({
    CheckoutClassroomParams? params,
  }) async {
    final request = params ?? const CheckoutClassroomParams.empty();
    return _teacherRepo.checkoutClassroom(
      request.classroomId,
      ClassroomCheckoutRequestModel(redirectionUrl: request.redirectionUrl),
    );
  }
}

class CheckoutClassroomParams {
  final String classroomId;
  final String redirectionUrl;

  const CheckoutClassroomParams({
    required this.classroomId,
    required this.redirectionUrl,
  });

  const CheckoutClassroomParams.empty()
      : classroomId = '',
        redirectionUrl = '';
}
