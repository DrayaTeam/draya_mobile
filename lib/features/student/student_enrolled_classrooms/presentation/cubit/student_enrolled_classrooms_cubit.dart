import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_error_model.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/student_enrolled_classrooms/data/models/student_enrolled_classroom_model.dart";
import "package:draya_mobile/features/student/student_enrolled_classrooms/domain/usecases/enroll_classroom_use_case.dart";
import "package:draya_mobile/features/student/student_enrolled_classrooms/domain/usecases/get_student_enrolled_classrooms_use_case.dart";
import "package:draya_mobile/features/student/student_enrolled_classrooms/presentation/cubit/student_enrolled_classrooms_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class StudentEnrolledClassroomsCubit
    extends Cubit<StudentEnrolledClassroomsState> {
  final GetStudentEnrolledClassroomsUseCase
  _getStudentEnrolledClassroomsUseCase;
  final EnrollClassroomUseCase _enrollClassroomUseCase;

  StudentEnrolledClassroomsCubit(
    this._getStudentEnrolledClassroomsUseCase,
    this._enrollClassroomUseCase,
  ) : super(const StudentEnrolledClassroomsState());

  Future<void> getStudentEnrolledClassrooms({
    int page = 1,
    int pageSize = 20,
    String? subjectId,
    String? gradeLevelId,
    String? classroomTypeId,
  }) async {
    emit(
      state.copyWith(
        status: CubitStatus.loading,
        apiErrorModel: null,
        page: page,
        pageSize: pageSize,
      ),
    );

    final result = await _getStudentEnrolledClassroomsUseCase.call(
      params: StudentEnrolledClassroomsParams(
        page: page,
        pageSize: pageSize,
        subjectId: subjectId,
        gradeLevelId: gradeLevelId,
        classroomTypeId: classroomTypeId,
      ),
    );

    result.when(
      success: (pagedResult) {
        emit(
          state.copyWith(
            status: CubitStatus.success,
            classrooms: pagedResult.items
                .map((item) => item.toEntity())
                .toList(),
            page: pagedResult.page,
            pageSize: pagedResult.pageSize,
            totalCount: pagedResult.totalCount,
            totalPages: pagedResult.totalPages,
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

  Future<void> enrollClassroom(String enrollmentCode) async {
    final trimmedCode = enrollmentCode.trim();
    if (trimmedCode.isEmpty) {
      emit(
        state.copyWith(
          status: CubitStatus.error,
          apiErrorModel: const ApiErrorModel(
            retry: false,
            error: ErrorModel(message: "يرجى إدخال رمز الفصل"),
          ),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: CubitStatus.loading,
        apiErrorModel: null,
      ),
    );

    final result = await _enrollClassroomUseCase.call(params: trimmedCode);

    await result.when(
      success: (_) async {
        emit(
          state.copyWith(
            status: CubitStatus.success,
            apiErrorModel: null,
          ),
        );
        await getStudentEnrolledClassrooms(
          page: state.page,
          pageSize: state.pageSize,
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
