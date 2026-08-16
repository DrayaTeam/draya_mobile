import 'package:draya_mobile/core/enums/cubit_status.dart';
import 'package:draya_mobile/core/helpers/app_url_helper.dart';
import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/core/view_models/drawer_model.dart';
import 'package:draya_mobile/core/widgets/app_custom_loading.dart';
import 'package:draya_mobile/core/widgets/app_drawer.dart';
import 'package:draya_mobile/core/widgets/custom_app_bar.dart';
import 'package:draya_mobile/features/student/student_materials/presentation/cubit/student_materials_cubit.dart';
import 'package:draya_mobile/features/student/student_materials/presentation/cubit/student_materials_state.dart';
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
  State<StudentClassroomsMaterialsScreen> createState() => _StudentClassroomsMaterialsScreenState();
}

class _StudentClassroomsMaterialsScreenState extends State<StudentClassroomsMaterialsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StudentMaterialsCubit>().getEnrolledMaterials(
      classroomId: widget.classroomId,
    );
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
          if (state.openingStatus == CubitStatus.success && state.openUrl != null) {
            final url = state.openUrl!;
            context.read<StudentMaterialsCubit>().clearOpeningResult();
            AppUrlHelper.launchURL(url, context);
          }
          if (state.openingStatus == CubitStatus.error && state.apiErrorModel?.error?.message != null) {
            final message = state.apiErrorModel!.error!.message!;
            context.read<StudentMaterialsCubit>().clearOpeningResult();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: AppColors.error));
          }
        },
        builder: (context, state) {
          if (state.materialsStatus == CubitStatus.loading && state.materials.isEmpty) return const Center(child: AppCustomLoading(text: 'جارٍ تحميل المواد...'));
          if (state.materialsStatus == CubitStatus.error && state.materials.isEmpty) return MaterialsErrorState(message: state.apiErrorModel?.error?.message ?? 'حدث خطأ أثناء تحميل المواد.', onRetry: () => context.read<StudentMaterialsCubit>().getEnrolledMaterials(classroomId: widget.classroomId));
          return RefreshIndicator(
            onRefresh: () => context
                .read<StudentMaterialsCubit>()
                .getEnrolledMaterials(classroomId: widget.classroomId),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(AppSizes.s16, AppSizes.s16, AppSizes.s16, AppSizes.s32),
              children: [
                MaterialsHeader(materialCount: state.materials.length),
                const SizedBox(height: AppSizes.s20),
                if (state.materials.isEmpty)
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.52, child: MaterialsEmptyState(onRefresh: () => context.read<StudentMaterialsCubit>().getEnrolledMaterials(classroomId: widget.classroomId)))
                else
                  ...state.materials.map((material) => Padding(padding: const EdgeInsets.only(bottom: AppSizes.s12), child: MaterialCard(material: material, isOpening: state.openingStatus == CubitStatus.loading && state.openingMaterialId == material.materialId, onOpen: () => context.read<StudentMaterialsCubit>().openMaterial(material)))),
                if (state.hasNextPage)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSizes.s4),
                    child: OutlinedButton.icon(
                      onPressed: state.materialsStatus == CubitStatus.loading
                          ? null
                          : () => context.read<StudentMaterialsCubit>().getEnrolledMaterials(classroomId: widget.classroomId, page: state.pageNumber + 1),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      label: const Text('تحميل المزيد'),
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
