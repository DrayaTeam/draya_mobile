import "dart:async";

import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/helpers/app_token_helper.dart";
import "package:draya_mobile/core/networking/api_constants.dart";
import "package:draya_mobile/core/networking/api_error_handler.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/core/signalr/signalr_events.dart";
import "package:draya_mobile/core/signalr/signalr_service.dart";
import "package:draya_mobile/features/auth/domain/usecases/get_current_user_profile_use_case.dart";
import "package:draya_mobile/features/student/student_weak_topics/domain/usecases/generate_practice_exam_use_case.dart";
import "package:draya_mobile/features/student/student_weak_topics/domain/usecases/get_ai_revision_use_case.dart";
import "package:draya_mobile/features/student/student_weak_topics/domain/usecases/get_latest_performance_report_use_case.dart";
import "package:draya_mobile/features/student/student_weak_topics/domain/usecases/get_practice_exam_generation_status_use_case.dart";
import "package:draya_mobile/features/student/student_weak_topics/presentation/cubit/student_weak_topics_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class StudentWeakTopicsCubit extends Cubit<StudentWeakTopicsState> {
  final GetLatestPerformanceReportUseCase _getLatestPerformanceReportUseCase;
  final GetAiRevisionUseCase _getAiRevisionUseCase;
  final GeneratePracticeExamUseCase _generatePracticeExamUseCase;
  final GetCurrentUserProfileUseCase _getCurrentUserProfileUseCase;
  final SignalRService _signalRService;
  final GetPracticeExamGenerationStatusUseCase _getGenerationStatusUseCase;

  Timer? _examPollTimer;
  int _examPollCount = 0;

  StudentWeakTopicsCubit(
    this._getLatestPerformanceReportUseCase,
    this._getAiRevisionUseCase,
    this._generatePracticeExamUseCase,
    this._getCurrentUserProfileUseCase,
    this._signalRService,
    this._getGenerationStatusUseCase,
  ) : super(const StudentWeakTopicsState()) {
    _initSignalRListener();
  }

  void _initSignalRListener() {
    _signalRService.onReceiveGenerationProgress(_handleSignalRGenerationProgress);
  }

  void _handleSignalRGenerationProgress(ExamGenerationProgressEvent event) {
    if (state.examGenerationStatus == PracticeExamGenerationStatus.completed ||
        state.examGenerationStatus == PracticeExamGenerationStatus.failed) {
      return;
    }
    if (state.examGenerationId != null &&
        state.examGenerationId == event.generationId) {
      if (event.isCompleted) {
        _examPollTimer?.cancel();
        emit(
          state.copyWith(
            examGenerationStatus: PracticeExamGenerationStatus.completed,
            generatedExamId: event.examId,
          ),
        );
      } else if (event.isFailed) {
        _examPollTimer?.cancel();
        emit(
          state.copyWith(
            examGenerationStatus: PracticeExamGenerationStatus.failed,
            examGenerationError:
                event.errorMessage ?? "فشل توليد الامتحان التدريبي",
          ),
        );
      } else if (event.isGenerating) {
        emit(
          state.copyWith(
            examGenerationStatus: PracticeExamGenerationStatus.generating,
          ),
        );
      }
    }
  }

  Future<String?> _resolveStudentId() async {
    if (state.studentId != null && state.studentId!.isNotEmpty) {
      return state.studentId;
    }

    final profileResult = await _getCurrentUserProfileUseCase();
    return profileResult.when(
      success: (userProfile) {
        final id = userProfile.userId;
        if (id != null && id.isNotEmpty) {
          emit(state.copyWith(studentId: id));
          return id;
        }
        return null;
      },
      failure: (_) => null,
    );
  }

  Future<void> loadPerformanceReport({String? studentId}) async {
    emit(state.copyWith(status: CubitStatus.loading));

    String? id = studentId ?? state.studentId;
    if (id == null || id.isEmpty) {
      id = await _resolveStudentId();
    }

    if (id == null || id.isEmpty) {
      emit(
        state.copyWith(
          status: CubitStatus.error,
          apiErrorModel: ErrorHandler.handle("لم يتم العثور على معرّف الطالب"),
        ),
      );
      return;
    }

    final result = await _getLatestPerformanceReportUseCase(params: id);

    result.when(
      success: (report) {
        emit(
          state.copyWith(
            status: CubitStatus.success,
            report: report,
            studentId: id,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            status: CubitStatus.error,
            apiErrorModel: error,
          ),
        );
      },
    );
  }

  Future<void> fetchAiRevision(String topicName) async {
    emit(
      state.copyWith(
        isRevisionLoading: true,
        selectedTopicName: topicName,
        revisionError: null,
      ),
    );

    String? id = state.studentId;
    if (id == null || id.isEmpty) {
      id = await _resolveStudentId();
    }

    if (id == null || id.isEmpty) {
      emit(
        state.copyWith(
          isRevisionLoading: false,
          revisionError: ErrorHandler.handle("معرف الطالب غير متاح"),
        ),
      );
      return;
    }

    final result = await _getAiRevisionUseCase(
      params: GetAiRevisionParams(
        studentId: id,
        topicName: topicName,
      ),
    );

    result.when(
      success: (revision) {
        emit(
          state.copyWith(
            isRevisionLoading: false,
            aiRevision: revision,
            selectedTopicName: topicName,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            isRevisionLoading: false,
            revisionError: error,
          ),
        );
      },
    );
  }

  Future<void> startPracticeExamGeneration({String? topicName}) async {
    final topic = topicName ?? state.selectedTopicName;
    if (topic == null || topic.isEmpty) return;

    emit(
      state.copyWith(
        examGenerationStatus: PracticeExamGenerationStatus.requesting,
        examGenerationError: null,
        generatedExamId: null,
      ),
    );

    String? id = state.studentId;
    if (id == null || id.isEmpty) {
      id = await _resolveStudentId();
    }

    if (id == null || id.isEmpty) {
      emit(
        state.copyWith(
          examGenerationStatus: PracticeExamGenerationStatus.failed,
          examGenerationError: "معرف الطالب غير متاح",
        ),
      );
      return;
    }

    // Ensure the hub is connected & listening BEFORE requesting generation,
    // otherwise early progress events are missed.
    await _connectSignalRHub();

    final result = await _generatePracticeExamUseCase(
      params: GeneratePracticeExamParams(
        studentId: id,
        topicName: topic,
      ),
    );

    result.when(
      success: (generation) {
        emit(
          state.copyWith(
            examGenerationStatus: PracticeExamGenerationStatus.generating,
            examGenerationId: generation.generationId,
            practiceExamResponse: generation,
          ),
        );

        // Fallback polling in case SignalR drops or hub doesn't push
        _startPracticeExamPolling(generation.generationId);
      },
      failure: (error) {
        emit(
          state.copyWith(
            examGenerationStatus: PracticeExamGenerationStatus.failed,
            examGenerationError:
                error.error?.message ?? "تعذر بدء إنشاء الامتحان التدريبي",
          ),
        );
      },
    );
  }

  Future<void> _connectSignalRHub() async {
    try {
      final token = await AppTokenHelper.getAccessToken();
      if (token != null && token.isNotEmpty) {
        const hubUrl = "${ApiConstants.baseUrlWithoutV1}hubs/exam-generation";
        await _signalRService.connect(hubUrl: hubUrl, token: token);
      }
    } catch (_) {
      // Continue, fallback polling will take over
    }
  }

  void _startPracticeExamPolling(String generationId) {
    _examPollTimer?.cancel();
    _examPollCount = 0;

    _examPollTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (state.examGenerationStatus != PracticeExamGenerationStatus.generating) {
        timer.cancel();
        return;
      }

      _examPollCount++;
      if (_examPollCount > 60) {
        timer.cancel();
        emit(
          state.copyWith(
            examGenerationStatus: PracticeExamGenerationStatus.failed,
            examGenerationError:
                "استغرقت عملية التوليد وقتاً أطول من المتوقع. يرجى إعادة المحاولة.",
          ),
        );
        return;
      }

      final result = await _getGenerationStatusUseCase(params: generationId);
      if (!timer.isActive) return;

      result.when(
        success: (statusEntity) {
          if (!statusEntity.isFinished) return;
          timer.cancel();

          if (statusEntity.isCompleted) {
            emit(
              state.copyWith(
                examGenerationStatus: PracticeExamGenerationStatus.completed,
                generatedExamId:
                    statusEntity.examId ?? state.generatedExamId,
              ),
            );
          } else {
            emit(
              state.copyWith(
                examGenerationStatus: PracticeExamGenerationStatus.failed,
                examGenerationError: statusEntity.errorMessage ??
                    "فشل توليد الامتحان التدريبي",
              ),
            );
          }
        },
        failure: (_) {
          // Transient network error — keep polling until the deadline.
        },
      );
    });
  }

  void resetExamGeneration() {
    _examPollTimer?.cancel();
    emit(
      state.copyWith(
        examGenerationStatus: PracticeExamGenerationStatus.idle,
        examGenerationId: null,
        generatedExamId: null,
        examGenerationError: null,
      ),
    );
  }

  @override
  Future<void> close() {
    _examPollTimer?.cancel();
    _signalRService.removeListener(
      "ReceiveGenerationProgress",
      _handleSignalRGenerationProgress,
    );
    return super.close();
  }
}
