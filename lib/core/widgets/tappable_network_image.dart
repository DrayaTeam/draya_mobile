import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";

/// Rounded network image that opens a zoomable fullscreen viewer when tapped.
class TappableNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BorderRadius borderRadius;
  final BoxFit fit;

  const TappableNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(14)),
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: "صورة مرفقة، اضغط للعرض بحجم كامل",
      button: true,
      child: GestureDetector(
        onTap: () => _openFullscreenViewer(context),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: SizedBox(
            width: width,
            height: height,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: "channel-image-$imageUrl",
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: fit,
                    fadeInDuration: const Duration(milliseconds: 250),
                    placeholder: (_, _) => Container(
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                    errorWidget: (_, _, _) => Container(
                      color: Colors.grey.shade100,
                      child: Icon(
                        Icons.broken_image_rounded,
                        color: Colors.grey.shade400,
                        size: 32,
                      ),
                    ),
                  ),
                ),
                PositionedDirectional(
                  top: 8,
                  end: 8,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.zoom_out_map_rounded,
                      size: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openFullscreenViewer(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (_, animation, _) => FadeTransition(
          opacity: animation.drive(
            CurveTween(curve: Curves.easeOutCubic),
          ),
          child: _FullscreenImageViewer(imageUrl: imageUrl),
        ),
        transitionDuration: const Duration(milliseconds: 220),
        reverseTransitionDuration: const Duration(milliseconds: 180),
      ),
    );
  }
}

class _FullscreenImageViewer extends StatefulWidget {
  final String imageUrl;

  const _FullscreenImageViewer({required this.imageUrl});

  @override
  State<_FullscreenImageViewer> createState() => _FullscreenImageViewerState();
}

class _FullscreenImageViewerState extends State<_FullscreenImageViewer> {
  final TransformationController _transformationController =
      TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            onDoubleTapDown: _handleDoubleTapDown,
            onDoubleTap: _handleDoubleTap,
            child: Center(
              child: Hero(
                tag: "channel-image-${widget.imageUrl}",
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  maxScale: 4,
                  minScale: 0.5,
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrl,
                    fit: BoxFit.contain,
                    placeholder: (_, _) => const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    errorWidget: (_, _, _) => const Icon(
                      Icons.broken_image_rounded,
                      size: 48,
                      color: Colors.white54,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: IconButton.filledTonal(
                  onPressed: () => Navigator.of(context).pop(),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white24,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.close_rounded),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    final zoomed = _transformationController.value.getMaxScaleOnAxis() > 1.05;
    if (zoomed) {
      _transformationController.value = Matrix4.identity();
      return;
    }
    _transformationController.value = Matrix4.identity()
      ..translateByDouble(
        -details.localPosition.dx * 1.5,
        -details.localPosition.dy * 1.5,
        0,
        1,
      )
      ..scaleByDouble(2.5, 2.5, 2.5, 1);
  }

  void _handleDoubleTap() {}
}
