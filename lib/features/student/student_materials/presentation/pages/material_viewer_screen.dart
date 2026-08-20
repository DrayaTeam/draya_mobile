import "package:chewie/chewie.dart";
import "package:draya_mobile/core/helpers/app_token_helper.dart";
import "package:draya_mobile/core/helpers/app_url_helper.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/features/student/student_materials/domain/entity/classroom_section.dart";
import "package:draya_mobile/features/student/student_materials/domain/entity/student_material.dart";
import "package:flutter/material.dart";
import "package:pdfrx/pdfrx.dart";
import "package:video_player/video_player.dart";

class ViewerMaterialItem {
  final String id;
  final String title;
  final bool isVideo;
  final bool isPdf;
  final String? directUrl;
  final String? sectionTitle;

  const ViewerMaterialItem({
    required this.id,
    required this.title,
    required this.isVideo,
    required this.isPdf,
    this.directUrl,
    this.sectionTitle,
  });

  factory ViewerMaterialItem.fromStudentMaterial(StudentMaterial material) {
    return ViewerMaterialItem(
      id: material.materialId,
      title: material.title,
      isVideo: material.isVideo,
      isPdf: material.isPdf,
      directUrl: material.currentVersion.fileUrl,
    );
  }

  factory ViewerMaterialItem.fromSectionDocument(
    SectionDocument doc, {
    String? sectionTitle,
  }) {
    return ViewerMaterialItem(
      id: doc.id,
      title: doc.title,
      isVideo: false,
      isPdf: doc.isPdf,
      directUrl: doc.fileUrl,
      sectionTitle: sectionTitle,
    );
  }

  factory ViewerMaterialItem.fromSectionVideo(
    SectionVideo vid, {
    String? sectionTitle,
  }) {
    return ViewerMaterialItem(
      id: vid.id,
      title: vid.title,
      isVideo: true,
      isPdf: false,
      directUrl: vid.videoUrl,
      sectionTitle: sectionTitle,
    );
  }
}

class StudentMaterialsViewerScreen extends StatefulWidget {
  final ViewerMaterialItem? initialItem;
  final StudentMaterial? initialMaterial;
  final String initialUrl;
  final List<StudentMaterial> materials;
  final List<ClassroomSection> sections;
  final Future<String?> Function(StudentMaterial material)? resolveMaterialUrl;
  final Future<String?> Function(String materialId, bool isVideo)? resolveItemUrl;

  const StudentMaterialsViewerScreen({
    super.key,
    this.initialItem,
    this.initialMaterial,
    required this.initialUrl,
    this.materials = const [],
    this.sections = const [],
    this.resolveMaterialUrl,
    this.resolveItemUrl,
  });

  @override
  State<StudentMaterialsViewerScreen> createState() =>
      _StudentMaterialsViewerScreenState();
}

class _StudentMaterialsViewerScreenState
    extends State<StudentMaterialsViewerScreen> {
  late ViewerMaterialItem _selectedItem;
  late String _selectedUrl;
  bool _isLoadingMaterial = false;
  bool _hasLoadingError = false;
  String? _accessToken;
  bool _isLoadingAccessToken = true;

  // Map to track expanded state of each section
  final Map<String, bool> _expandedSections = {};

  @override
  void initState() {
    super.initState();
    if (widget.initialItem != null) {
      _selectedItem = widget.initialItem!;
    } else if (widget.initialMaterial != null) {
      _selectedItem =
          ViewerMaterialItem.fromStudentMaterial(widget.initialMaterial!);
    } else {
      _selectedItem = const ViewerMaterialItem(
        id: "",
        title: "المادة التعليمية",
        isVideo: false,
        isPdf: true,
      );
    }
    _selectedUrl = widget.initialUrl;

    // By default, expand all sections with items
    for (final section in widget.sections) {
      _expandedSections[section.id] = true;
    }

    _loadAccessToken();
  }

  Future<void> _loadAccessToken() async {
    final token = await AppTokenHelper.getAccessToken();
    if (!mounted) return;
    setState(() {
      _accessToken = token;
      _isLoadingAccessToken = false;
    });
  }

  Future<void> _selectItem(ViewerMaterialItem item) async {
    if (_isLoadingMaterial || item.id == _selectedItem.id) {
      return;
    }

    setState(() {
      _selectedItem = item;
      _isLoadingMaterial = true;
      _hasLoadingError = false;
    });

    String? url;
    if (item.directUrl != null && item.directUrl!.isNotEmpty) {
      url = item.directUrl;
    } else if (widget.resolveItemUrl != null) {
      url = await widget.resolveItemUrl!(item.id, item.isVideo);
    } else if (widget.resolveMaterialUrl != null && widget.materials.isNotEmpty) {
      final match = widget.materials
          .where((m) => m.materialId == item.id)
          .firstOrNull;
      if (match != null) {
        url = await widget.resolveMaterialUrl!(match);
      }
    }

    if (!mounted) return;

    setState(() {
      _isLoadingMaterial = false;
      _hasLoadingError = url == null;
      if (url != null) _selectedUrl = url;
    });
  }

  void _downloadCurrentMaterial() {
    final downloadUrl = _selectedItem.directUrl != null &&
            _selectedItem.directUrl!.isNotEmpty
        ? _selectedItem.directUrl!
        : _selectedUrl;
    AppUrlHelper.launchURL(downloadUrl, context);
  }

  int get _totalViewableCount {
    if (widget.sections.isNotEmpty) {
      return widget.sections.fold<int>(
        0,
        (sum, s) =>
            sum +
            s.documents.where((d) => d.isPdf).length +
            s.videos.length,
      );
    }
    return widget.materials
        .where(
          (material) =>
              material.currentVersion.isReady &&
              (material.isVideo || material.isPdf),
        )
        .length;
  }

  @override
  Widget build(BuildContext context) {
    final hasDownload = !_selectedItem.isVideo &&
        ((_selectedItem.directUrl != null &&
                _selectedItem.directUrl!.isNotEmpty) ||
            _selectedUrl.isNotEmpty);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: false,
        title: Text(
          _selectedItem.title,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.h5.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          if (hasDownload)
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.primary200),
                ),
                child: const Icon(
                  Icons.download_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              tooltip: "تحميل المادة",
              onPressed: _downloadCurrentMaterial,
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: (constraints.maxHeight * 0.44).clamp(180.0, 320.0),
                child: _buildViewer(),
              ),
              const Divider(color: AppColors.border, height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primary50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.primary200),
                      ),
                      child: const Icon(
                        Icons.collections_bookmark_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "محتوى الفصل الدراسي:",
                      style: AppTextStyles.h5.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "$_totalViewableCount مادة",
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: widget.sections.isNotEmpty
                    ? _buildSectionsList()
                    : _buildFlatMaterialsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionsList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: widget.sections.length,
      itemBuilder: (context, index) {
        final section = widget.sections[index];
        final viewableDocs = section.documents.where((d) => d.isPdf).toList();
        final viewableVideos = section.videos;
        final totalSectionViewable = viewableDocs.length + viewableVideos.length;

        if (totalSectionViewable == 0) return const SizedBox.shrink();

        final isExpanded = _expandedSections[section.id] ?? true;

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _expandedSections[section.id] = !isExpanded;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.folder_special_outlined,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            section.title,
                            style: AppTextStyles.label.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "$totalSectionViewable",
                            style: AppTextStyles.label.copyWith(
                              color: AppColors.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
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
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        ...viewableDocs.map((doc) {
                          final item = ViewerMaterialItem.fromSectionDocument(
                            doc,
                            sectionTitle: section.title,
                          );
                          return _buildItemRow(item);
                        }),
                        ...viewableVideos.map((vid) {
                          final item = ViewerMaterialItem.fromSectionVideo(
                            vid,
                            sectionTitle: section.title,
                          );
                          return _buildItemRow(item);
                        }),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFlatMaterialsList() {
    final viewableMaterials = widget.materials
        .where(
          (m) => m.currentVersion.isReady && (m.isVideo || m.isPdf),
        )
        .toList();

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: viewableMaterials.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final material = viewableMaterials[index];
        final item = ViewerMaterialItem.fromStudentMaterial(material);
        return _buildItemRow(item);
      },
    );
  }

  Widget _buildItemRow(ViewerMaterialItem item) {
    final isSelected = item.id == _selectedItem.id;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: isSelected ? AppColors.primary50 : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _selectItem(item),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: isSelected ? 1.5 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: (item.isVideo ? AppColors.ai700 : AppColors.error)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    item.isVideo
                        ? Icons.play_circle_fill_rounded
                        : Icons.picture_as_pdf_rounded,
                    color: item.isVideo ? AppColors.ai700 : AppColors.error,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(
                      color: isSelected
                          ? AppColors.primary700
                          : AppColors.textPrimary,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.primary,
                    size: 18,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildViewer() {
    if (_isLoadingMaterial) {
      return const ColoredBox(
        color: Colors.black,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }
    if (_hasLoadingError) {
      return ColoredBox(
        color: AppColors.backgroundSecondary,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.error,
                  size: 36,
                ),
                const SizedBox(height: 8),
                Text(
                  "تعذر فتح هذه المادة حالياً.",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    if (!_selectedItem.isVideo && _isLoadingAccessToken) {
      return const ColoredBox(
        color: AppColors.backgroundSecondary,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }
    if (!_selectedItem.isVideo &&
        (_accessToken == null || _accessToken!.isEmpty)) {
      return ColoredBox(
        color: AppColors.backgroundSecondary,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              "انتهت جلستك. يرجى تسجيل الدخول مجدداً.",
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      );
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: _selectedItem.isVideo
          ? _VideoPlayer(
              key: ValueKey(_selectedUrl),
              streamUrl: _selectedUrl,
            )
          : PdfViewer.uri(
              Uri.parse(_selectedUrl),
              key: ValueKey(_selectedUrl),
              headers: {"Authorization": "Bearer $_accessToken"},
              params: const PdfViewerParams(
                backgroundColor: AppColors.backgroundSecondary,
              ),
            ),
    );
  }
}

class _VideoPlayer extends StatefulWidget {
  final String streamUrl;

  const _VideoPlayer({super.key, required this.streamUrl});

  @override
  State<_VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<_VideoPlayer> {
  late final VideoPlayerController _videoController;
  ChewieController? _chewieController;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(widget.streamUrl),
    );
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      await _videoController.initialize();
      if (!mounted) return;
      setState(() {
        _chewieController = ChewieController(
          videoPlayerController: _videoController,
          autoPlay: true,
          allowFullScreen: true,
          allowMuting: true,
          showControls: true,
          materialProgressColors: ChewieProgressColors(
            playedColor: AppColors.primary,
            handleColor: AppColors.primary,
            backgroundColor: AppColors.borderStrong,
            bufferedColor: AppColors.primary200,
          ),
        );
      });
    } catch (_) {
      if (mounted) setState(() => _hasError = true);
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return const ColoredBox(
        color: Colors.black,
        child: Center(
          child: Text(
            "Unable to play this video.",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
    if (_chewieController == null) {
      return const ColoredBox(
        color: Colors.black,
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }
    return ColoredBox(
      color: Colors.black,
      child: Center(child: Chewie(controller: _chewieController!)),
    );
  }
}
