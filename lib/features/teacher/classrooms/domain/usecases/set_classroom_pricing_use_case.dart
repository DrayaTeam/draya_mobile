import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/classroom_pricing_model.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/set_classroom_pricing_request_model.dart";
import "package:draya_mobile/features/teacher/classrooms/domain/repos/classroom_repo.dart";

class SetClassroomPricingParams {
  final String classroomId;
  final SetClassroomPricingRequestModel request;
  const SetClassroomPricingParams({required this.classroomId, required this.request});
}

class SetClassroomPricingUseCase implements AppUseCase<ApiResult<ClassroomPricingModel>, SetClassroomPricingParams> {
  final ClassroomRepo _repo;
  SetClassroomPricingUseCase(this._repo);

  @override
  Future<ApiResult<ClassroomPricingModel>> call({SetClassroomPricingParams? params}) =>
      _repo.setClassroomPricing(params!.classroomId, params.request);
}
