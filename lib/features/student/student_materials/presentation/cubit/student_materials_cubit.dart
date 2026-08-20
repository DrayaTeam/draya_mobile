import 'package:draya_mobile/core/enums/cubit_status.dart';
import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/student/student_materials/domain/entity/classroom_section.dart';
import 'package:draya_mobile/features/student/student_materials/domain/entity/student_material.dart';
import 'package:draya_mobile/features/student/student_materials/domain/usecases/get_classroom_sections_use_case.dart';
import 'package:draya_mobile/features/student/student_materials/domain/usecases/get_enrolled_materials_use_case.dart';
import 'package:draya_mobile/features/student/student_materials/domain/usecases/get_material_stream_use_case.dart';
import 'package:draya_mobile/features/student/student_materials/presentation/cubit/student_materials_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentMaterialsCubit extends Cubit<StudentMaterialsState> {
  final GetEnrolledMaterialsUseCase _getEnrolledMaterialsUseCase;
  final GetMaterialStreamUseCase _getMaterialStreamUseCase;
  final GetClassroomSectionsUseCase _getClassroomSectionsUseCase;

  StudentMaterialsCubit(
    this._getEnrolledMaterialsUseCase,
    this._getMaterialStreamUseCase,
    this._getClassroomSectionsUseCase,
  ) : super(const StudentMaterialsState());

  Future<void> getClassroomSections(String classroomId) async {
    emit(
      state.copyWith(sectionsStatus: CubitStatus.loading, clearError: true),
    );

    final result = await _getClassroomSectionsUseCase.call(params: classroomId);
    switch (result) {
      case Success(data: final sections):
        emit(
          state.copyWith(
            sectionsStatus: CubitStatus.success,
            sections: sections,
          ),
        );
      case Failure(apiErrorModel: final error):
        emit(
          state.copyWith(
            sectionsStatus: CubitStatus.error,
            apiErrorModel: error,
          ),
        );
    }
  }

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

  Future<void> openDocument(SectionDocument document) async {
    final fileUrl = document.fileUrl;
    if (fileUrl == null || fileUrl.isEmpty) {
      return;
    }
    emit(
      state.copyWith(
        openingStatus: CubitStatus.success,
        openUrl: fileUrl,
        openingMaterialId: document.id,
        clearError: true,
      ),
    );
  }

  Future<void> openVideo(SectionVideo video) async {
    if (video.hasVideoUrl) {
      emit(
        state.copyWith(
          openingStatus: CubitStatus.success,
          openUrl: video.videoUrl,
          openingMaterialId: video.id,
          clearError: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        openingStatus: CubitStatus.loading,
        openingMaterialId: video.id,
        clearOpenUrl: true,
        clearError: true,
      ),
    );

    final result = await _getMaterialStreamUseCase.call(
      params: video.id,
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

  Future<String?> resolveMaterialUrl(StudentMaterial material) async {
    if (!material.currentVersion.isReady) return null;

    if (!material.isVideo) {
      final fileUrl = material.currentVersion.fileUrl;
      return fileUrl == null || fileUrl.isEmpty ? null : fileUrl;
    }

    final result = await _getMaterialStreamUseCase.call(
      params: material.materialId,
    );
    return switch (result) {
      Success(data: final stream) => stream.streamUrl,
      Failure() => null,
      _ => null,
    };
  }

  Future<String?> resolveSectionVideoUrl(SectionVideo video) async {
    if (video.hasVideoUrl) {
      return video.videoUrl;
    }
    final result = await _getMaterialStreamUseCase.call(
      params: video.id,
    );
    return switch (result) {
      Success(data: final stream) => stream.streamUrl,
      Failure() => null,
      _ => null,
    };
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
