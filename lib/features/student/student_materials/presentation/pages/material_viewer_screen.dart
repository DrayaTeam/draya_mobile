import 'package:chewie/chewie.dart';
import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:video_player/video_player.dart';

class PdfMaterialViewerScreen extends StatelessWidget {
  final String title;
  final String pdfUrl;

  const PdfMaterialViewerScreen({
    super.key,
    required this.title,
    required this.pdfUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundMuted,
      appBar: AppBar(title: Text(title)),
      body: PdfViewer.uri(
        Uri.parse(pdfUrl),
        params: const PdfViewerParams(
          backgroundColor: AppColors.backgroundMuted,
        ),
      ),
    );
  }
}

class VideoMaterialViewerScreen extends StatefulWidget {
  final String title;
  final String streamUrl;

  const VideoMaterialViewerScreen({
    super.key,
    required this.title,
    required this.streamUrl,
  });

  @override
  State<VideoMaterialViewerScreen> createState() =>
      _VideoMaterialViewerScreenState();
}

class _VideoMaterialViewerScreenState extends State<VideoMaterialViewerScreen> {
  late final VideoPlayerController _videoController;
  ChewieController? _chewieController;
  Object? _initializationError;

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
    } catch (error) {
      if (mounted) setState(() => _initializationError = error);
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: _initializationError != null
            ? const Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'تعذر تشغيل الفيديو. حاول مرة أخرى لاحقاً.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              )
            : _chewieController == null
                ? const CircularProgressIndicator(color: Colors.white)
                : AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: Chewie(controller: _chewieController!),
                  ),
      ),
    );
  }
}
