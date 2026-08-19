import 'package:draya_mobile/core/enums/cubit_status.dart';
import 'package:draya_mobile/core/helpers/app_url_helper.dart';
import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/core/theme/app_text_styles.dart';
import 'package:draya_mobile/core/view_models/drawer_model.dart';
import 'package:draya_mobile/core/widgets/app_drawer.dart';
import 'package:draya_mobile/core/widgets/custom_app_bar.dart';
import 'package:draya_mobile/core/widgets/fade_in_up_animation.dart';
import 'package:draya_mobile/features/student/student_materials/domain/entity/classroom_section.dart';
import 'package:draya_mobile/features/student/student_materials/presentation/cubit/student_materials_cubit.dart';
import 'package:draya_mobile/features/student/student_materials/presentation/cubit/student_materials_state.dart';
import 'package:draya_mobile/features/student/student_materials/presentation/pages/material_viewer_screen.dart';
import 'package:draya_mobile/features/student/student_materials/presentation/widgets/material_card.dart';
import 'package:draya_mobile/features/student/student_materials/presentation/widgets/materials_feedback.dart';
import 'package:draya_mobile/features/student/student_materials/presentation/widgets/materials_header.dart';
import 'package:draya_mobile/features/student/student_materials/presentation/widgets/section_expandable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentClassroomsMaterialsScreen extends StatefulWidget {
  final String? classroomId;
  final String? classroomName;

  const StudentClassroomsMaterialsScreen({
    super.key,
    this.classroomId,
    this.classroomName,
  });

  @override
  State<StudentClassroomsMaterialsScreen> createState() =>
      _StudentClassroomsMaterialsScreenState();
}

class _StudentClassroomsMaterialsScreenState
    extends State<StudentClassroomsMaterialsScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    if (widget.classroomId != null && widget.classroomId!.isNotEmpty) {
      context
          .read<StudentMaterialsCubit>()
          .getClassroomSections(widget.classroomId!);
    } else {
      context.read<StudentMaterialsCubit>().getEnrolledMaterials();
    }
  }

  void _downloadFile(String? fileUrl) {
    if (fileUrl != null && fileUrl.trim().isNotEmpty) {
      AppUrlHelper.launchURL(fileUrl.trim(), context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'رابط التحميل غير متوفر لهذا الملف',
            style: AppTextStyles.body.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _handleOpenDocument(SectionDocument doc, List<ClassroomSection> sections) {
    final fileUrl = doc.fileUrl;
    if (fileUrl != null && fileUrl.isNotEmpty) {
      if (doc.isPdf) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => StudentMaterialsViewerScreen(
              initialItem: ViewerMaterialItem.fromSectionDocument(doc),
              initialUrl: fileUrl,
              sections: sections,
              resolveItemUrl: (id, isVideo) async {
                final cubit = context.read<StudentMaterialsCubit>();
                if (isVideo) {
                  return await cubit.resolveSectionVideoUrl(
                    SectionVideo(
                      id: id,
                      title: '',
                      materialType: 'Video',
                      createdAt: DateTime.now(),
                    ),
                  );
                }
                return null;
              },
            ),
          ),
        );
      } else {
        AppUrlHelper.launchURL(fileUrl, context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'الملف غير متوفر حالياً للعرض',
            style: AppTextStyles.body.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _handleOpenVideo(SectionVideo video, List<ClassroomSection> sections) {
    if (video.hasVideoUrl) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => StudentMaterialsViewerScreen(
            initialItem: ViewerMaterialItem.fromSectionVideo(video),
            initialUrl: video.videoUrl!,
            sections: sections,
            resolveItemUrl: (id, isVideo) async {
              final cubit = context.read<StudentMaterialsCubit>();
              if (isVideo) {
                return await cubit.resolveSectionVideoUrl(
                  SectionVideo(
                    id: id,
                    title: '',
                    materialType: 'Video',
                    createdAt: DateTime.now(),
                  ),
                );
              }
              return null;
            },
          ),
        ),
      );
    } else {
      context.read<StudentMaterialsCubit>().openVideo(video);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isClassroomMode =
        widget.classroomId != null && widget.classroomId!.isNotEmpty;

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.classroomName == null
            ? 'المواد الدراسية'
            : 'مواد ${widget.classroomName}',
      ),
      drawer: AppDrawer(drawerItemsList: getStudentDrawerItemsList()),
      backgroundColor: AppColors.background,
      body: BlocConsumer<StudentMaterialsCubit, StudentMaterialsState>(
        listener: (context, state) {
          if (state.openingStatus == CubitStatus.success &&
              state.openUrl != null) {
            final url = state.openUrl!;
            final openingId = state.openingMaterialId;
            context.read<StudentMaterialsCubit>().clearOpeningResult();

            // Find matching item in sections or materials
            ViewerMaterialItem? matchedItem;
            for (final section in state.sections) {
              for (final doc in section.documents) {
                if (doc.id == openingId) {
                  matchedItem = ViewerMaterialItem.fromSectionDocument(
                    doc,
                    sectionTitle: section.title,
                  );
                  break;
                }
              }
              if (matchedItem != null) break;
              for (final vid in section.videos) {
                if (vid.id == openingId) {
                  matchedItem = ViewerMaterialItem.fromSectionVideo(
                    vid,
                    sectionTitle: section.title,
                  );
                  break;
                }
              }
              if (matchedItem != null) break;
            }

            if (matchedItem != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => StudentMaterialsViewerScreen(
                    initialItem: matchedItem,
                    initialUrl: url,
                    sections: state.sections,
                    resolveItemUrl: (id, isVideo) async {
                      final cubit = context.read<StudentMaterialsCubit>();
                      if (isVideo) {
                        return await cubit.resolveSectionVideoUrl(
                          SectionVideo(
                            id: id,
                            title: '',
                            materialType: 'Video',
                            createdAt: DateTime.now(),
                          ),
                        );
                      }
                      return null;
                    },
                  ),
                ),
              );
            } else {
              // Legacy flat material
              final material = state.materials
                  .where((m) => m.materialId == openingId)
                  .firstOrNull;
              if (material?.isVideo == true || material?.isPdf == true) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => StudentMaterialsViewerScreen(
                      initialMaterial: material!,
                      initialUrl: url,
                      materials: state.materials,
                      resolveMaterialUrl: context
                          .read<StudentMaterialsCubit>()
                          .resolveMaterialUrl,
                    ),
                  ),
                );
              } else {
                AppUrlHelper.launchURL(url, context);
              }
            }
          }
          if (state.openingStatus == CubitStatus.error &&
              state.apiErrorModel?.error?.message != null) {
            final message = state.apiErrorModel!.error!.message!;
            context.read<StudentMaterialsCubit>().clearOpeningResult();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  message,
                  style: AppTextStyles.body.copyWith(color: Colors.white),
                ),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (isClassroomMode) {
            return _buildSectionsView(context, state);
          }
          return _buildFlatMaterialsView(context, state);
        },
      ),
    );
  }

  Widget _buildSectionsView(BuildContext context, StudentMaterialsState state) {
    if (state.sectionsStatus == CubitStatus.loading && state.sections.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (state.sectionsStatus == CubitStatus.error && state.sections.isEmpty) {
      return MaterialsErrorState(
        message: state.apiErrorModel?.error?.message ??
            'حدث خطأ أثناء تحميل أقسام الفصل الدراسي.',
        onRetry: _loadData,
      );
    }

    final totalMaterialsCount = state.sections.fold<int>(
      0,
      (sum, s) => sum + s.totalItemsCount,
    );

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => _loadData(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppSizes.s16,
          AppSizes.s16,
          AppSizes.s16,
          AppSizes.s32,
        ),
        children: [
          MaterialsHeader(materialCount: totalMaterialsCount),
          const SizedBox(height: 18),
          if (state.sections.isEmpty)
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.52,
              child: MaterialsEmptyState(onRefresh: _loadData),
            )
          else
            ...state.sections.asMap().entries.map((entry) {
              final index = entry.key;
              final section = entry.value;
              final card = SectionExpandableCard(
                section: section,
                initialExpanded: index == 0,
                isReadOnly: false,
                openingId: state.openingStatus == CubitStatus.loading
                    ? state.openingMaterialId
                    : null,
                onOpenDocument: (doc) =>
                    _handleOpenDocument(doc, state.sections),
                onDownloadDocument: (doc) => _downloadFile(doc.fileUrl),
                onOpenVideo: (vid) => _handleOpenVideo(vid, state.sections),
              );

              if (index < 6) {
                return FadeInUp(
                  delay: index * 50,
                  child: card,
                );
              }
              return card;
            }),
        ],
      ),
    );
  }

  Widget _buildFlatMaterialsView(
    BuildContext context,
    StudentMaterialsState state,
  ) {
    if (state.materialsStatus == CubitStatus.loading &&
        state.materials.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    if (state.materialsStatus == CubitStatus.error && state.materials.isEmpty) {
      return MaterialsErrorState(
        message: state.apiErrorModel?.error?.message ??
            'حدث خطأ أثناء تحميل المواد.',
        onRetry: _loadData,
      );
    }
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => _loadData(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppSizes.s16,
          AppSizes.s16,
          AppSizes.s16,
          AppSizes.s32,
        ),
        children: [
          MaterialsHeader(materialCount: state.materials.length),
          const SizedBox(height: 18),
          if (state.materials.isEmpty)
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.52,
              child: MaterialsEmptyState(onRefresh: _loadData),
            )
          else
            ...state.materials.asMap().entries.map((entry) {
              final index = entry.key;
              final material = entry.value;
              final card = Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: MaterialCard(
                  material: material,
                  isOpening: state.openingStatus == CubitStatus.loading &&
                      state.openingMaterialId == material.materialId,
                  onOpen: () => context
                      .read<StudentMaterialsCubit>()
                      .openMaterial(material),
                  onDownload: material.currentVersion.fileUrl != null &&
                          material.currentVersion.fileUrl!.isNotEmpty
                      ? () => _downloadFile(material.currentVersion.fileUrl)
                      : null,
                ),
              );

              if (index < 6) {
                return FadeInUp(
                  delay: index * 50,
                  child: card,
                );
              }
              return card;
            }),
          if (state.hasNextPage)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Center(
                child: SizedBox(
                  width: 200,
                  child: OutlinedButton.icon(
                    onPressed: state.materialsStatus == CubitStatus.loading
                        ? null
                        : () => context
                            .read<StudentMaterialsCubit>()
                            .getEnrolledMaterials(
                              page: state.pageNumber + 1,
                            ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(
                        color: AppColors.primary300,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(
                      Icons.expand_more_rounded,
                      size: 20,
                    ),
                    label: Text(
                      'تحميل المزيد',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
