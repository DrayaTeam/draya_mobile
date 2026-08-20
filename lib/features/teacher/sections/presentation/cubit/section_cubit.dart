import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/sections/data/models/create_section_request_model.dart";
import "package:draya_mobile/features/teacher/sections/domain/usecases/create_section_use_case.dart";
import "package:draya_mobile/features/teacher/sections/domain/usecases/delete_section_use_case.dart";
import "package:draya_mobile/features/teacher/sections/domain/usecases/get_sections_use_case.dart";
import "package:draya_mobile/features/teacher/sections/presentation/cubit/section_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class SectionCubit extends Cubit<SectionState> {
  final GetSectionsUseCase _getSectionsUseCase;
  final CreateSectionUseCase _createSectionUseCase;
  final DeleteSectionUseCase _deleteSectionUseCase;

  SectionCubit(
    this._getSectionsUseCase,
    this._createSectionUseCase,
    this._deleteSectionUseCase,
  ) : super(const SectionState());

  Future<void> getSections({required String classroomId}) async {
    emit(state.copyWith(getSectionsStatus: CubitStatus.loading));

    final result = await _getSectionsUseCase.call(params: classroomId);

    result.when(
      success: (listOfSectionModels) {
        emit(
          state.copyWith(
            getSectionsStatus: CubitStatus.success,
            createSectionStatus: CubitStatus.initial,
            deleteSectionStatus: CubitStatus.initial,
            sections: listOfSectionModels,
          ),
        );
      },
      failure: (apiErrorModel) {
        emit(
          state.copyWith(
            getSectionsStatus: CubitStatus.error,
            apiErrorModel: apiErrorModel,
          ),
        );
      },
    );
  }

  Future<void> createSection({
    required String classroomId,
    required CreateSectionRequestModel createSectionRequestModel,
  }) async {
    emit(state.copyWith(createSectionStatus: CubitStatus.loading));

    final result = await _createSectionUseCase.call(
      params: CreateSectionUseCaseParams(
        classroomId: classroomId,
        createSectionRequestModel: createSectionRequestModel,
      ),
    );

    result.when(
      success: (nothing) {
        emit(
          state.copyWith(
            createSectionStatus: CubitStatus.success,
            getSectionsStatus: CubitStatus.initial,
            deleteSectionStatus: CubitStatus.initial,
          ),
        );
      },
      failure: (apiErrorModel) {
        emit(
          state.copyWith(
            createSectionStatus: CubitStatus.error,
            apiErrorModel: apiErrorModel,
          ),
        );
      },
    );
  }

  Future<void> deleteSection({required String sectionId}) async {
    emit(state.copyWith(deleteSectionStatus: CubitStatus.loading));

    final result = await _deleteSectionUseCase.call(params: sectionId);

    result.when(
      success: (nothing) {
        emit(
          state.copyWith(
            deleteSectionStatus: CubitStatus.success,
            createSectionStatus: CubitStatus.initial,
            getSectionsStatus: CubitStatus.initial,
          ),
        );
      },
      failure: (apiErrorModel) {
        emit(
          state.copyWith(
            deleteSectionStatus: CubitStatus.error,
            apiErrorModel: apiErrorModel,
          ),
        );
      },
    );
  }
}
