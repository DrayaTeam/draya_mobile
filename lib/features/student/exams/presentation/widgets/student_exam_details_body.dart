import 'dart:async';

import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/core/theme/app_text_styles.dart';
import 'package:draya_mobile/core/widgets/app_elevated_button.dart';
import 'package:draya_mobile/core/widgets/app_outlined_button.dart';
import 'package:draya_mobile/features/student/exams/presentation/models/exam_item.dart';
import 'package:draya_mobile/features/student/exams/presentation/widgets/exam_question_card.dart';
import 'package:flutter/material.dart';

class StudentExamDetailsBody extends StatefulWidget {
  final ExamItem exam;

  const StudentExamDetailsBody({super.key, required this.exam});

  @override
  State<StudentExamDetailsBody> createState() => _StudentExamDetailsBodyState();
}

class _StudentExamDetailsBodyState extends State<StudentExamDetailsBody> {
  final PageController _pageController = PageController();
  late final List<_ExamQuestion> _questions;
  late final List<int?> _selectedAnswers;
  late Duration _remaining;
  Timer? _timer;
  int _currentQuestion = 0;

  @override
  void initState() {
    super.initState();
    _questions = _buildMockQuestions();
    _selectedAnswers = List<int?>.filled(_questions.length, null);
    _remaining =
        _parseDuration(widget.exam.duration) ?? const Duration(minutes: 5);
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;

      setState(() {
        if (_remaining.inSeconds > 0) {
          _remaining = _remaining - const Duration(seconds: 1);
        } else {
          _timer?.cancel();
          Navigator.of(context).pop();
        }
      });
    });
  }

  Duration? _parseDuration(String value) {
    final regex = RegExp(r"(\d+)\s*دقيقة");
    final match = regex.firstMatch(value);
    if (match == null) return null;
    final minutes = int.tryParse(match.group(1) ?? '0');
    return minutes != null ? Duration(minutes: minutes) : null;
  }

  void _goToQuestion(int index) {
    if (index < 0 || index >= _questions.length) return;
    setState(() {
      _currentQuestion = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToPrevious() {
    if (_currentQuestion == 0) return;
    _goToQuestion(_currentQuestion - 1);
  }

  void _goToNext() {
    if (_currentQuestion >= _questions.length - 1) {
      _finishExam();
      return;
    }
    _goToQuestion(_currentQuestion + 1);
  }

  void _finishExam() {
    _timer?.cancel();
    Navigator.of(context).pop();
  }

  void _selectChoice(int index) {
    setState(() {
      _selectedAnswers[_currentQuestion] = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.s20,
          vertical: AppSizes.s16,
        ),
        child: Column(
          children: [
            _buildExamHeader(context),
            const SizedBox(height: AppSizes.s20),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: _buildQuestionCard(),
              ),
            ),
            const SizedBox(height: AppSizes.s16),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildExamHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.s20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(17, 24, 39, 0.05),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildIconBadge(),
              const SizedBox(width: AppSizes.s16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.exam.title,
                      textAlign: TextAlign.right,
                      style: AppTextStyles.h4.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: AppSizes.s4),
                    Text(
                      'المعلم: ${widget.exam.teacher}',
                      textAlign: TextAlign.right,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.s20),
          _buildTimerSection(),
        ],
      ),
    );
  }

  Widget _buildIconBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.s16,
        vertical: AppSizes.s8,
      ),
      decoration: BoxDecoration(
        color: widget.exam.subjectAccentColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Icon(
        Icons.security_outlined,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildTimerSection() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.s12),
      decoration: BoxDecoration(
        color: AppColors.primary100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'الوقت المتبقي',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.primary900,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: AppSizes.s4),
              Text(
                _formatDuration(_remaining),
                style: AppTextStyles.h4.copyWith(
                  color: AppColors.primary900,
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(AppSizes.s12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.timer_outlined,
              color: AppColors.primary700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.s20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(17, 24, 39, 0.05),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'السؤال ${_currentQuestion + 1} من ${_questions.length}',
                style: AppTextStyles.label.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.s16,
                  vertical: AppSizes.s8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  widget.exam.subject,
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.primary900,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.s20),
          SizedBox(
            height: 400,
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentQuestion = index;
                });
              },
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                final question = _questions[index];
                return ExamQuestionCard(
                  question: question.title,
                  choices: question.choices,
                  selectedChoiceIndex: _selectedAnswers[index],
                  onChoiceSelected: (choiceIndex) {
                    if (_currentQuestion != index) return;
                    _selectChoice(choiceIndex);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    final isLast = _currentQuestion >= _questions.length - 1;
    return Row(
      children: [
        Expanded(
          child: AppOutlinedButton(
            onPressed: _currentQuestion > 0 ? _goToPrevious : null,
            label: 'السؤال السابق',
            borderColor: AppColors.primary700,
            foregroundColor: AppColors.primary700,
            textStyle: AppTextStyles.button.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: AppSizes.s16),
        Expanded(
          child: AppElevatedButton(
            onPressed: _goToNext,
            label: isLast ? 'إنهاء الامتحان' : 'السؤال التالي',
            backgroundColor: AppColors.primary700,
            textStyle: AppTextStyles.button.copyWith(
              color: AppColors.surface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  List<_ExamQuestion> _buildMockQuestions() {
    return const [
      _ExamQuestion(
        title:
            'إذا كان ن ل ر = 120 ، فما هي قيم ن ، ر الممكنة لحل هذه المعادلة التباديلية؟',
        choices: [
          'ن = 5 ، ر = 3',
          'ن = 4 ، ر = 2',
          'ن = 6 ، ر = 2',
          'ن = 5 ، ر = 4',
        ],
      ),
      _ExamQuestion(
        title: 'أي من العبارات التالية تعبر عن التباديل بدون تكرار؟',
        choices: [
          'P(n, r) = n! / (n - r)!',
          'C(n, r) = n! / (r! (n - r)!)',
          'n^r',
          'r! * C(n, r)',
        ],
      ),
      _ExamQuestion(
        title: 'كم عدد التوافيق الممكنة لاختيار 3 عناصر من 7 عناصر؟',
        choices: [
          '35',
          '42',
          '210',
          '120',
        ],
      ),
    ];
  }
}

class _ExamQuestion {
  final String title;
  final List<String> choices;

  const _ExamQuestion({required this.title, required this.choices});
}
