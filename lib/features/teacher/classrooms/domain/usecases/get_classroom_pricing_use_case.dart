import 'package:draya_mobile/core/helpers/app_use_case.dart';
import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/teacher/classrooms/data/models/classroom_pricing_model.dart';
import 'package:draya_mobile/features/teacher/classrooms/domain/repos/classroom_repo.dart';

class GetClassroomPricingUseCase implements AppUseCase<ApiResult<ClassroomPricingModel>, String> {
  final ClassroomRepo _repo;
  GetClassroomPricingUseCase(this._repo);

  @override
  Future<ApiResult<ClassroomPricingModel>> call({String? params}) =>
      _repo.getClassroomPricing(params!);
}
