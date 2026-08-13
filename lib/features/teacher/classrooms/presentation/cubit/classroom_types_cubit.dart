import 'package:draya_mobile/core/enums/cubit_status.dart';
import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/teacher/classrooms/domain/usecases/get_classroom_types_use_case.dart';
import 'package:draya_mobile/features/teacher/classrooms/presentation/cubit/classroom_types_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassroomTypesCubit extends Cubit<ClassroomTypesState> {
  final GetClassroomTypesUseCase _getClassroomTypesUseCase;
  ClassroomTypesCubit(this._getClassroomTypesUseCase)
    : super(const ClassroomTypesState());

  Future<void> getClassroomTypes() async {
    emit(state.copyWith(status: CubitStatus.loading));

    final result = await _getClassroomTypesUseCase.call();

    result.when(
      success: (listOfClassroomTypes) {
        emit(
          state.copyWith(
            status: CubitStatus.success,
            classroomTypes: listOfClassroomTypes,
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
