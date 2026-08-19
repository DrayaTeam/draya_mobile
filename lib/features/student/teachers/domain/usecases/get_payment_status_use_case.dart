import 'package:draya_mobile/core/helpers/app_use_case.dart';
import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/student/teachers/data/models/payment_status_model.dart';
import 'package:draya_mobile/features/student/teachers/domain/repos/teacher_repo.dart';

class GetPaymentStatusUseCase
    implements AppUseCase<ApiResult<PaymentStatusModel>, String> {
  final TeacherRepo _teacherRepo;

  GetPaymentStatusUseCase(this._teacherRepo);

  @override
  Future<ApiResult<PaymentStatusModel>> call({String? params}) async {
    final transactionId = params ?? '';
    return _teacherRepo.getPaymentStatus(transactionId);
  }
}
