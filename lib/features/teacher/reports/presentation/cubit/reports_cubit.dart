import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/reports/domain/usecases/approve_report_use_case.dart";
import "package:draya_mobile/features/teacher/reports/domain/usecases/get_performance_report_use_case.dart";
import "package:draya_mobile/features/teacher/reports/presentation/cubit/reports_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class ReportsCubit extends Cubit<ReportsState> {
  final GetPerformanceReportUseCase _getPerformanceReportUseCase;
  final ApproveReportUseCase _approveReportUseCase;

  ReportsCubit(
    this._getPerformanceReportUseCase,
    this._approveReportUseCase,
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
        approveReportStatus: CubitStatus.initial,
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
            approveReportStatus: CubitStatus.initial,
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
            approveReportStatus: CubitStatus.initial,
          ),
        );
      },
    );
  }

  void clearReports() {
    emit(const ReportsState());
  }

  Future<void> approveReport({required String reportId}) async {
    emit(
      state.copyWith(
        approveReportStatus: CubitStatus.loading,
      ),
    );

    final result = await _approveReportUseCase(params: reportId);

    result.when(
      success: (nothing) {
        emit(
          state.copyWith(
            approveReportStatus: CubitStatus.success,
          ),
        );
      },
      failure: (apiErrorModel) {
        emit(
          state.copyWith(
            approveReportStatus: CubitStatus.error,
            apiErrorModel: apiErrorModel,
          ),
        );
      },
    );
  }
}
