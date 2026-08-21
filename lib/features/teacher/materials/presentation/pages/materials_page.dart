import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/enums/material_type_enum.dart";
import "package:draya_mobile/core/helpers/app_dialog_helper.dart";
import "package:draya_mobile/core/helpers/app_loading.dart";
import "package:draya_mobile/core/helpers/app_navigator.dart";
import "package:draya_mobile/core/helpers/app_url_helper.dart";
import "package:draya_mobile/core/router/app_routes.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/core/widgets/app_error_dialog.dart";
import "package:draya_mobile/core/widgets/custom_app_bar.dart";
import "package:draya_mobile/features/student/student_materials/presentation/pages/material_viewer_screen.dart";
import "package:draya_mobile/features/teacher/materials/data/models/materials_request_model.dart";
import "package:draya_mobile/features/teacher/materials/domain/usecases/get_materials_use_case.dart";
import "package:draya_mobile/features/teacher/materials/presentation/cubit/materials_cubit.dart";
import "package:draya_mobile/features/teacher/materials/presentation/cubit/materials_state.dart";
import "package:draya_mobile/features/teacher/sections/data/models/section_document_model.dart";
import "package:draya_mobile/features/teacher/sections/data/models/section_exam_model.dart";
import "package:draya_mobile/features/teacher/sections/data/models/section_model.dart";
import "package:draya_mobile/features/teacher/sections/data/models/section_video_model.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";

class MaterialsPage extends StatefulWidget {
  final String _classroomId;
  final SectionModel _sectionModel;
  const MaterialsPage(this._classroomId, this._sectionModel, {super.key});

  @override
  State<MaterialsPage> createState() => _MaterialsPageState();
}

class _MaterialsPageState extends State<MaterialsPage> {
  PlatformFile? _selectedFile;
  bool _isUploading = false;

  // Track expanded state for categories
  bool _docsExpanded = true;
  bool _videosExpanded = true;
  bool _examsExpanded = true;

  @override
  void initState() {
    super.initState();
    _loadMaterials();
  }

  void _loadMaterials() {
    context.read<MaterialsCubit>().getMaterials(
          getMaterialsParams: GetMaterialsParams(
            classroomId: widget._classroomId,
            sectionId: widget._sectionModel.id,
          ),
        );
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ["pdf", "mp4", "mov", "doc", "docx", "ppt", "pptx"],
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.single;
    setState(() {
      _selectedFile = file;
    });
  }

  Future<void> _uploadFile() async {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.error,
          content: Text(
            "يرجى اختيار ملف أولاً",
            style: AppTextStyles.body.copyWith(color: Colors.white),
          ),
        ),
      );
      return;
    }

    if (_selectedFile!.path == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.error,
          content: Text(
            "تعذر الوصول إلى مسار الملف",
            style: AppTextStyles.body.copyWith(color: Colors.white),
          ),
        ),
      );
      return;
    }

    setState(() => _isUploading = true);

    final fileName = _selectedFile!.name;
    final title = fileName.contains(".")
        ? fileName.substring(0, fileName.lastIndexOf("."))
        : fileName;

    final materialType =
        fileName.contains(".") ? fileName.split(".").last : "";

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

  void _downloadFile(String? fileUrl) {
    if (fileUrl != null && fileUrl.trim().isNotEmpty) {
      AppUrlHelper.launchURL(fileUrl.trim(), context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.error,
          content: Text(
            "رابط التحميل غير متوفر لهذا الملف",
            style: AppTextStyles.body.copyWith(color: Colors.white),
          ),
        ),
      );
    }
  }

  void _openDocumentInViewer(
    SectionDocumentModel document,
    SectionModel section,
  ) {
    final fileUrl = document.fileUrl;
    if (fileUrl != null && fileUrl.isNotEmpty) {
      final isPdf = document.materialType.toLowerCase().contains("pdf") ||
          fileUrl.toLowerCase().endsWith(".pdf");

      if (isPdf) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => StudentMaterialsViewerScreen(
              initialItem: ViewerMaterialItem(
                id: document.id,
                title: document.title,
                isVideo: false,
                isPdf: true,
                directUrl: fileUrl,
                sectionTitle: section.title,
              ),
              initialUrl: fileUrl,
            ),
          ),
        );
      } else {
        AppUrlHelper.launchURL(fileUrl, context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.error,
          content: Text(
            "رابط الملف غير متاح للعرض حالياً",
            style: AppTextStyles.body.copyWith(color: Colors.white),
          ),
        ),
      );
    }
  }

  void _openVideoInViewer(
    SectionVideoModel video,
    SectionModel section,
  ) {
    final videoUrl = video.videoUrl;
    if (videoUrl != null && videoUrl.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => StudentMaterialsViewerScreen(
            initialItem: ViewerMaterialItem(
              id: video.id,
              title: video.title,
              isVideo: true,
              isPdf: false,
              directUrl: videoUrl,
              sectionTitle: section.title,
            ),
            initialUrl: videoUrl,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.error,
          content: Text(
            "رابط تشغيل الفيديو غير متاح حالياً",
            style: AppTextStyles.body.copyWith(color: Colors.white),
          ),
        ),
      );
    }
  }

  void _previewAsStudent() {
    AppNavigator.push(
      context: context,
      path: AppRoutes.studentClassroomMaterialsPage(widget._classroomId),
      extra: widget._sectionModel.title,
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return "$bytes B";
    if (bytes < 1024 * 1024) {
      return "${(bytes / 1024).toStringAsFixed(1)} KB";
    }
    return "${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB";
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MaterialsCubit, MaterialsState>(
      listener: (BuildContext context, MaterialsState state) {
        if (state.uploadMaterialsStatus == CubitStatus.loading) {
          AppLoading.show();
        }

        if (state.uploadMaterialsStatus == CubitStatus.success) {
          AppLoading.hide();
          setState(() {
            _isUploading = false;
            _selectedFile = null;
          });

          _loadMaterials();

          ScaffoldMessenger.of(context).showSnackBar(
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
                  Text("تم رفع المادة التعليمية بنجاح",
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          );
        }

        if (state.uploadMaterialsStatus == CubitStatus.error ||
            state.getMaterialsStatus == CubitStatus.error) {
          AppLoading.hide();
          setState(() => _isUploading = false);
          if (state.apiErrorModel != null) {
            AppDialogHelper.display(
              context,
              AppErrorDialog(apiErrorModel: state.apiErrorModel!),
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const CustomAppBar(title: "المواد التعليمية"),
        body: SafeArea(
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async => _loadMaterials(),
            child: BlocBuilder<MaterialsCubit, MaterialsState>(
              builder: (context, state) {
                final section = state.sectionModel ?? widget._sectionModel;
                final documents = section.documents;
                final videos = section.videos;
                final exams = section.exams;
                final totalCount =
                    documents.length + videos.length + exams.length;

                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.s16,
                    AppSizes.s16,
                    AppSizes.s16,
                    AppSizes.s36,
                  ),
                  children: [
                    // Hero Header
                    _MaterialsHeroHeader(
                      sectionTitle: section.title,
                      description: section.description,
                      docsCount: documents.length,
                      videosCount: videos.length,
                      examsCount: exams.length,
                      onPreviewAsStudent: _previewAsStudent,
                    ),
                    const SizedBox(height: AppSizes.s16),

                    // Modern Upload Dropzone Card
                    _UploadZoneCard(
                      selectedFile: _selectedFile,
                      isUploading: _isUploading,
                      formatFileSize: _formatFileSize,
                      onPickFile: _pickFile,
                      onUploadFile: _uploadFile,
                      onClearFile: () => setState(() => _selectedFile = null),
                    ),
                    const SizedBox(height: AppSizes.s20),

                    // Section Materials Title
                    Row(
                      children: [
                        Text(
                          "محتويات القسم المرفوعة",
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
                            "$totalCount مادة",
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

                    if (state.getMaterialsStatus == CubitStatus.loading &&
                        state.sectionModel == null)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      )
                    else ...[
                      // 1. Documents Category
                      _ExpandableCategorySection(
                        title: "المستندات والملفات",
                        subtitle: "${documents.length} ملف متوفر",
                        icon: Icons.picture_as_pdf_rounded,
                        color: AppColors.error,
                        count: documents.length,
                        isExpanded: _docsExpanded,
                        onToggle: () =>
                            setState(() => _docsExpanded = !_docsExpanded),
                        children: documents.isEmpty
                            ? [
                                const _EmptyCategoryPlaceholder(
                                  text: "لم يتم رفع أي مستندات في هذا القسم بعد",
                                )
                              ]
                            : documents.map((doc) {
                                return _DocumentItemTile(
                                  document: doc,
                                  onPreview: () =>
                                      _openDocumentInViewer(doc, section),
                                  onDownload: () => _downloadFile(doc.fileUrl),
                                );
                              }).toList(),
                      ),
                      const SizedBox(height: AppSizes.s12),

                      // 2. Videos Category
                      _ExpandableCategorySection(
                        title: "الفيديوهات والمحاضرات",
                        subtitle: "${videos.length} فيديو متوفر",
                        icon: Icons.play_circle_filled_rounded,
                        color: AppColors.ai700,
                        count: videos.length,
                        isExpanded: _videosExpanded,
                        onToggle: () =>
                            setState(() => _videosExpanded = !_videosExpanded),
                        children: videos.isEmpty
                            ? [
                                const _EmptyCategoryPlaceholder(
                                  text: "لم يتم إضافة أي فيديوهات في هذا القسم بعد",
                                )
                              ]
                            : videos.map((video) {
                                return _VideoItemTile(
                                  video: video,
                                  onWatch: () =>
                                      _openVideoInViewer(video, section),
                                );
                              }).toList(),
                      ),
                      const SizedBox(height: AppSizes.s12),

                      // 3. Exams Category
                      _ExpandableCategorySection(
                        title: "الاختبارات والتقييمات",
                        subtitle: "${exams.length} اختبار متوفر",
                        icon: Icons.quiz_rounded,
                        color: AppColors.amber,
                        count: exams.length,
                        isExpanded: _examsExpanded,
                        onToggle: () =>
                            setState(() => _examsExpanded = !_examsExpanded),
                        children: exams.isEmpty
                            ? [
                                const _EmptyCategoryPlaceholder(
                                  text: "لا توجد اختبارات في هذا القسم حالياً",
                                )
                              ]
                            : exams.map((exam) {
                                return _ExamItemTile(exam: exam);
                              }).toList(),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Materials Hero Header
// ---------------------------------------------------------------------------
class _MaterialsHeroHeader extends StatelessWidget {
  final String sectionTitle;
  final String description;
  final int docsCount;
  final int videosCount;
  final int examsCount;
  final VoidCallback onPreviewAsStudent;

  const _MaterialsHeroHeader({
    required this.sectionTitle,
    required this.description,
    required this.docsCount,
    required this.videosCount,
    required this.examsCount,
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
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.folder_special_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sectionTitle,
                      style: AppTextStyles.h4.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (description.trim().isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        description.trim(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Badges and Preview CTA Row
          Row(
            children: [
              // Count Badges
              Expanded(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _HeaderBadge(
                      icon: Icons.picture_as_pdf_rounded,
                      text: "$docsCount ملف",
                    ),
                    _HeaderBadge(
                      icon: Icons.play_circle_filled_rounded,
                      text: "$videosCount فيديو",
                    ),
                    _HeaderBadge(
                      icon: Icons.quiz_rounded,
                      text: "$examsCount اختبار",
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // View as Student CTA
              SizedBox(
                height: 36,
                child: ElevatedButton.icon(
                  onPressed: onPreviewAsStudent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary800,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.visibility_outlined, size: 16),
                  label: Text(
                    "معاينة كطالب",
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.primary800,
                      fontWeight: FontWeight.w800,
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

class _HeaderBadge extends StatelessWidget {
  final IconData icon;
  final String text;

  const _HeaderBadge({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTextStyles.label.copyWith(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Modern Upload Zone Card
// ---------------------------------------------------------------------------
class _UploadZoneCard extends StatelessWidget {
  final PlatformFile? selectedFile;
  final bool isUploading;
  final String Function(int bytes) formatFileSize;
  final VoidCallback onPickFile;
  final VoidCallback onUploadFile;
  final VoidCallback onClearFile;

  const _UploadZoneCard({
    required this.selectedFile,
    required this.isUploading,
    required this.formatFileSize,
    required this.onPickFile,
    required this.onUploadFile,
    required this.onClearFile,
  });

  @override
  Widget build(BuildContext context) {
    final hasFile = selectedFile != null;
    final fileName = selectedFile?.name ?? "";
    final extension =
        fileName.contains(".") ? fileName.split(".").last.toUpperCase() : "FILE";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: hasFile ? AppColors.primary300 : AppColors.border,
          width: hasFile ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.cloud_upload_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "رفع مادة تعليمية جديدة",
                style: AppTextStyles.h5.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Upload Selection Area
          if (!hasFile)
            InkWell(
              onTap: onPickFile,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.backgroundSecondary,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary200,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.file_upload_outlined,
                      size: 32,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "اضغط لاختيار ملف من جهازك",
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.primary700,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "يدعم ملفات PDF، الفيديوهات MP4، والمستندات Word/PPT",
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            // Selected File Preview
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary200),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      extension,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fileName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.label.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            fontSize: 13,
                          ),
                        ),
                        if (selectedFile!.size > 0)
                          Text(
                            formatFileSize(selectedFile!.size),
                            style: AppTextStyles.label.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onClearFile,
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: AppColors.error,
                    ),
                    tooltip: "إلغاء الملف",
                  ),
                ],
              ),
            ),
          const SizedBox(height: 14),

          // Upload Action Button
          SizedBox(
            height: 42,
            child: ElevatedButton.icon(
              onPressed: !hasFile || isUploading ? null : onUploadFile,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: isUploading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.arrow_upward_rounded, size: 18),
              label: Text(
                isUploading ? "جاري رفع الملف..." : "رفع المادة التعليمية",
                style: AppTextStyles.button.copyWith(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Expandable Category Section
// ---------------------------------------------------------------------------
class _ExpandableCategorySection extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final int count;
  final bool isExpanded;
  final VoidCallback onToggle;
  final List<Widget> children;

  const _ExpandableCategorySection({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.count,
    required this.isExpanded,
    required this.onToggle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpanded ? color.withValues(alpha: 0.35) : AppColors.border,
          width: isExpanded ? 1.3 : 1.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: onToggle,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: color, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppTextStyles.h5.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            subtitle,
                            style: AppTextStyles.label.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        "$count",
                        style: AppTextStyles.label.copyWith(
                          color: color,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: AppColors.foregroundMuted,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            if (isExpanded) ...[
              const Divider(color: AppColors.border, height: 1),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Document Item Tile
// ---------------------------------------------------------------------------
class _DocumentItemTile extends StatelessWidget {
  final SectionDocumentModel document;
  final VoidCallback onPreview;
  final VoidCallback onDownload;

  const _DocumentItemTile({
    required this.document,
    required this.onPreview,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat("d MMM yyyy", "ar");
    final dateStr = dateFormat.format(document.createdAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.picture_as_pdf_rounded,
              color: AppColors.error,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.label.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "${document.materialType} • $dateStr",
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          // Download Action
          if (document.fileUrl != null && document.fileUrl!.isNotEmpty) ...[
            IconButton(
              onPressed: onDownload,
              iconSize: 18,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              tooltip: "تحميل الملف",
              icon: const Icon(
                Icons.download_rounded,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 4),
          ],
          // View in Student Viewer Action
          SizedBox(
            height: 32,
            child: ElevatedButton.icon(
              onPressed: onPreview,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.visibility_outlined, size: 14),
              label: Text(
                "معاينة",
                style: AppTextStyles.label.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 11.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Video Item Tile
// ---------------------------------------------------------------------------
class _VideoItemTile extends StatelessWidget {
  final SectionVideoModel video;
  final VoidCallback onWatch;

  const _VideoItemTile({
    required this.video,
    required this.onWatch,
  });

  String _formatDuration(int seconds) {
    if (seconds <= 0) return "";
    final minutes = seconds ~/ 60;
    final remainingSecs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSecs.toString().padLeft(2, '0')} دقيقة';
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat("d MMM yyyy", "ar");
    final dateStr = dateFormat.format(video.createdAt);
    final durationStr = _formatDuration(video.videoDurationInSeconds);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.ai700.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.play_circle_filled_rounded,
              color: AppColors.ai700,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.label.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  durationStr.isNotEmpty
                      ? "$durationStr • $dateStr"
                      : "فيديو • $dateStr",
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          // Watch in Student Video Player Action
          SizedBox(
            height: 32,
            child: ElevatedButton.icon(
              onPressed: onWatch,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.ai700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.play_arrow_rounded, size: 16),
              label: Text(
                "مشاهدة",
                style: AppTextStyles.label.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 11.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Exam Item Tile
// ---------------------------------------------------------------------------
class _ExamItemTile extends StatelessWidget {
  final SectionExamModel exam;

  const _ExamItemTile({required this.exam});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat("d MMM yyyy", "ar");
    final dateStr = dateFormat.format(exam.createdAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.amber.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.quiz_rounded,
              color: AppColors.amber,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exam.topic,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.label.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "${exam.questionsCount} سؤال • $dateStr",
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.amber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              "اختبار",
              style: AppTextStyles.label.copyWith(
                color: AppColors.amber,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCategoryPlaceholder extends StatelessWidget {
  final String text;

  const _EmptyCategoryPlaceholder({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Center(
        child: Text(
          text,
          style: AppTextStyles.body.copyWith(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
