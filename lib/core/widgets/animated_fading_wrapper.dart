import 'package:flutter/material.dart';

class AnimatedFadingWrapper extends StatefulWidget {
  final Widget child;
  const AnimatedFadingWrapper({super.key, required this.child});

  @override
  State<AnimatedFadingWrapper> createState() => _AnimatedFadingWrapperState();
}

class _AnimatedFadingWrapperState extends State<AnimatedFadingWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    const curve = Cubic(0.7, -0.4, 0.4, 1.4);
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: curve);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _fadeAnimation, child: widget.child);
  }
}
