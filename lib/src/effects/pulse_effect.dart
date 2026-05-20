import 'package:flutter/widgets.dart';

import '../core/skeleton_config.dart';
import '../core/skeleton_effect.dart';

/// Opacity-based loading effect.
///
/// Design pattern: Strategy.
/// This effect is cheaper than shimmer because it only animates opacity.
class PulseEffect extends SkeletonEffect {
  const PulseEffect({
    this.minOpacity = 0.45,
    this.maxOpacity = 1.0,
  });

  final double minOpacity;
  final double maxOpacity;

  @override
  Widget build(BuildContext context, Widget child) {
    final config = SkeletonConfig.of(context);

    return _PulseEffectView(
      minOpacity: minOpacity,
      maxOpacity: maxOpacity,
      duration: config.animationDuration,
      child: child,
    );
  }
}

class _PulseEffectView extends StatefulWidget {
  const _PulseEffectView({
    required this.minOpacity,
    required this.maxOpacity,
    required this.duration,
    required this.child,
  });

  final double minOpacity;
  final double maxOpacity;
  final Duration duration;
  final Widget child;

  @override
  State<_PulseEffectView> createState() => _PulseEffectViewState();
}

class _PulseEffectViewState extends State<_PulseEffectView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);
    _opacity = _buildOpacityAnimation();
  }

  @override
  void didUpdateWidget(_PulseEffectView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }

    if (oldWidget.minOpacity != widget.minOpacity ||
        oldWidget.maxOpacity != widget.maxOpacity) {
      _opacity = _buildOpacityAnimation();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Animation<double> _buildOpacityAnimation() {
    return Tween<double>(
      begin: widget.minOpacity,
      end: widget.maxOpacity,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: widget.child,
    );
  }
}
