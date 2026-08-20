import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/enums/material_type_enum.dart";
import "package:draya_mobile/core/helpers/app_dialog_helper.dart";
import "package:draya_mobile/core/helpers/app_extensions.dart";
import "package:draya_mobile/core/helpers/app_navigator.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/widgets/app_card_container_empty.dart";
import "package:draya_mobile/core/widgets/app_custom_loading.dart";
import "package:draya_mobile/core/widgets/app_elevated_button.dart";
import "package:draya_mobile/core/widgets/app_error_dialog.dart";
import "package:draya_mobile/core/widgets/custom_app_bar.dart";
import "package:draya_mobile/features/teacher/materials/data/models/materials_request_model.dart";
import "package:draya_mobile/features/teacher/materials/domain/usecases/get_materials_use_case.dart";
import "package:draya_mobile/features/teacher/materials/presentation/cubit/materials_cubit.dart";
import "package:draya_mobile/features/teacher/materials/presentation/cubit/materials_state.dart";
import "package:draya_mobile/features/teacher/sections/data/models/section_document_model.dart";
import "package:draya_mobile/features/teacher/sections/data/models/section_exam_model.dart";
import "package:draya_mobile/features/teacher/sections/data/models/section_model.dart";
import "package:draya_mobile/features/teacher/sections/data/models/section_video_model.dart";
import "package:draya_mobile/features/teacher/sections/presentation/widgets/app_expandable_category_card.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class MaterialsPage extends StatefulWidget {
  final String _classroomId;
  final SectionModel _sectionModel;
  const MaterialsPage(this._classroomId, this._sectionModel, {super.key});

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
      sectionId: widget._sectionModel.id,
      title: title,
      materialType: MaterialTypeEnum.fromExtension(extension: materialType),
      file: _selectedFile!,
    );

    await context.read<MaterialsCubit>().uploadMaterials(
      sectionId: widget._sectionModel.id,
      materialsRequestModel: request,
    );
  }

  @override
  void initState() {
    super.initState();

    context.read<MaterialsCubit>().getMaterials(
      getMaterialsParams: GetMaterialsParams(
        classroomId: widget._classroomId,
        sectionId: widget._sectionModel.id,
      ),
    );
  }

  Widget _buildDocumentCard(
    BuildContext context,
    SectionDocumentModel document,
  ) {
    return AppCardContainerEmpty(
      children: [
        Row(
          children: [
            const Icon(Icons.insert_drive_file_outlined),
            const SizedBox(width: AppSizes.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSizes.s8),
                  Text(
                    document.materialType,
                    style: context.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              style: IconButton.styleFrom(
                foregroundColor: Colors.red.shade400,
                backgroundColor: Colors.red.withValues(
                  alpha: 0.08,
                ),
              ),
              icon: const Icon(
                Icons.delete_outline,
                size: 21,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVideoCard(
    BuildContext context,
    SectionVideoModel video,
  ) {
    return AppCardContainerEmpty(
      children: [
        Row(
          children: [
            const Icon(Icons.play_circle_outline),
            const SizedBox(width: AppSizes.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSizes.s8),
                  Text(
                    video.materialType,
                    style: context.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSizes.s4),
                  Text(
                    _formatDuration(video.videoDurationInSeconds),
                    style: context.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              style: IconButton.styleFrom(
                foregroundColor: Colors.red.shade400,
                backgroundColor: Colors.red.withValues(
                  alpha: 0.08,
                ),
              ),
              icon: const Icon(
                Icons.delete_outline,
                size: 21,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final remainingSeconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return "$hours:${minutes.toString().padLeft(2, "0")}:${remainingSeconds.toString().padLeft(2, "0")}";
    }

    return "$minutes:${remainingSeconds.toString().padLeft(2, "0")}";
  }

  Widget _buildExamCard(
    BuildContext context,
    SectionExamModel exam,
  ) {
    return AppCardContainerEmpty(
      children: [
        Row(
          children: [
            const Icon(Icons.quiz_outlined),
            const SizedBox(width: AppSizes.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exam.topic,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSizes.s8),
                  Text(
                    "${exam.questionsCount} سؤال",
                    style: context.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              style: IconButton.styleFrom(
                foregroundColor: Colors.red.shade400,
                backgroundColor: Colors.red.withValues(
                  alpha: 0.08,
                ),
              ),
              icon: const Icon(
                Icons.delete_outline,
                size: 21,
              ),
            ),
          ],
        ),
      ],
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

          setState(() {
            _selectedFile = null;
            _fileNameSelected = "لا يوجد ملف";
          });

          context.read<MaterialsCubit>().getMaterials(
            getMaterialsParams: GetMaterialsParams(
              classroomId: widget._classroomId,
              sectionId: widget._sectionModel.id,
            ),
          );

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
                  "اسم القسم:",
                  style: context.textTheme.headlineMedium,
                ),
                const SizedBox(height: AppSizes.s8),
                Text(
                  widget._sectionModel.title,
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

                    final documents = state.sectionModel!.documents;
                    final videos = state.sectionModel!.videos;
                    final exams = state.sectionModel!.exams;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "جميع الملفات",
                          style: context.textTheme.labelLarge,
                        ),

                        const SizedBox(height: AppSizes.s12),

                        // Documents
                        AppExpandableCategoryCard(
                          label: "ملفات",
                          title: "المستندات",
                          subtitle: "${documents.length} ملف",
                          children: documents
                              .map(
                                (document) => Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: AppSizes.s8,
                                  ),
                                  child: _buildDocumentCard(
                                    context,
                                    document,
                                  ),
                                ),
                              )
                              .toList(),
                        ),

                        const SizedBox(height: AppSizes.s12),

                        // Videos
                        AppExpandableCategoryCard(
                          label: "فيديو",
                          title: "الفيديوهات",
                          subtitle: "${videos.length} فيديو",
                          children: videos
                              .map(
                                (video) => Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: AppSizes.s8,
                                  ),
                                  child: _buildVideoCard(
                                    context,
                                    video,
                                  ),
                                ),
                              )
                              .toList(),
                        ),

                        const SizedBox(height: AppSizes.s12),

                        // Exams
                        AppExpandableCategoryCard(
                          label: "اختبارات",
                          title: "الاختبارات",
                          subtitle: "${exams.length} اختبار",
                          children: exams
                              .map(
                                (exam) => Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: AppSizes.s8,
                                  ),
                                  child: _buildExamCard(
                                    context,
                                    exam,
                                  ),
                                ),
                              )
                              .toList(),
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
