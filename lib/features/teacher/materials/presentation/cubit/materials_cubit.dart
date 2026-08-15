import 'package:draya_mobile/core/enums/cubit_status.dart';
import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/teacher/materials/data/models/materials_request_model.dart';
import 'package:draya_mobile/features/teacher/materials/domain/usecases/upload_materials_use_case.dart';
import 'package:draya_mobile/features/teacher/materials/presentation/cubit/materials_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialsCubit extends Cubit<MaterialsState> {
  final UploadMaterialsUseCase _uploadMaterialsUseCase;

  MaterialsCubit(this._uploadMaterialsUseCase) : super(const MaterialsState());

  Future<void> uploadMaterials({
    required String classroomId,
    required MaterialsRequestModel materialsRequestModel,
  }) async {
    emit(state.copyWith(status: CubitStatus.loading));

    final result = await _uploadMaterialsUseCase.call(
      params: UploadMaterialsParams(
        classroomId: classroomId,
        materialsRequestModel: materialsRequestModel,
      ),
    );

    result.when(
      success: (data) {
        emit(
          state.copyWith(
            status: CubitStatus.success,
          ),
        );
      },
      failure: (apiErrorModel) {
        emit(
          state.copyWith(
            status: CubitStatus.error,
            apiErrorModel: apiErrorModel,
          ),
        );
      },
    );
  }
}
