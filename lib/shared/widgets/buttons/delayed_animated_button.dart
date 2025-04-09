import 'package:flutter/material.dart';

class DelayedAnimatedButton extends StatefulWidget {
  const DelayedAnimatedButton({
    super.key,
    required this.child,
    required this.delay,
  });
  final Widget child;
  final Duration delay;

  @override
  State<DelayedAnimatedButton> createState() => _DelayedAnimatedButtonState();
}

class _DelayedAnimatedButtonState extends State<DelayedAnimatedButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    Future<void>.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: FadeTransition(
        opacity: _animation,
        child: widget.child,
      ),
    );
  }
}
