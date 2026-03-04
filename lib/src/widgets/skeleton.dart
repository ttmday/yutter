import "package:flutter/material.dart";
import "package:yutter/src/constants/color.dart";

class Skeleton extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Color startColor;
  final Color endColor;
  final Duration duration;

  const Skeleton({
    super.key,
    this.width = double.infinity,
    this.height = 20.0,
    this.borderRadius = 8.0,
    this.startColor = AppColors.accent,
    this.endColor = AppColors.accent,
    this.duration = const Duration(milliseconds: 1600),
  });

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: widget.startColor.withValues(alpha: .15),
      end: widget.endColor.withValues(alpha: .9),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: _colorAnimation.value,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        );
      },
    );
  }
}
