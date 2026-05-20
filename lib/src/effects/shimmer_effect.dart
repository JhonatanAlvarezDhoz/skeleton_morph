import 'package:flutter/material.dart';

import '../core/skeleton_config.dart';
import '../core/skeleton_effect.dart';

/// Shimmer loading effect used by default.
///
/// Design pattern: Strategy.
/// The placeholder shape is provided by the widgets. This class only adds a
/// moving gradient on top of that shape.
class ShimmerEffect extends SkeletonEffect {
  const ShimmerEffect({
    this.direction = Axis.horizontal,
  });

  final Axis direction;

  @override
  Widget build(BuildContext context, Widget child) {
    final config = SkeletonConfig.of(context);

    return _ShimmerEffectView(
      config: config,
      direction: direction,
      child: child,
    );
  }
}

class _ShimmerEffectView extends StatefulWidget {
  const _ShimmerEffectView({
    required this.config,
    required this.direction,
    required this.child,
  });

  final SkeletonConfig config;
  final Axis direction;
  final Widget child;

  @override
  State<_ShimmerEffectView> createState() => _ShimmerEffectViewState();
}

class _ShimmerEffectViewState extends State<_ShimmerEffectView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.config.animationDuration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final value = _controller.value;

        final begin = widget.direction == Axis.horizontal
            ? Alignment(-1.0 + value * 2, 0)
            : Alignment(0, -1.0 + value * 2);

        final end = widget.direction == Axis.horizontal
            ? Alignment(value * 2, 0)
            : Alignment(0, value * 2);

        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: begin,
              end: end,
              colors: [
                widget.config.baseColor,
                widget.config.highlightColor,
                widget.config.baseColor,
              ],
              stops: const [0.25, 0.5, 0.75],
            ).createShader(bounds);
          },
          child: child,
        );
      },
    );
  }
}
