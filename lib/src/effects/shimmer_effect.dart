import 'package:flutter/material.dart';

import '../core/skeleton_config.dart';
import '../core/skeleton_effect.dart';

/// Shimmer loading effect used by default.
///
/// `ShimmerEffect` paints a moving gradient over an already-built skeleton
/// shape. It does not decide layout, size, radius, or spacing. Those concerns
/// belong to widgets such as `SkeletonBox`, `SkeletonText`, and
/// `SkeletonImage`.
///
/// The effect owns an [AnimationController] internally and repeats it while the
/// skeleton is mounted. When the skeleton leaves the widget tree, the controller
/// is disposed.
///
/// Design pattern: Strategy.
class ShimmerEffect extends SkeletonEffect {
  const ShimmerEffect({
    this.direction = Axis.horizontal,
  });

  /// Direction in which the shimmer highlight travels.
  ///
  /// Horizontal is the default because most loading placeholders mimic text and
  /// cards, which are usually scanned left-to-right or right-to-left.
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
  /// Drives the moving gradient.
  ///
  /// The controller repeats indefinitely because a skeleton is a loading state,
  /// not a one-shot transition.
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
    // The effect owns the ticker, so it must dispose it to avoid leaks when the
    // skeleton disappears.
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

        // The gradient moves by shifting both its begin and end alignments.
        // The placeholder shape itself remains untouched; only the shader mask
        // changes over time.
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
