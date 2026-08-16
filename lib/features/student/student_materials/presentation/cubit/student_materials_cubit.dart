import 'package:draya_mobile/core/enums/cubit_status.dart';
import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/student/student_materials/domain/entity/student_material.dart';
import 'package:draya_mobile/features/student/student_materials/domain/usecases/get_enrolled_materials_use_case.dart';
import 'package:draya_mobile/features/student/student_materials/domain/usecases/get_material_stream_use_case.dart';
import 'package:draya_mobile/features/student/student_materials/presentation/cubit/student_materials_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentMaterialsCubit extends Cubit<StudentMaterialsState> {
  final GetEnrolledMaterialsUseCase _getEnrolledMaterialsUseCase;
  final GetMaterialStreamUseCase _getMaterialStreamUseCase;

  StudentMaterialsCubit(
    this._getEnrolledMaterialsUseCase,
    this._getMaterialStreamUseCase,
  ) : super(const StudentMaterialsState());

  Future<void> getEnrolledMaterials({String? classroomId, int page = 1}) async {
    emit(
      state.copyWith(materialsStatus: CubitStatus.loading, clearError: true),
    );

    final result = await _getEnrolledMaterialsUseCase.call(
      params: GetEnrolledMaterialsParams(classroomId: classroomId, page: page),
    );
    switch (result) {
      case Success(data: final materialsPage):
        emit(
        state.copyWith(
          materialsStatus: CubitStatus.success,
          materials: page == 1
              ? materialsPage.items
              : [...state.materials, ...materialsPage.items],
          pageNumber: materialsPage.pageNumber,
          pageSize: materialsPage.pageSize,
          totalCount: materialsPage.totalCount,
          totalPages: materialsPage.totalPages,
          hasNextPage: materialsPage.hasNextPage,
        ),
      );
      case Failure(apiErrorModel: final error):
        emit(
        state.copyWith(
          materialsStatus: CubitStatus.error,
          apiErrorModel: error,
        ),
      );
    }
  }

  Future<void> openMaterial(StudentMaterial material) async {
    if (!material.currentVersion.isReady) {
      return;
    }

    if (!material.isVideo) {
      final fileUrl = material.currentVersion.fileUrl;
      if (fileUrl == null || fileUrl.isEmpty) {
        return;
      }
      emit(
        state.copyWith(
          openingStatus: CubitStatus.success,
          openUrl: fileUrl,
          openingMaterialId: material.materialId,
          clearError: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        openingStatus: CubitStatus.loading,
        openingMaterialId: material.materialId,
        clearOpenUrl: true,
        clearError: true,
      ),
    );

    final result = await _getMaterialStreamUseCase.call(
      params: material.materialId,
    );
    switch (result) {
      case Success(data: final stream):
        emit(
        state.copyWith(
          openingStatus: CubitStatus.success,
          openUrl: stream.streamUrl,
        ),
      );
      case Failure(apiErrorModel: final error):
        emit(
        state.copyWith(
          openingStatus: CubitStatus.error,
          apiErrorModel: error,
          clearOpenUrl: true,
        ),
      );
    }
  }

  void clearOpeningResult() {
    emit(
      state.copyWith(
        openingStatus: CubitStatus.initial,
        clearOpeningMaterialId: true,
        clearOpenUrl: true,
      ),
    );
  }
}
