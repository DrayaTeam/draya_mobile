import 'package:draya_mobile/core/enums/cubit_status.dart';
import 'package:draya_mobile/core/helpers/app_url_helper.dart';
import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/core/theme/app_text_styles.dart';
import 'package:draya_mobile/core/view_models/drawer_model.dart';
import 'package:draya_mobile/core/widgets/app_drawer.dart';
import 'package:draya_mobile/core/widgets/custom_app_bar.dart';
import 'package:draya_mobile/core/widgets/fade_in_up_animation.dart';
import 'package:draya_mobile/features/student/student_materials/domain/entity/student_material.dart';
import 'package:draya_mobile/features/student/student_materials/presentation/cubit/student_materials_cubit.dart';
import 'package:draya_mobile/features/student/student_materials/presentation/cubit/student_materials_state.dart';
import 'package:draya_mobile/features/student/student_materials/presentation/pages/material_viewer_screen.dart';
import 'package:draya_mobile/features/student/student_materials/presentation/widgets/material_card.dart';
import 'package:draya_mobile/features/student/student_materials/presentation/widgets/materials_feedback.dart';
import 'package:draya_mobile/features/student/student_materials/presentation/widgets/materials_header.dart';
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
  StudentMaterial? _materialById(
    List<StudentMaterial> materials,
    String? materialId,
  ) {
    for (final material in materials) {
      if (material.materialId == materialId) return material;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    context.read<StudentMaterialsCubit>().getEnrolledMaterials(
      classroomId: widget.classroomId,
    );
  }

  void _downloadMaterial(StudentMaterial material) {
    final fileUrl = material.currentVersion.fileUrl;
    if (fileUrl != null && fileUrl.isNotEmpty) {
      AppUrlHelper.launchURL(fileUrl, context);
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

  @override
  Widget build(BuildContext context) {
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
            final material = _materialById(
              state.materials,
              state.openingMaterialId,
            );
            final url = state.openUrl!;
            context.read<StudentMaterialsCubit>().clearOpeningResult();
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
          if (state.materialsStatus == CubitStatus.loading &&
              state.materials.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          if (state.materialsStatus == CubitStatus.error &&
              state.materials.isEmpty) {
            return MaterialsErrorState(
              message: state.apiErrorModel?.error?.message ??
                  'حدث خطأ أثناء تحميل المواد.',
              onRetry: () => context
                  .read<StudentMaterialsCubit>()
                  .getEnrolledMaterials(classroomId: widget.classroomId),
            );
          }
          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => context
                .read<StudentMaterialsCubit>()
                .getEnrolledMaterials(classroomId: widget.classroomId),
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
                    child: MaterialsEmptyState(
                      onRefresh: () => context
                          .read<StudentMaterialsCubit>()
                          .getEnrolledMaterials(
                            classroomId: widget.classroomId,
                          ),
                    ),
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
                            ? () => _downloadMaterial(material)
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
                                    classroomId: widget.classroomId,
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
        },
      ),
    );
  }
}


