import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/sections/domain/usecases/get_sections_use_case.dart";
import "package:draya_mobile/features/teacher/students_grades/presentation/cubit/grades_exams_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class GradesExamsCubit extends Cubit<GradesExamsState> {
  final GetSectionsUseCase _getSectionsUseCase;

  GradesExamsCubit(this._getSectionsUseCase)
      : super(const GradesExamsState());

  Future<void> getExams(String classroomId) async {
    emit(state.copyWith(status: CubitStatus.loading, apiErrorModel: null));

    final result = await _getSectionsUseCase(params: classroomId);

    result.when(
      success: (sections) {
        final exams = <ExamGradesItem>[];
        for (final section in sections) {
          for (final exam in section.exams) {
            exams.add(
              ExamGradesItem(exam: exam, sectionTitle: section.title),
            );
          }
        }
        emit(
          state.copyWith(
            status: CubitStatus.success,
            exams: exams,
            apiErrorModel: null,
          ),
        );
      },
      failure: (error) => emit(
        state.copyWith(status: CubitStatus.error, apiErrorModel: error),
      ),
    );
  }
}
