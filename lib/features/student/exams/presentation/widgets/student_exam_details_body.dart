import "dart:async";

import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/core/widgets/app_elevated_button.dart";
import "package:draya_mobile/core/widgets/app_outlined_button.dart";
import "package:draya_mobile/features/student/exams/domain/entity/student_exam.dart";
import "package:draya_mobile/features/student/exams/presentation/cubit/student_exam_cubit.dart";
import "package:draya_mobile/features/student/exams/presentation/cubit/student_exam_state.dart";
import "package:draya_mobile/features/student/exams/presentation/pages/exam_grading_screen.dart";
import "package:draya_mobile/features/student/exams/presentation/pages/exam_results_screen.dart";
import "package:draya_mobile/features/student/exams/presentation/widgets/exam_question_card.dart";
import "package:draya_mobile/features/student/exams/presentation/widgets/exam_question_navigator.dart";
import "package:draya_mobile/features/student/exams/presentation/widgets/exam_submit_dialog.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";

class StudentExamDetailsBody extends StatefulWidget {
  final String examId;
  final String? classroomName;

  const StudentExamDetailsBody({
    super.key,
    required this.examId,
    this.classroomName,
  });

  @override
  State<StudentExamDetailsBody> createState() => _StudentExamDetailsBodyState();
}

class _StudentExamDetailsBodyState extends State<StudentExamDetailsBody>
    with WidgetsBindingObserver {
  final PageController _pageController = PageController();
  int _currentQuestionIndex = 0;
  Timer? _examCountdownTimer;
  Duration _remainingDuration = const Duration(minutes: 30);
  bool _isExamStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<StudentExamCubit>().loadExamDetails(widget.examId);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_isExamStarted &&
        (state == AppLifecycleState.paused ||
            state == AppLifecycleState.inactive)) {
      // Anti-cheat: Student navigated away or switched app
      final cubit = context.read<StudentExamCubit>();
      cubit.recordTabAway();

      if (cubit.state.tabAwayCount >= 3) {
        // Auto-submit after 3 violations
        cubit.submitExam();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _examCountdownTimer?.cancel();
    _pageController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _startTimer(int durationMinutes) {
    _remainingDuration = Duration(minutes: durationMinutes);

    _examCountdownTimer?.cancel();
    _examCountdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_remainingDuration.inSeconds > 0) {
          _remainingDuration =
              _remainingDuration - const Duration(seconds: 1);
        } else {
          _examCountdownTimer?.cancel();
          // Auto submit on time expiry
          context.read<StudentExamCubit>().submitExam();
        }
      });
    });
  }

  bool _isExamWithinDateWindow(StudentExam exam) {
    final now = DateTime.now().toUtc();
    if (exam.startDate != null && now.isBefore(exam.startDate!.toUtc())) {
      return false;
    }
    if (exam.endDate != null && now.isAfter(exam.endDate!.toUtc())) {
      return false;
    }
    return true;
  }

  void _handleStartAttempt(StudentExam exam) async {
    if (!_isExamWithinDateWindow(exam)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            exam.startDate != null &&
                    DateTime.now().toUtc().isBefore(exam.startDate!.toUtc())
                ? "لم يبدأ موعد الامتحان بعد، لا يمكنك البدء الآن."
                : "انتهت فترة الامتحان، لا يمكنك البدء الآن.",
            style: AppTextStyles.body.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }
    if (exam.allowedAttempts != null && exam.allowedAttempts! <= 0) {
      return;
    }
    final success =
        await context.read<StudentExamCubit>().startAttempt(exam.id);
    if (success && mounted) {
      setState(() {
        _isExamStarted = true;
      });
      final minutes = (exam.durationMinutes != null && exam.durationMinutes! > 0)
          ? exam.durationMinutes!
          : (exam.questions.length * 2).clamp(10, 120);
      _startTimer(minutes);
      // Enter immersive sticky mode during exam
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
  }

  void _goToQuestion(int index) {
    setState(() {
      _currentQuestionIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _showSubmitConfirmationDialog() {
    final state = context.read<StudentExamCubit>().state;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ExamSubmitDialog(
        totalQuestions: state.totalQuestionsCount,
        answeredQuestions: state.answeredQuestionsCount,
        onConfirm: () {
          _examCountdownTimer?.cancel();
          context.read<StudentExamCubit>().submitExam();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentExamCubit, StudentExamState>(
      listener: (context, state) {
        if (state.submissionStatus == CubitStatus.success) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        }
        if (state.examDetailStatus == CubitStatus.error &&
            state.apiErrorModel?.error?.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.apiErrorModel!.error!.message!,
                style: AppTextStyles.body.copyWith(color: Colors.white),
              ),
              backgroundColor: AppColors.error,
            ),
          );
        }
        if (state.attemptStatus == CubitStatus.error &&
            state.apiErrorModel?.error?.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.apiErrorModel!.error!.message!,
                style: AppTextStyles.body.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
        if (state.submissionStatus == CubitStatus.error &&
            state.apiErrorModel?.error?.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.apiErrorModel!.error!.message!,
                style: AppTextStyles.body.copyWith(color: Colors.white),
              ),
              backgroundColor: AppColors.error,
            ),
          );
        }
        if (state.resultsStatus == CubitStatus.error &&
            state.apiErrorModel?.error?.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.apiErrorModel!.error!.message!,
                style: AppTextStyles.body.copyWith(color: Colors.white),
              ),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        // 1. Loading exam details
        if (state.examDetailStatus == CubitStatus.loading &&
            state.currentExam == null) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        // Error loading exam details
        if (state.examDetailStatus == CubitStatus.error &&
            state.currentExam == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.surface,
              elevation: 0,
              title: const Text("تفاصيل الامتحان"),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: AppColors.error,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.apiErrorModel?.error?.message ??
                          "تعذر تحميل بيانات الامتحان.",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context
                          .read<StudentExamCubit>()
                          .loadExamDetails(widget.examId),
                      child: const Text("إعادة المحاولة"),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final exam = state.currentExam;

        // 2. Results Screen
        if (state.resultsStatus == CubitStatus.success &&
            state.attemptResult != null) {
          return ExamResultsScreen(
            exam: exam,
            result: state.attemptResult!,
            onFinish: () => Navigator.of(context).pop(),
          );
        }

        // Error loading results after submission
        if (state.submissionStatus == CubitStatus.success &&
            state.resultsStatus == CubitStatus.error) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.surface,
              elevation: 0,
              centerTitle: true,
              title: const Text("نتيجة الامتحان"),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: AppColors.error,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.apiErrorModel?.error?.message ??
                          "تم تسليم الامتحان ولكن تعذر تحميل النتيجة. يرجى إعادة المحاولة.",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (state.attemptId != null) {
                          context
                              .read<StudentExamCubit>()
                              .loadResults(state.attemptId!);
                        }
                      },
                      child: const Text("إعادة تحميل النتيجة"),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // 3. Grading in Progress Screen
        if (state.gradingStatus == CubitStatus.loading ||
            (state.submissionStatus == CubitStatus.success &&
                state.resultsStatus != CubitStatus.success)) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: ExamGradingScreen(
              jobStatus: state.gradingJobStatus,
            ),
          );
        }

        // 4. Pre-exam Instructions / Start Screen
        if (state.attemptId == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.surface,
              elevation: 0,
              centerTitle: true,
              title: Text(
                "تفاصيل الامتحان",
                style: AppTextStyles.h4.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            body: exam != null
                ? _buildPreExamView(context, exam, state)
                : const SizedBox.shrink(),
          );
        }

        // 5. Active Exam Mode (with Anti-Cheating & PopScope lock)
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (didPop) return;
            _showSubmitConfirmationDialog();
          },
          child: Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.s16,
                  vertical: AppSizes.s12,
                ),
                child: Column(
                  children: [
                    // Exam Header with anti-cheat & timer
                    _buildActiveExamHeader(state, exam!),
                    const SizedBox(height: AppSizes.s12),

                    // Question numbers navigator
                    ExamQuestionNavigator(
                      totalQuestions: exam.questions.length,
                      currentIndex: _currentQuestionIndex,
                      isAnswered: (i) =>
                          state.isQuestionAnswered(exam.questions[i].id),
                      onQuestionTap: _goToQuestion,
                    ),
                    const SizedBox(height: AppSizes.s12),

                    // Anti-cheat warning banner if user switched apps
                    if (state.isAntiCheatWarningVisible)
                      _buildAntiCheatWarning(state.tabAwayCount),

                    // PageView with Question Cards
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        physics: const BouncingScrollPhysics(),
                        itemCount: exam.questions.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentQuestionIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final question = exam.questions[index];
                          final currentAnswer = state.answers[question.id];

                          return SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: ExamQuestionCard(
                              question: question,
                              questionIndex: index,
                              totalQuestions: exam.questions.length,
                              selectedOptionId:
                                  currentAnswer?.selectedOptionId,
                              answerText: currentAnswer?.answerText,
                              onOptionSelected: (optId) => context
                                  .read<StudentExamCubit>()
                                  .selectOption(question.id, optId),
                              onTextChanged: (text) => context
                                  .read<StudentExamCubit>()
                                  .setAnswerText(question.id, text),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppSizes.s12),

                    // Bottom Navigation Bar
                    _buildBottomNavigationButtons(
                      exam.questions.length,
                      state.submissionStatus == CubitStatus.loading,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPreExamView(
    BuildContext context,
    StudentExam exam,
    StudentExamState state,
  ) {
    final hasNoAttemptsLeft =
        exam.allowedAttempts != null && exam.allowedAttempts! <= 0;
    final isWithinWindow = _isExamWithinDateWindow(exam);
    final isUpcoming = exam.startDate != null &&
        DateTime.now().toUtc().isBefore(exam.startDate!.toUtc());
    final dateTimeFormat = DateFormat("d MMM yyyy - hh:mm a", "ar");

    return ListView(
      padding: const EdgeInsets.all(AppSizes.s20),
      children: [
        // Exam Info Card
        Container(
          padding: const EdgeInsets.all(AppSizes.s20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary800, AppColors.primary600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary700.withValues(alpha: 0.25),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.classroomName ?? "الفصل الدراسي",
                  style: AppTextStyles.label.copyWith(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                exam.title,
                style: AppTextStyles.h3.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildWhitePill(
                    icon: Icons.quiz_outlined,
                    text: "${exam.questions.length} أسئلة",
                  ),
                  _buildWhitePill(
                    icon: Icons.timer_outlined,
                    text:
                        "${(exam.durationMinutes != null && exam.durationMinutes! > 0) ? exam.durationMinutes : (exam.questions.length * 2).clamp(10, 120)} دقيقة",
                  ),
                  if (exam.allowedAttempts != null)
                    _buildWhitePill(
                      icon: Icons.replay_rounded,
                      text: exam.allowedAttempts! <= 0
                          ? "لا توجد محاولات متبقية"
                          : "${exam.allowedAttempts} محاولات مسموحة",
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.s20),

        if (hasNoAttemptsLeft) ...[
          Container(
            padding: const EdgeInsets.all(AppSizes.s16),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.error.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.block_rounded,
                  color: AppColors.error,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "لقد استنفدت جميع المحاولات المتاحة لهذا الامتحان، ولا يمكنك بدء محاولة جديدة.",
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.s20),
        ],

        if (!isWithinWindow) ...[
          Container(
            padding: const EdgeInsets.all(AppSizes.s16),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.error.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isUpcoming
                      ? Icons.schedule_rounded
                      : Icons.event_busy_rounded,
                  color: AppColors.error,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    isUpcoming
                        ? "لم يبدأ موعد الامتحان بعد (${dateTimeFormat.format(exam.startDate!.toLocal())})، لا يمكنك بدء المحاولة الآن."
                        : "انتهت فترة الامتحان (${dateTimeFormat.format(exam.endDate!.toLocal())})، لا يمكنك بدء محاولة جديدة.",
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.s20),
        ],

        // Rules and Anti-Cheat Instructions Card
        Container(
          padding: const EdgeInsets.all(AppSizes.s20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.security_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "تعليمات وإرشادات الاختبار:",
                    style: AppTextStyles.h5.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _buildInstructionRow(
                "1",
                "يتم تسجيل وقت بدء الاختبار تلقائياً بمجرد الضغط على زر البدء.",
              ),
              _buildInstructionRow(
                "2",
                "يمنع الخروج من التطبيق أو التبديل بين النوافذ أثناء سير الاختبار، حيث يتم رصد عدد مرات مغادرة الشاشة.",
              ),
              _buildInstructionRow(
                "3",
                "في حال مغادرة التطبيق 3 مرات سيتم إنهاء وتسليم الاختبار تلقائياً.",
              ),
              _buildInstructionRow(
                "4",
                "تأكد من استقرار اتصالك بالإنترنت قبل الضغط على بدء الاختبار.",
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.s24),

        // Start Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: (hasNoAttemptsLeft ||
                    !isWithinWindow ||
                    state.attemptStatus == CubitStatus.loading)
                ? null
                : () => _handleStartAttempt(exam),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.backgroundMuted,
              disabledForegroundColor: AppColors.textDisabled,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            icon: state.attemptStatus == CubitStatus.loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Icon(
                    hasNoAttemptsLeft || !isWithinWindow
                        ? Icons.lock_outline_rounded
                        : Icons.play_arrow_rounded,
                    size: 22,
                  ),
            label: Text(
              state.attemptStatus == CubitStatus.loading
                  ? "جاري بدء الاختبار..."
                  : hasNoAttemptsLeft
                      ? "لا توجد محاولات متبقية"
                      : !isWithinWindow
                          ? (isUpcoming
                              ? "لم يبدأ موعد الامتحان بعد"
                              : "انتهت فترة الامتحان")
                          : "بدء الاختبار الآن",
              style: AppTextStyles.button.copyWith(
                color: ((hasNoAttemptsLeft || !isWithinWindow) &&
                        state.attemptStatus != CubitStatus.loading)
                    ? AppColors.textDisabled
                    : Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveExamHeader(StudentExamState state, StudentExam exam) {
    final minutes = _remainingDuration.inMinutes.toString().padLeft(2, "0");
    final seconds =
        (_remainingDuration.inSeconds % 60).toString().padLeft(2, "0");
    final isUrgent = _remainingDuration.inMinutes < 5;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Timer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isUrgent
                  ? AppColors.error.withValues(alpha: 0.1)
                  : AppColors.primary50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isUrgent
                    ? AppColors.error.withValues(alpha: 0.3)
                    : AppColors.primary200,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 16,
                  color: isUrgent ? AppColors.error : AppColors.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  "$minutes:$seconds",
                  style: AppTextStyles.label.copyWith(
                    color: isUrgent ? AppColors.error : AppColors.primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // Question progress
          Text(
            "السؤال ${_currentQuestionIndex + 1} من ${exam.questions.length}",
            style: AppTextStyles.label.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),

          // Answered badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "${state.answeredQuestionsCount}/${exam.questions.length} مُجاب",
              style: AppTextStyles.label.copyWith(
                color: AppColors.foregroundMuted,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAntiCheatWarning(int tabAwayCount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.error,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "تنبيه: تم رصد مغادرة شاشة الاختبار ($tabAwayCount/3 مرات).",
              style: AppTextStyles.label.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w700,
                fontSize: 11.5,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 16, color: AppColors.error),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () =>
                context.read<StudentExamCubit>().dismissAntiCheatWarning(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationButtons(
    int totalQuestions,
    bool isSubmitting,
  ) {
    final isLast = _currentQuestionIndex >= totalQuestions - 1;

    return Row(
      children: [
        if (_currentQuestionIndex > 0) ...[
          Expanded(
            child: AppOutlinedButton(
              onPressed: () => _goToQuestion(_currentQuestionIndex - 1),
              label: "السؤال السابق",
              borderColor: AppColors.borderStrong,
              foregroundColor: AppColors.textPrimary,
              textStyle: AppTextStyles.button.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          flex: isLast ? 2 : 1,
          child: AppElevatedButton(
            onPressed: isSubmitting
                ? null
                : isLast
                    ? _showSubmitConfirmationDialog
                    : () => _goToQuestion(_currentQuestionIndex + 1),
            label: isLast ? "تسليم الامتحان" : "السؤال التالي",
            backgroundColor:
                isLast ? AppColors.success : AppColors.primary,
            icon: isLast
                ? const Icon(Icons.task_alt_rounded, size: 18, color: Colors.white)
                : const Icon(Icons.arrow_forward_rounded,
                    size: 18, color: Colors.white),
            textStyle: AppTextStyles.button.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWhitePill({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTextStyles.label.copyWith(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionRow(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: AppColors.primary50,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary200),
            ),
            child: Center(
              child: Text(
                number,
                style: AppTextStyles.label.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textPrimary,
                fontSize: 12.5,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
