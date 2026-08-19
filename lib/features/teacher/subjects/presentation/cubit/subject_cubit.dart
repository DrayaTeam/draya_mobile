import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/subjects/data/models/add_subject_request_model.dart";
import "package:draya_mobile/features/teacher/subjects/domain/usecases/add_subject_use_case.dart";
import "package:draya_mobile/features/teacher/subjects/domain/usecases/get_subjects_use_case.dart";
import "package:draya_mobile/features/teacher/subjects/presentation/cubit/subject_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class SubjectCubit extends Cubit<SubjectState> {
  final AddSubjectUseCase _addSubjectUseCase;
  final GetSubjectsUseCase _getSubjectsUseCase;
  SubjectCubit(this._addSubjectUseCase, this._getSubjectsUseCase)
    : super(const SubjectState());

  Future<void> addSubject({
    required AddSubjectRequestModel addSubjectRequestModel,
  }) async {
    emit(state.copyWith(status: CubitStatus.loading));

    final result = await _addSubjectUseCase.call(
      params: addSubjectRequestModel,
    );

    result.when(
      success: (subjectModel) {
        emit(
          state.copyWith(
            status: CubitStatus.success,
            subjects: [...state.subjects, subjectModel],
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

  Future<void> getSubjects() async {
    emit(state.copyWith(status: CubitStatus.loading));

    final result = await _getSubjectsUseCase.call();

    result.when(
      success: (listOfSubjectModels) {
        emit(
          state.copyWith(
            status: CubitStatus.success,
            subjects: listOfSubjectModels,
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
