import "package:draya_mobile/core/di/dependency_injection.dart";
import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/router/app_routes.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/core/view_models/drawer_model.dart";
import "package:draya_mobile/core/widgets/app_drawer.dart";
import "package:draya_mobile/core/widgets/custom_app_bar.dart";
import "package:draya_mobile/core/widgets/fade_in_up_animation.dart";
import "package:draya_mobile/features/student/student_channel/presentation/cubit/student_channel_cubit.dart";
import "package:draya_mobile/features/student/student_channel/presentation/cubit/student_channel_state.dart";
import "package:draya_mobile/features/student/student_channel/presentation/pages/question_details_screen.dart";
import "package:draya_mobile/features/student/student_channel/presentation/widgets/add_question_bottom_sheet.dart";
import "package:draya_mobile/features/student/student_channel/presentation/widgets/empty_questions_widget.dart";
import "package:draya_mobile/features/student/student_channel/presentation/widgets/question_card_widget.dart";
import "package:draya_mobile/features/student/student_channel/presentation/widgets/question_filter_widget.dart";
import "package:draya_mobile/features/student/student_enrolled_classrooms/domain/entity/student_enrolled_classroom.dart";
import "package:draya_mobile/features/student/student_enrolled_classrooms/presentation/cubit/student_enrolled_classrooms_cubit.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";

class StudentChannelScreen extends StatelessWidget {
  final String? initialClassroomId;

  const StudentChannelScreen({super.key, this.initialClassroomId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<StudentChannelCubit>(),
      child: _StudentChannelContent(initialClassroomId: initialClassroomId),
    );
  }
}

class _StudentChannelContent extends StatefulWidget {
  final String? initialClassroomId;

  const _StudentChannelContent({this.initialClassroomId});

  @override
  State<_StudentChannelContent> createState() => _StudentChannelContentState();
}

class _StudentChannelContentState extends State<_StudentChannelContent> {
  static const int _classroomsPageSize = 100;

  final StudentEnrolledClassroomsCubit _classroomsCubit =
      getIt<StudentEnrolledClassroomsCubit>();

  List<StudentEnrolledClassroom> _classrooms = const [];
  List<GlobalKey> _tabKeys = const [];
  bool _isLoadingClassrooms = false;
  bool _channelInitialized = false;
  String? _classroomsError;
  int _selectedTabIndex = 0;

  bool get _hasActiveClassroom =>
      _classrooms.isNotEmpty && _selectedTabIndex < _classrooms.length;

  String get _activeClassroomId => _classrooms[_selectedTabIndex].classroomId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadClassrooms());
  }

  @override
  void dispose() {
    if (!_classroomsCubit.isClosed) {
      _classroomsCubit.close();
    }
    super.dispose();
  }

  Future<void> _loadClassrooms() async {
    if (_isLoadingClassrooms) return;
    setState(() {
      _isLoadingClassrooms = true;
      _classroomsError = null;
    });

    await _classroomsCubit.getStudentEnrolledClassrooms(
      pageSize: _classroomsPageSize,
    );
    if (!mounted) return;

    final classroomState = _classroomsCubit.state;
    final loadedClassrooms =
        classroomState.status == CubitStatus.success
            ? classroomState.classrooms
            : <StudentEnrolledClassroom>[];

    int nextIndex = 0;
    if (loadedClassrooms.isNotEmpty && !_channelInitialized) {
      final initialId = widget.initialClassroomId;
      if (initialId != null) {
        final foundIndex = loadedClassrooms.indexWhere(
          (classroom) => classroom.classroomId == initialId,
        );
        nextIndex = foundIndex >= 0 ? foundIndex : 0;
      }
    } else if (_selectedTabIndex < loadedClassrooms.length &&
        loadedClassrooms.isNotEmpty) {
      nextIndex = _selectedTabIndex;
    }

    setState(() {
      _isLoadingClassrooms = false;
      _classrooms = loadedClassrooms;
      _selectedTabIndex = nextIndex;
      _classroomsError = classroomState.status == CubitStatus.error
          ? (classroomState.apiErrorModel?.error?.message ??
                "تعذر تحميل الفصول الدراسية")
          : null;
      _tabKeys = List.generate(loadedClassrooms.length, (_) => GlobalKey());
    });

    if (loadedClassrooms.isEmpty || nextIndex >= loadedClassrooms.length) {
      return;
    }

    final channelId = loadedClassrooms[nextIndex].classroomId;
    final channelCubit = context.read<StudentChannelCubit>();
    if (!_channelInitialized) {
      _channelInitialized = true;
      await channelCubit.initializeChannel(classroomId: channelId);
    } else {
      await channelCubit.switchClassroom(classroomId: channelId);
    }
  }

  void _onTabSelected(int index) {
    if (index == _selectedTabIndex || index >= _classrooms.length) return;
    setState(() => _selectedTabIndex = index);
    context
        .read<StudentChannelCubit>()
        .switchClassroom(classroomId: _classrooms[index].classroomId);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _ensureTabVisible(index),
    );
  }

  void _ensureTabVisible(int index) {
    if (index >= _tabKeys.length) return;
    final keyContext = _tabKeys[index].currentContext;
    if (keyContext != null && keyContext.mounted) {
      Scrollable.ensureVisible(
        keyContext,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
        alignment: 0.5,
      );
    }
  }

  Future<void> _refreshQuestions() {
    return context.read<StudentChannelCubit>().getQuestions(
      classroomId: _activeClassroomId,
      sortBy: context.read<StudentChannelCubit>().state.sortBy,
      filterBy: context.read<StudentChannelCubit>().state.filterBy,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: "القناة الرئيسية",
        bottom: _hasActiveClassroom ? _buildTabsBar() : null,
      ),
      drawer: AppDrawer(drawerItemsList: getStudentDrawerItemsList()),
      floatingActionButton: _hasActiveClassroom
          ? FloatingActionButton.extended(
              onPressed: () => _showAddQuestionSheet(context),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 4,
              icon: const Icon(Icons.add_rounded),
              label: Text(
                "اسأل سؤالاً",
                style: AppTextStyles.button.copyWith(color: Colors.white),
              ),
            )
          : null,
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildTabsBar() {
    return _ClassroomTabsBar(
      classrooms: _classrooms,
      tabKeys: _tabKeys,
      selectedIndex: _selectedTabIndex,
      onTabSelected: _onTabSelected,
    );
  }

  Widget _buildBody() {
    if (_isLoadingClassrooms && _classrooms.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_classroomsError != null && _classrooms.isEmpty) {
      return _ChannelClassroomsErrorView(
        message: _classroomsError!,
        onRetry: _loadClassrooms,
      );
    }

    if (_classrooms.isEmpty) {
      return _NoClassroomsView(
        onBrowseClassrooms: () {
          context.push(AppRoutes.studentEnrolledClassroomsPage);
        },
      );
    }

    return BlocBuilder<StudentChannelCubit, StudentChannelState>(
      builder: (context, state) {
        return Column(
          children: [
            QuestionFilterWidget(
              currentSort: state.sortBy,
              currentFilter: state.filterBy,
              onSortChanged: (sort) {
                context.read<StudentChannelCubit>().getQuestions(
                  classroomId: _activeClassroomId,
                  sortBy: sort,
                  filterBy: state.filterBy,
                );
              },
              onFilterChanged: (filter) {
                context.read<StudentChannelCubit>().getQuestions(
                  classroomId: _activeClassroomId,
                  sortBy: state.sortBy,
                  filterBy: filter,
                );
              },
            ),
            if (state.hasPendingNewQuestions)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _refreshQuestions,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(16, 10, 16, 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primary300),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.refresh_rounded,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "هناك أسئلة جديدة — اضغط للتحديث",
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Expanded(child: _buildFeed(context, state)),
          ],
        );
      },
    );
  }

  Widget _buildFeed(BuildContext context, StudentChannelState state) {
    final classroomId = _activeClassroomId;
    final channelCubit = context.read<StudentChannelCubit>();

    if (state.questionsStatus == CubitStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (state.questionsStatus == CubitStatus.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  size: 36,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "تعذر تحميل الأسئلة",
                style: AppTextStyles.h4.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                state.apiErrorModel?.error?.message ?? "حدث خطأ غير متوقع",
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  channelCubit.getQuestions(classroomId: classroomId);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(
                  "حاول مرة أخرى",
                  style: AppTextStyles.button.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (state.questions.isEmpty) {
      return EmptyQuestionsWidget(
        onRefresh: () {
          channelCubit.getQuestions(classroomId: classroomId);
        },
        onAction: () => _showAddQuestionSheet(context),
        actionLabel: "اسأل سؤالاً جديداً",
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
      onRefresh: _refreshQuestions,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 96),
        itemCount:
            state.questions.length +
            (state.currentPage < state.totalPages ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.questions.length) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: SizedBox(
                  width: 200,
                  child: OutlinedButton.icon(
                    onPressed: state.isLoadingMore
                        ? null
                        : () => channelCubit.getQuestions(
                            classroomId: classroomId,
                            page: state.currentPage + 1,
                            sortBy: state.sortBy,
                            filterBy: state.filterBy,
                          ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary300),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: state.isLoadingMore
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary,
                              ),
                            ),
                          )
                        : const Icon(Icons.expand_more_rounded, size: 20),
                    label: Text(
                      "تحميل المزيد",
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          final question = state.questions[index];
          final card = QuestionCardWidget(
            question: question,
            isVoting:
                state.votingQuestionId == question.id &&
                state.voteStatus == CubitStatus.loading,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: channelCubit,
                    child: QuestionDetailsScreen(
                      classroomId: classroomId,
                      questionId: question.id,
                    ),
                  ),
                ),
              );
            },
            onVote: () {
              if (question.hasVoted) {
                channelCubit.unvoteQuestion(
                  classroomId: classroomId,
                  questionId: question.id,
                );
              } else {
                channelCubit.voteQuestion(
                  classroomId: classroomId,
                  questionId: question.id,
                );
              }
            },
          );

          if (index < 5) {
            return FadeInUp(delay: index * 60, child: card);
          }
          return card;
        },
      ),
    );
  }

  void _showAddQuestionSheet(BuildContext context) {
    final cubit = context.read<StudentChannelCubit>();
    final classroomId = _activeClassroomId;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return BlocProvider.value(
          value: cubit,
          child: BlocListener<StudentChannelCubit, StudentChannelState>(
            listener: (listenerContext, state) {
              if (state.createQuestionStatus == CubitStatus.success) {
                Navigator.of(sheetContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "تم نشر السؤال بنجاح",
                      style: AppTextStyles.body.copyWith(color: Colors.white),
                    ),
                    backgroundColor: AppColors.primary,
                  ),
                );
              } else if (state.createQuestionStatus == CubitStatus.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.apiErrorModel?.error?.message ?? "حدث خطأ",
                      style: AppTextStyles.body.copyWith(color: Colors.white),
                    ),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            child: BlocBuilder<StudentChannelCubit, StudentChannelState>(
              builder: (_, state) {
                return AddQuestionBottomSheet(
                  isLoading: state.createQuestionStatus == CubitStatus.loading,
                  onSubmit: (content) {
                    cubit.createQuestion(
                      classroomId: classroomId,
                      content: content,
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _ClassroomTabsBar extends StatelessWidget implements PreferredSizeWidget {
  static const double _barHeight = 75;

  final List<StudentEnrolledClassroom> classrooms;
  final List<GlobalKey> tabKeys;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const _ClassroomTabsBar({
    required this.classrooms,
    required this.tabKeys,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Size get preferredSize => const Size.fromHeight(_barHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _barHeight,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: classrooms.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final classroom = classrooms[index];
          return _ClassroomTabPill(
            key: tabKeys[index],
            title: classroom.name,
            subtitle: classroom.subjectName,
            isSelected: index == selectedIndex,
            onTap: () => onTabSelected(index),
          );
        },
      ),
    );
  }
}

class _ClassroomTabPill extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _ClassroomTabPill({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  String get _avatarLetter => subtitle.trim().isEmpty
      ? "ف"
      : subtitle.trim().substring(0, 1);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: "$subtitle - $title",
      button: true,
      selected: isSelected,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [AppColors.primary600, AppColors.primary800],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isSelected ? null : AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? Colors.transparent : AppColors.borderStrong,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.22)
                        : AppColors.primary50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _avatarLetter,
                    style: AppTextStyles.label.copyWith(
                      color: isSelected ? Colors.white : AppColors.primary700,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 130),
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.label.copyWith(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.label.copyWith(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.85)
                            : AppColors.textSecondary,
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChannelClassroomsErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ChannelClassroomsErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 36,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "تعذر تحميل الفصول الدراسية",
              style: AppTextStyles.h4.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(
                "إعادة المحاولة",
                style: AppTextStyles.button.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoClassroomsView extends StatelessWidget {
  final VoidCallback onBrowseClassrooms;

  const _NoClassroomsView({required this.onBrowseClassrooms});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.primary50,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary200, width: 1.5),
              ),
              child: const Icon(
                Icons.forum_outlined,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "لا توجد فصول دراسية بعد",
              style: AppTextStyles.h4.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "انضم إلى فصل دراسي لتظهر قنوات الأسئلة الخاصة به هنا.",
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onBrowseClassrooms,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.school_outlined, size: 18),
              label: Text(
                "استعراض فصولى",
                style: AppTextStyles.button.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
