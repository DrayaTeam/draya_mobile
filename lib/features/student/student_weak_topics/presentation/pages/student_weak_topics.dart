import "package:draya_mobile/core/di/dependency_injection.dart";
import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/helpers/app_dialog_helper.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/core/view_models/drawer_model.dart";
import "package:draya_mobile/core/widgets/app_drawer.dart";
import "package:draya_mobile/core/widgets/app_error_dialog.dart";
import "package:draya_mobile/core/widgets/custom_app_bar.dart";
import "package:draya_mobile/core/widgets/fade_in_up_animation.dart";
import "package:draya_mobile/features/student/student_weak_topics/domain/entity/student_performance_report.dart";
import "package:draya_mobile/features/student/student_weak_topics/presentation/cubit/student_weak_topics_cubit.dart";
import "package:draya_mobile/features/student/student_weak_topics/presentation/cubit/student_weak_topics_state.dart";
import "package:draya_mobile/features/student/student_weak_topics/presentation/widgets/ai_revision_modal_sheet.dart";
import "package:draya_mobile/features/student/student_weak_topics/presentation/widgets/student_weak_topics_header_card.dart";
import "package:draya_mobile/features/student/student_weak_topics/presentation/widgets/subject_proficiency_card.dart";
import "package:draya_mobile/features/student/student_weak_topics/presentation/widgets/weak_topic_card.dart";
import "package:draya_mobile/features/student/student_weak_topics/presentation/widgets/weak_topics_empty_state.dart";
import "package:draya_mobile/features/student/student_weak_topics/presentation/widgets/weak_topics_loading_shimmer.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class StudentWeakTopics extends StatelessWidget {
  final String? studentId;
  final String? initialTopic;

  const StudentWeakTopics({
    super.key,
    this.studentId,
    this.initialTopic,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StudentWeakTopicsCubit>(
      create: (_) => getIt<StudentWeakTopicsCubit>()
        ..loadPerformanceReport(studentId: studentId),
      child: _StudentWeakTopicsView(
        studentId: studentId,
        initialTopic: initialTopic,
      ),
    );
  }
}

class _StudentWeakTopicsView extends StatefulWidget {
  final String? studentId;
  final String? initialTopic;

  const _StudentWeakTopicsView({
    this.studentId,
    this.initialTopic,
  });

  @override
  State<_StudentWeakTopicsView> createState() => _StudentWeakTopicsViewState();
}

class _StudentWeakTopicsViewState extends State<_StudentWeakTopicsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _hasTriggeredInitialTopic = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _checkAndOpenInitialTopic(BuildContext context, StudentWeakTopicsState state) {
    if (_hasTriggeredInitialTopic || widget.initialTopic == null) return;
    if (state.status == CubitStatus.success && state.report != null) {
      _hasTriggeredInitialTopic = true;
      final topicName = widget.initialTopic!;
      context.read<StudentWeakTopicsCubit>().fetchAiRevision(topicName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: "نقاط الضعف والمراجعة الذكية"),
      drawer: AppDrawer(
        drawerItemsList: getStudentDrawerItemsList(),
      ),
      body: BlocConsumer<StudentWeakTopicsCubit, StudentWeakTopicsState>(
        listenWhen: (previous, current) {
          final isRevisionJustLoaded = previous.isRevisionLoading &&
              !current.isRevisionLoading &&
              current.aiRevision != null;
          final isError = previous.status != current.status &&
              current.status == CubitStatus.error &&
              current.apiErrorModel != null;
          final isReportJustLoaded = previous.status != current.status &&
              current.status == CubitStatus.success;
          return isRevisionJustLoaded || isError || isReportJustLoaded;
        },
        listener: (context, state) {
          _checkAndOpenInitialTopic(context, state);

          if (state.status == CubitStatus.error && state.apiErrorModel != null) {
            AppDialogHelper.display(
              context,
              AppErrorDialog(
                apiErrorModel: state.apiErrorModel!,
                onRetry: () {
                  context
                      .read<StudentWeakTopicsCubit>()
                      .loadPerformanceReport(studentId: widget.studentId);
                },
              ),
            );
          }

          // If AI Revision is fetched, open the modal sheet
          if (!state.isRevisionLoading &&
              state.aiRevision != null &&
              state.selectedTopicName != null) {
            AiRevisionModalSheet.show(
              context: context,
              topicName: state.selectedTopicName!,
              revision: state.aiRevision!,
              cubit: context.read<StudentWeakTopicsCubit>(),
            );
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            color: AppColors.ai700,
            backgroundColor: Colors.white,
            onRefresh: () async {
              await context
                  .read<StudentWeakTopicsCubit>()
                  .loadPerformanceReport(studentId: widget.studentId);
            },
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (state.status == CubitStatus.loading)
                      const WeakTopicsLoadingShimmer()
                    else if (state.report != null)
                      _buildReportContent(context, state.report!, state)
                    else
                      WeakTopicsEmptyState(
                        onRefresh: () {
                          context
                              .read<StudentWeakTopicsCubit>()
                              .loadPerformanceReport(
                                studentId: widget.studentId,
                              );
                        },
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReportContent(
    BuildContext context,
    StudentPerformanceReport report,
    StudentWeakTopicsState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // AI Diagnostic Header Card
        FadeInUp(
          delay: 50,
          child: StudentWeakTopicsHeaderCard(
            summaryText: report.summaryText,
            generatedAt: report.generatedAt,
            weakTopicsCount: report.weakTopics.length,
            subjectsCount: report.subjectProficiencies.length,
          ),
        ),
        const SizedBox(height: 20),

        // Modern Tab / Segment Selector
        FadeInUp(
          delay: 80,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: TabBar(
              controller: _tabController,
              onTap: (_) => setState(() {}),
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                  ),
                ],
              ),
              dividerColor: Colors.transparent,
              labelColor: AppColors.ai700,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.track_changes_rounded, size: 16),
                      const SizedBox(width: 6),
                      Text("نقاط الضعف (${report.weakTopics.length})"),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.analytics_outlined, size: 16),
                      const SizedBox(width: 6),
                      Text("كفاءة المواد (${report.subjectProficiencies.length})"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),

        // Tab Content
        if (_tabController.index == 0)
          _buildWeakTopicsTab(context, report.weakTopics, state)
        else
          _buildSubjectsTab(report.subjectProficiencies),

        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildWeakTopicsTab(
    BuildContext context,
    List<WeakTopic> weakTopics,
    StudentWeakTopicsState state,
  ) {
    if (weakTopics.isEmpty) {
      return const WeakTopicsEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "المفاهيم المقترحة للتحسين",
              style: AppTextStyles.h4.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
            Text(
              "${weakTopics.length} مفاهيم",
              style: AppTextStyles.label.copyWith(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: weakTopics.length,
          separatorBuilder: (_, _) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final topic = weakTopics[index];
            final isCurrentTopicLoading = state.isRevisionLoading &&
                state.selectedTopicName == topic.topicName;

            return FadeInUp(
              delay: (index % 5) * 60 + 100,
              child: WeakTopicCard(
                topic: topic,
                isLoadingRevision: isCurrentTopicLoading,
                onReview: () {
                  context
                      .read<StudentWeakTopicsCubit>()
                      .fetchAiRevision(topic.topicName);
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSubjectsTab(List<SubjectProficiency> subjects) {
    if (subjects.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(28),
        alignment: Alignment.center,
        child: const Text(
          "لا توجد بيانات كفاءة مواد مسجلة حالياً.",
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "مستوى الإتقان حسب المادة الدراسية",
          style: AppTextStyles.h4.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: subjects.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final subject = subjects[index];
            return FadeInUp(
              delay: (index % 5) * 60 + 100,
              child: SubjectProficiencyCard(subject: subject),
            );
          },
        ),
      ],
    );
  }
}