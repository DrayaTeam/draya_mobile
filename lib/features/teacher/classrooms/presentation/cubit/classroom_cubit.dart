import 'package:draya_mobile/core/enums/cubit_status.dart';
import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/teacher/classrooms/data/models/create_classroom_request_model.dart';
import 'package:draya_mobile/features/teacher/classrooms/domain/usecases/create_classroom_use_case.dart';
import 'package:draya_mobile/features/teacher/classrooms/domain/usecases/get_classrooms_use_case.dart';
import 'package:draya_mobile/features/teacher/classrooms/presentation/cubit/classroom_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassroomCubit extends Cubit<ClassroomState> {
  final GetClassroomsUseCase _getClassroomsUseCase;
  final CreateClassroomUseCase _createClassroomUseCase;

  ClassroomCubit(this._getClassroomsUseCase, this._createClassroomUseCase)
    : super(const ClassroomState());

  Future<void> getClassrooms() async {
    emit(state.copyWith(status: CubitStatus.loading, apiErrorModel: null));
    final result = await _getClassroomsUseCase();
    result.when(
      success: (page) => emit(
        state.copyWith(status: CubitStatus.success, classrooms: page.items),
      ),
      failure: (error) => emit(
        state.copyWith(status: CubitStatus.error, apiErrorModel: error),
      ),
    );
  }

  Future<bool> createClassroom(CreateClassroomRequestModel request) async {
    emit(state.copyWith(status: CubitStatus.loading, apiErrorModel: null));
    final result = await _createClassroomUseCase(params: request);
    return result.when(
      success: (classroom) {
        emit(
          state.copyWith(
            status: CubitStatus.success,
            classrooms: [classroom, ...state.classrooms],
          ),
        );
        return true;
      },
      failure: (error) {
        emit(state.copyWith(status: CubitStatus.error, apiErrorModel: error));
        return false;
      },
    );
  }
}
