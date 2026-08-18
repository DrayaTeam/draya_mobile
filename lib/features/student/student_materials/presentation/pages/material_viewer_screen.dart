import 'package:chewie/chewie.dart';
import 'package:draya_mobile/core/helpers/app_token_helper.dart';
import 'package:draya_mobile/core/helpers/app_url_helper.dart';
import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_text_styles.dart';
import 'package:draya_mobile/features/student/student_materials/domain/entity/student_material.dart';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:video_player/video_player.dart';

class StudentMaterialsViewerScreen extends StatefulWidget {
  final StudentMaterial initialMaterial;
  final String initialUrl;
  final List<StudentMaterial> materials;
  final Future<String?> Function(StudentMaterial material) resolveMaterialUrl;

  const StudentMaterialsViewerScreen({
    super.key,
    required this.initialMaterial,
    required this.initialUrl,
    required this.materials,
    required this.resolveMaterialUrl,
  });

  @override
  State<StudentMaterialsViewerScreen> createState() =>
      _StudentMaterialsViewerScreenState();
}

class _StudentMaterialsViewerScreenState
    extends State<StudentMaterialsViewerScreen> {
  late StudentMaterial _selectedMaterial;
  late String _selectedUrl;
  bool _isLoadingMaterial = false;
  bool _hasLoadingError = false;
  String? _accessToken;
  bool _isLoadingAccessToken = true;

  List<StudentMaterial> get _viewableMaterials => widget.materials
      .where(
        (material) =>
            material.currentVersion.isReady &&
            (material.isVideo || material.isPdf),
      )
      .toList();

  @override
  void initState() {
    super.initState();
    _selectedMaterial = widget.initialMaterial;
    _selectedUrl = widget.initialUrl;
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

  Future<void> _selectMaterial(StudentMaterial material) async {
    if (_isLoadingMaterial ||
        material.materialId == _selectedMaterial.materialId) {
      return;
    }

    setState(() {
      _selectedMaterial = material;
      _isLoadingMaterial = true;
      _hasLoadingError = false;
    });

    final url = await widget.resolveMaterialUrl(material);
    if (!mounted) return;

    setState(() {
      _isLoadingMaterial = false;
      _hasLoadingError = url == null;
      if (url != null) _selectedUrl = url;
    });
  }

  void _downloadCurrentMaterial() {
    final fileUrl = _selectedMaterial.currentVersion.fileUrl;
    final downloadUrl = (fileUrl != null && fileUrl.isNotEmpty)
        ? fileUrl
        : _selectedUrl;
    AppUrlHelper.launchURL(downloadUrl, context);
  }

  @override
  Widget build(BuildContext context) {
    final hasDownload =
        _selectedMaterial.currentVersion.isReady &&
        ((_selectedMaterial.currentVersion.fileUrl != null &&
                _selectedMaterial.currentVersion.fileUrl!.isNotEmpty) ||
            !_selectedMaterial.isVideo);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: false,
        title: Text(
          _selectedMaterial.title,
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
              tooltip: 'تحميل المادة',
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
                      'مواد الفصل الدراسي:',
                      style: AppTextStyles.h5.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${_viewableMaterials.length} مادة',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  itemCount: _viewableMaterials.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final material = _viewableMaterials[index];
                    final isSelected =
                        material.materialId == _selectedMaterial.materialId;
                    return Semantics(
                      button: true,
                      selected: isSelected,
                      label: 'Open ${material.title}',
                      child: Material(
                        color: isSelected
                            ? AppColors.primary50
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () => _selectMaterial(material),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.border,
                                width: isSelected ? 1.5 : 1,
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color:
                                        (material.isVideo
                                                ? AppColors.ai700
                                                : AppColors.error)
                                            .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    material.isVideo
                                        ? Icons.play_circle_fill_rounded
                                        : Icons.picture_as_pdf_rounded,
                                    color: material.isVideo
                                        ? AppColors.ai700
                                        : AppColors.error,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    material.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.body.copyWith(
                                      color: isSelected
                                          ? AppColors.primary700
                                          : AppColors.textPrimary,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
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
                  'تعذر فتح هذه المادة حالياً.',
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
    if (!_selectedMaterial.isVideo && _isLoadingAccessToken) {
      return const ColoredBox(
        color: AppColors.backgroundSecondary,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }
    if (!_selectedMaterial.isVideo &&
        (_accessToken == null || _accessToken!.isEmpty)) {
      return ColoredBox(
        color: AppColors.backgroundSecondary,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'انتهت جلستك. يرجى تسجيل الدخول مجدداً.',
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
      child: _selectedMaterial.isVideo
          ? _VideoPlayer(
              key: ValueKey(_selectedUrl),
              streamUrl: _selectedUrl,
            )
          : PdfViewer.uri(
              Uri.parse(_selectedUrl),
              key: ValueKey(_selectedUrl),
              headers: {'Authorization': 'Bearer $_accessToken'},
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
            'Unable to play this video.',
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
