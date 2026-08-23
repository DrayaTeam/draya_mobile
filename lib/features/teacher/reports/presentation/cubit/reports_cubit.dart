import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/reports/domain/usecases/get_performance_report_use_case.dart";
import "package:draya_mobile/features/teacher/reports/presentation/cubit/reports_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class ReportsCubit extends Cubit<ReportsState> {
  final GetPerformanceReportUseCase _getPerformanceReportUseCase;

  ReportsCubit(
    this._getPerformanceReportUseCase,
  ) : super(const ReportsState());

  Future<void> getPerformanceReport({
    required String studentId,
  }) async {
    if (state.reportsByStudentId.containsKey(studentId)) {
      return;
    }

    emit(
      state.copyWith(
        loadingStudentIds: {
          ...state.loadingStudentIds,
          studentId,
        },
        errorsByStudentId: {
          ...state.errorsByStudentId,
        }..remove(studentId),
      ),
    );

    final result = await _getPerformanceReportUseCase(
      params: studentId,
    );

    result.when(
      success: (performanceReportModel) {
        final loadingIds = {
          ...state.loadingStudentIds,
        }..remove(studentId);

        emit(
          state.copyWith(
            reportsByStudentId: {
              ...state.reportsByStudentId,
              studentId: performanceReportModel,
            },
            loadingStudentIds: loadingIds,
          ),
        );
      },
      failure: (apiErrorModel) {
        final loadingIds = {
          ...state.loadingStudentIds,
        }..remove(studentId);

        emit(
          state.copyWith(
            loadingStudentIds: loadingIds,
            errorsByStudentId: {
              ...state.errorsByStudentId,
              studentId: apiErrorModel,
            },
          ),
        );
      },
    );
  }

  void clearReports() {
    emit(const ReportsState());
  }
}
