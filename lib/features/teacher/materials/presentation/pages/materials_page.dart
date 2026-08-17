import 'package:draya_mobile/core/enums/cubit_status.dart';
import 'package:draya_mobile/core/enums/material_type_enum.dart';
import 'package:draya_mobile/core/helpers/app_dialog_helper.dart';
import 'package:draya_mobile/core/helpers/app_extensions.dart';
import 'package:draya_mobile/core/helpers/app_navigator.dart';
import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/core/widgets/app_card_container_empty.dart';
import 'package:draya_mobile/core/widgets/app_card_container_info.dart';
import 'package:draya_mobile/core/widgets/app_custom_loading.dart';
import 'package:draya_mobile/core/widgets/app_elevated_button.dart';
import 'package:draya_mobile/core/widgets/app_error_dialog.dart';
import 'package:draya_mobile/core/widgets/custom_app_bar.dart';
import 'package:draya_mobile/features/teacher/classrooms/data/models/classroom_model.dart';
import 'package:draya_mobile/features/teacher/materials/data/models/materials_request_model.dart';
import 'package:draya_mobile/features/teacher/materials/domain/usecases/get_materials_use_case.dart';
import 'package:draya_mobile/features/teacher/materials/presentation/cubit/materials_cubit.dart';
import 'package:draya_mobile/features/teacher/materials/presentation/cubit/materials_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialsPage extends StatefulWidget {
  final ClassroomModel _classroomModel;
  const MaterialsPage(this._classroomModel, {super.key});

  @override
  State<MaterialsPage> createState() => _MaterialsPageState();
}

class _MaterialsPageState extends State<MaterialsPage> {
  String _fileNameSelected = "لا يوجد ملف";

  PlatformFile? _selectedFile;

  Future<void> _pickFile() async {
    final result = await FilePicker.pickFiles(
      allowMultiple: false,
    );

    if (result == null) {
      return;
    }

    final file = result.files.single;

    setState(() {
      _selectedFile = file;
      _fileNameSelected = file.name;
    });
  }

  Future<void> _uploadFile() async {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text("يرجى اختيار الملف اولاً"),
        ),
      );

      return;
    }

    if (_selectedFile!.path == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text("تعذر الوصول الى الملف"),
        ),
      );

      return;
    }

    final fileName = _selectedFile!.name;

    final title = fileName.contains(".")
        ? fileName.substring(0, fileName.lastIndexOf("."))
        : fileName;

    final materialType = fileName.contains(".") ? fileName.split(".").last : "";

    final request = MaterialsRequestModel(
      title: title,
      materialType: MaterialTypeEnum.fromExtension(extension: materialType),
      file: _selectedFile!,
    );

    await context.read<MaterialsCubit>().uploadMaterials(
      classroomId: widget._classroomModel.classroomId,
      materialsRequestModel: request,
    );
  }

  @override
  void initState() {
    super.initState();

    context.read<MaterialsCubit>().getMaterials(
      getMaterialsParams: GetMaterialsParams(
        classroomId: widget._classroomModel.classroomId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MaterialsCubit, MaterialsState>(
      listener: (BuildContext context, MaterialsState state) {
        if (state.uploadMaterialsStatus == CubitStatus.loading ||
            state.getMaterialsStatus == CubitStatus.loading) {
          AppDialogHelper.display(context, const AppCustomLoading());
        }

        if (state.uploadMaterialsStatus == CubitStatus.success) {
          AppNavigator.pop(context: context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("تم رفع الملف بنجاح"),
            ),
          );
        }

        if (state.uploadMaterialsStatus == CubitStatus.error ||
            state.getMaterialsStatus == CubitStatus.error) {
          AppNavigator.pop(context: context);
          AppDialogHelper.display(
            context,
            AppErrorDialog(
              apiErrorModel: state.apiErrorModel!,
              onRetry: () {},
            ),
          );
        }
      },
      child: Scaffold(
        appBar: const CustomAppBar(title: "المواد الدراسية"),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.s24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'اسم الفصل الدراسي:',
                  style: context.textTheme.headlineMedium,
                ),
                const SizedBox(height: AppSizes.s8),
                Text(
                  widget._classroomModel.name,
                  style: context.textTheme.headlineSmall,
                ),
                const SizedBox(height: AppSizes.s20),
                AppCardContainerEmpty(
                  children: [
                    Text(
                      _fileNameSelected,
                    ),
                    const SizedBox(height: AppSizes.s12),
                    AppElevatedButton(
                      onPressed: () {
                        _pickFile();
                      },
                      label: "اختر ملف",
                    ),
                    const SizedBox(height: AppSizes.s20),
                    AppElevatedButton(
                      onPressed: _uploadFile,
                      label: "رفع الملف",
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.s12),
                const Divider(),
                const SizedBox(height: AppSizes.s12),

                BlocBuilder<MaterialsCubit, MaterialsState>(
                  builder: (BuildContext context, MaterialsState state) {
                    if (state.getMaterialsStatus != CubitStatus.success) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final materials =
                        state.teacherMaterialPagedResultModel!.items;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "جميع الملفات",
                          style: context.textTheme.labelLarge,
                        ),
                        const SizedBox(height: AppSizes.s12),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final material = materials[index];
                            return AppCardContainerInfo(
                              icon: Icons.book_outlined,
                              title: material.title,
                              subtitle: material.materialType,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: AppSizes.s8);
                          },
                          itemCount: materials.length,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
