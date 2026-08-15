import 'package:draya_mobile/core/helpers/app_use_case.dart';
import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/student/teachers/data/models/classroom_checkout_response_model.dart';
import 'package:draya_mobile/features/student/teachers/domain/repos/teacher_repo.dart';

class CheckoutClassroomUseCase
    implements AppUseCase<ApiResult<ClassroomCheckoutResponseModel>, String> {
  final TeacherRepo _teacherRepo;

  CheckoutClassroomUseCase(this._teacherRepo);

  @override
  Future<ApiResult<ClassroomCheckoutResponseModel>> call({String? params}) async {
    final classroomId = params ?? '';
    return _teacherRepo.checkoutClassroom(classroomId);
  }
}
