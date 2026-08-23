import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/materials/data/models/materials_request_model.dart";
import "package:draya_mobile/features/teacher/materials/domain/usecases/delete_material_use_case.dart";
import "package:draya_mobile/features/teacher/materials/domain/usecases/get_materials_use_case.dart";
import "package:draya_mobile/features/teacher/materials/domain/usecases/upload_materials_use_case.dart";
import "package:draya_mobile/features/teacher/materials/presentation/cubit/materials_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class MaterialsCubit extends Cubit<MaterialsState> {
  final UploadMaterialsUseCase _uploadMaterialsUseCase;
  final GetMaterialsUseCase _getMaterialsUseCase;
  final DeleteMaterialUseCase _deleteMaterialUseCase;

  MaterialsCubit(
    this._uploadMaterialsUseCase,
    this._getMaterialsUseCase,
    this._deleteMaterialUseCase,
  ) : super(const MaterialsState());

  Future<void> uploadMaterials({
    required String sectionId,
    required MaterialsRequestModel materialsRequestModel,
  }) async {
    emit(
      state.copyWith(
        uploadMaterialsStatus: CubitStatus.loading,
        deleteMaterialStatus: CubitStatus.initial,
        getMaterialsStatus: CubitStatus.initial,
      ),
    );

    final result = await _uploadMaterialsUseCase.call(
      params: UploadMaterialsParams(
        sectionId: sectionId,
        materialsRequestModel: materialsRequestModel,
      ),
    );

    result.when(
      success: (data) {
        emit(
          state.copyWith(
            uploadMaterialsStatus: CubitStatus.success,
            getMaterialsStatus: CubitStatus.initial,
            deleteMaterialStatus: CubitStatus.initial,
          ),
        );
      },
      failure: (apiErrorModel) {
        emit(
          state.copyWith(
            uploadMaterialsStatus: CubitStatus.error,
            getMaterialsStatus: CubitStatus.initial,
            deleteMaterialStatus: CubitStatus.initial,
            apiErrorModel: apiErrorModel,
          ),
        );
      },
    );
  }

  Future<void> getMaterials({
    required GetMaterialsParams getMaterialsParams,
  }) async {
    emit(
      state.copyWith(
        getMaterialsStatus: CubitStatus.loading,
        uploadMaterialsStatus: CubitStatus.initial,
        deleteMaterialStatus: CubitStatus.initial,
      ),
    );

    final result = await _getMaterialsUseCase.call(params: getMaterialsParams);

    result.when(
      success: (sectionModel) {
        emit(
          state.copyWith(
            getMaterialsStatus: CubitStatus.success,
            uploadMaterialsStatus: CubitStatus.initial,
            deleteMaterialStatus: CubitStatus.initial,
            sectionModel: sectionModel,
          ),
        );
      },
      failure: (apiErrorModel) {
        emit(
          state.copyWith(
            getMaterialsStatus: CubitStatus.error,
            uploadMaterialsStatus: CubitStatus.error,
            deleteMaterialStatus: CubitStatus.initial,
            apiErrorModel: apiErrorModel,
          ),
        );
      },
    );
  }

  Future<void> deleteMaterial({required String materialId}) async {
    emit(
      state.copyWith(
        deleteMaterialStatus: CubitStatus.loading,
        getMaterialsStatus: CubitStatus.initial,
        uploadMaterialsStatus: CubitStatus.initial,
      ),
    );

    final result = await _deleteMaterialUseCase(params: materialId);

    result.when(
      success: (nothing) {
        emit(
          state.copyWith(
            deleteMaterialStatus: CubitStatus.success,
            getMaterialsStatus: CubitStatus.initial,
            uploadMaterialsStatus: CubitStatus.initial,
          ),
        );
      },
      failure: (apiErrorModel) {
        emit(
          state.copyWith(
            deleteMaterialStatus: CubitStatus.error,
            apiErrorModel: apiErrorModel,
            getMaterialsStatus: CubitStatus.initial,
            uploadMaterialsStatus: CubitStatus.initial,
          ),
        );
      },
    );
  }
}
