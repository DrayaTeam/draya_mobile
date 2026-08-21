import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/helpers/app_dialog_helper.dart";
import "package:draya_mobile/core/helpers/app_loading.dart";
import "package:draya_mobile/core/helpers/app_navigator.dart";
import "package:draya_mobile/core/router/app_routes.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/core/widgets/app_error_dialog.dart";
import "package:draya_mobile/core/widgets/custom_app_bar.dart";
import "package:draya_mobile/core/widgets/fade_in_up_animation.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/classroom_model.dart";
import "package:draya_mobile/features/teacher/sections/data/models/create_section_request_model.dart";
import "package:draya_mobile/features/teacher/sections/data/models/section_model.dart";
import "package:draya_mobile/features/teacher/sections/presentation/cubit/section_cubit.dart";
import "package:draya_mobile/features/teacher/sections/presentation/cubit/section_state.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class SectionsPage extends StatefulWidget {
  final ClassroomModel _classroomModel;
  const SectionsPage(this._classroomModel, {super.key});

  @override
  State<SectionsPage> createState() => _SectionsPageState();
}

class _SectionsPageState extends State<SectionsPage> {
  @override
  void initState() {
    super.initState();
    context.read<SectionCubit>().getSections(
          classroomId: widget._classroomModel.classroomId,
        );
  }

  Future<CreateSectionRequestModel?> _showCreateSectionBottomSheet() async {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return await showModalBottomSheet<CreateSectionRequestModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return Container(
          padding: EdgeInsets.only(
            left: AppSizes.s20,
            right: AppSizes.s20,
            top: AppSizes.s16,
            bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom +
                AppSizes.s24,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Handle Bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.borderStrong,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Header
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primary200),
                        ),
                        child: const Icon(
                          Icons.create_new_folder_outlined,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "إنشاء قسم جديد",
                              style: AppTextStyles.h4.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              "أضف قسماً لتنظيم المحتوى، الملفات، والفيديوهات",
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Title Field
                  Text(
                    "اسم القسم",
                    style: AppTextStyles.label.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: titleController,
                    textDirection: TextDirection.rtl,
                    decoration: InputDecoration(
                      hintText: "مثال: الوحدة الأولى - التراكيب والوظائف",
                      hintStyle: AppTextStyles.body.copyWith(
                        color: AppColors.textDisabled,
                        fontSize: 13,
                      ),
                      filled: true,
                      fillColor: AppColors.backgroundSecondary,
                      prefixIcon: const Icon(
                        Icons.folder_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                    ),
                    validator: (val) =>
                        val == null || val.trim().isEmpty ? "أدخل اسم القسم" : null,
                  ),
                  const SizedBox(height: 14),

                  // Description Field
                  Text(
                    "وصف القسم (اختياري)",
                    style: AppTextStyles.label.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: descController,
                    maxLines: 2,
                    textDirection: TextDirection.rtl,
                    decoration: InputDecoration(
                      hintText: "نبذة عن محتوى هذا القسم والدروس المشمولة...",
                      hintStyle: AppTextStyles.body.copyWith(
                        color: AppColors.textDisabled,
                        fontSize: 13,
                      ),
                      filled: true,
                      fillColor: AppColors.backgroundSecondary,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(bottomSheetContext),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.foregroundMuted,
                            side: const BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text("إلغاء"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              Navigator.pop(
                                bottomSheetContext,
                                CreateSectionRequestModel(
                                  title: titleController.text.trim(),
                                  description: descController.text.trim(),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(Icons.add, size: 18),
                          label: Text(
                            "إنشاء القسم",
                            style: AppTextStyles.label.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _createSection() async {
    final model = await _showCreateSectionBottomSheet();
    if (model == null || !mounted) return;

    await context.read<SectionCubit>().createSection(
          classroomId: widget._classroomModel.classroomId,
          createSectionRequestModel: model,
        );
  }

  Future<void> _confirmDeleteSection({
    required String sectionId,
    required String sectionTitle,
  }) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.delete_forever_rounded,
                  color: AppColors.error,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              const Text("حذف القسم"),
            ],
          ),
          content: Text(
            "هل أنت متأكد من حذف قسم \"$sectionTitle\"؟ سيتم حذف جميع المواد الملحقة به نهائياً.",
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text("إلغاء"),
            ),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text("حذف نهائي"),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !mounted) return;

    await context.read<SectionCubit>().deleteSection(sectionId: sectionId);
  }

  void _previewAsStudent() {
    AppNavigator.push(
      context: context,
      path: AppRoutes.studentClassroomMaterialsPage(
        widget._classroomModel.classroomId,
      ),
      extra: widget._classroomModel.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SectionCubit, SectionState>(
      listener: (context, state) {
        if (state.getSectionsStatus == CubitStatus.loading ||
            state.createSectionStatus == CubitStatus.loading ||
            state.deleteSectionStatus == CubitStatus.loading) {
          AppLoading.show();
        }

        if (state.getSectionsStatus == CubitStatus.error ||
            state.createSectionStatus == CubitStatus.error ||
            state.deleteSectionStatus == CubitStatus.error) {
          AppLoading.hide();
          if (state.apiErrorModel != null) {
            AppDialogHelper.display(
              context,
              AppErrorDialog(apiErrorModel: state.apiErrorModel!),
            );
          }
        }

        if (state.createSectionStatus == CubitStatus.success) {
          AppLoading.hide();
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: AppColors.chemistryBiology,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                content: const Row(
                  children: [
                    Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text("تم إنشاء القسم بنجاح", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            );

          context.read<SectionCubit>().getSections(
                classroomId: widget._classroomModel.classroomId,
              );
        }

        if (state.deleteSectionStatus == CubitStatus.success) {
          AppLoading.hide();
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: AppColors.primary800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                content: const Row(
                  children: [
                    Icon(Icons.delete_sweep_rounded, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text("تم حذف القسم بنجاح", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            );

          context.read<SectionCubit>().getSections(
                classroomId: widget._classroomModel.classroomId,
              );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const CustomAppBar(title: "أقسام الفصل الدراسي"),
        body: SafeArea(
          child: BlocBuilder<SectionCubit, SectionState>(
            builder: (context, state) {
              final sections = state.sections;

              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async {
                  await context.read<SectionCubit>().getSections(
                        classroomId: widget._classroomModel.classroomId,
                      );
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.s16,
                    AppSizes.s16,
                    AppSizes.s16,
                    AppSizes.s36,
                  ),
                  children: [
                    // Hero Banner
                    _SectionsHeroBanner(
                      classroom: widget._classroomModel,
                      totalSections: sections.length,
                      onCreateSection: _createSection,
                      onPreviewAsStudent: _previewAsStudent,
                    ),
                    const SizedBox(height: AppSizes.s20),

                    // Section List Title
                    Row(
                      children: [
                        Text(
                          "أقسام الفصل ومحتوياتها",
                          style: AppTextStyles.h5.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary50,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: AppColors.primary200),
                          ),
                          child: Text(
                            "${sections.length} قسم",
                            style: AppTextStyles.label.copyWith(
                              color: AppColors.primary700,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.s12),

                    // Sections List / Empty State
                    if (state.getSectionsStatus == CubitStatus.loading &&
                        sections.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      )
                    else if (sections.isEmpty)
                      _EmptySectionsState(onCreate: _createSection)
                    else
                      ...sections.asMap().entries.map((entry) {
                        final index = entry.key;
                        final section = entry.value;
                        final card = _SectionCardItem(
                          section: section,
                          classroomId: widget._classroomModel.classroomId,
                          onManageMaterials: () {
                            AppNavigator.push(
                              context: context,
                              path: AppRoutes.materialsPage,
                              pathParameters: {
                                "classroomId":
                                    widget._classroomModel.classroomId,
                              },
                              extra: section,
                            );
                          },
                          onPreviewAsStudent: _previewAsStudent,
                          onDelete: () => _confirmDeleteSection(
                            sectionId: section.id,
                            sectionTitle: section.title,
                          ),
                        );

                        if (index < 8) {
                          return FadeInUp(
                            delay: index * 50,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSizes.s12,
                              ),
                              child: card,
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSizes.s12),
                          child: card,
                        );
                      }),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sections Hero Banner
// ---------------------------------------------------------------------------
class _SectionsHeroBanner extends StatelessWidget {
  final ClassroomModel classroom;
  final int totalSections;
  final VoidCallback onCreateSection;
  final VoidCallback onPreviewAsStudent;

  const _SectionsHeroBanner({
    required this.classroom,
    required this.totalSections,
    required this.onCreateSection,
    required this.onPreviewAsStudent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary800, AppColors.primary600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary700.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.auto_stories_rounded,
                      size: 13,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      classroom.subjectName,
                      style: AppTextStyles.label.copyWith(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "$totalSections أقسام",
                  style: AppTextStyles.label.copyWith(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            classroom.name,
            style: AppTextStyles.h3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "قسّم المنهج إلى وحدات ودروس ليسهل على الطلاب المتابعة والتعلم",
            style: AppTextStyles.body.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 12.5,
            ),
          ),
          const SizedBox(height: 16),
          // Actions
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: ElevatedButton.icon(
                    onPressed: onCreateSection,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary800,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.add_circle_rounded, size: 18),
                    label: Text(
                      "إنشاء قسم جديد",
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.primary800,
                        fontWeight: FontWeight.w800,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 42,
                child: OutlinedButton.icon(
                  onPressed: onPreviewAsStudent,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  label: Text(
                    "معاينة كطالب",
                    style: AppTextStyles.label.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section Card Item
// ---------------------------------------------------------------------------
class _SectionCardItem extends StatelessWidget {
  final SectionModel section;
  final String classroomId;
  final VoidCallback onManageMaterials;
  final VoidCallback onPreviewAsStudent;
  final VoidCallback onDelete;

  const _SectionCardItem({
    required this.section,
    required this.classroomId,
    required this.onManageMaterials,
    required this.onPreviewAsStudent,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final docsCount = section.documents.length;
    final videosCount = section.videos.length;
    final examsCount = section.exams.length;
    final totalItems = docsCount + videosCount + examsCount;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Section Info
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary200),
                    ),
                    child: const Icon(
                      Icons.folder_special_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          section.title,
                          style: AppTextStyles.h5.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            fontSize: 15,
                          ),
                        ),
                        if (section.description.trim().isNotEmpty) ...[
                          const SizedBox(height: 3),
                          Text(
                            section.description.trim(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),
                        // Badges Row
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            if (docsCount > 0)
                              _CountBadge(
                                icon: Icons.description_outlined,
                                text: "$docsCount ملف",
                                color: AppColors.error,
                              ),
                            if (videosCount > 0)
                              _CountBadge(
                                icon: Icons.play_circle_outline_rounded,
                                text: "$videosCount فيديو",
                                color: AppColors.ai700,
                              ),
                            if (examsCount > 0)
                              _CountBadge(
                                icon: Icons.quiz_outlined,
                                text: "$examsCount اختبار",
                                color: AppColors.amber,
                              ),
                            if (totalItems == 0)
                              const _CountBadge(
                                icon: Icons.info_outline_rounded,
                                text: "لا توجد مواد بعد",
                                color: AppColors.foregroundMuted,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  // Delete Button
                  IconButton(
                    onPressed: onDelete,
                    style: IconButton.styleFrom(
                      foregroundColor: AppColors.error,
                      backgroundColor: AppColors.error.withValues(alpha: 0.08),
                      padding: const EdgeInsets.all(8),
                    ),
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      size: 19,
                    ),
                    tooltip: "حذف القسم",
                  ),
                ],
              ),
            ),

            const Divider(color: AppColors.border, height: 1),

            // Bottom Actions Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 36,
                      child: ElevatedButton.icon(
                        onPressed: onManageMaterials,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(
                          Icons.upload_file_rounded,
                          size: 16,
                        ),
                        label: Text(
                          "إدارة ورفع المواد",
                          style: AppTextStyles.label.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Tooltip(
                    message: "معاينة كطالب",
                    child: InkWell(
                      onTap: onPreviewAsStudent,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 36,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.ai50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.ai300),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.visibility_outlined,
                              color: AppColors.ai700,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "معاينة",
                              style: AppTextStyles.label.copyWith(
                                color: AppColors.ai700,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _CountBadge({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 3),
          Text(
            text,
            style: AppTextStyles.label.copyWith(
              color: color,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty State
// ---------------------------------------------------------------------------
class _EmptySectionsState extends StatelessWidget {
  final VoidCallback onCreate;

  const _EmptySectionsState({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: AppColors.primary50,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary200),
            ),
            child: const Icon(
              Icons.folder_open_rounded,
              size: 34,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "لا توجد أقسام في هذا الفصل بعد",
            style: AppTextStyles.h5.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            "أنشئ أقساماً لتنظيم المنهج وتسهيل رفع المستندات والفيديوهات للطلاب.",
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: onCreate,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            icon: const Icon(Icons.add, size: 18),
            label: const Text("إنشاء أول قسم الآن"),
          ),
        ],
      ),
    );
  }
}
