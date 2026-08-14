import 'package:draya_mobile/core/enums/cubit_status.dart';
import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/teacher/classrooms/domain/usecases/get_grade_levels_use_case.dart';
import 'package:draya_mobile/features/teacher/classrooms/presentation/cubit/grade_levels_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GradeLevelsCubit extends Cubit<GradeLevelsState> {
  final GetGradeLevelsUseCase _getGradeLevelsUseCase;
  GradeLevelsCubit(this._getGradeLevelsUseCase)
    : super(const GradeLevelsState());

  Future<void> getGradeLevels() async {
    emit(state.copyWith(status: CubitStatus.loading));

    final result = await _getGradeLevelsUseCase.call();

    result.when(
      success: (listOfGradeLevels) {
        emit(
          state.copyWith(
            status: CubitStatus.success,
            gradeLevels: listOfGradeLevels,
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
