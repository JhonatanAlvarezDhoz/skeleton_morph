import 'package:flutter/widgets.dart';

import '../core/skeleton_config.dart';
import '../core/skeleton_effect.dart';

/// Opacity-based loading effect.
///
/// `PulseEffect` repeatedly fades the placeholder between [minOpacity] and
/// [maxOpacity] while the skeleton is mounted. This is intentionally cheaper
/// than shimmer because it only animates opacity and does not allocate a moving
/// shader every frame.
///
/// The animation is lifecycle-aware:
/// - it starts when the effect widget enters the tree;
/// - it repeats for as long as the skeleton is visible;
/// - it disposes its [AnimationController] when removed.
///
/// Design pattern: Strategy.
class PulseEffect extends SkeletonEffect {
  const PulseEffect({
    this.minOpacity = 0.45,
    this.maxOpacity = 1.0,
  });

  /// Lowest opacity reached during the pulse cycle.
  ///
  /// Keep this above `0` so the placeholder never fully disappears.
  final double minOpacity;

  /// Highest opacity reached during the pulse cycle.
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
  /// Owns the repeating pulse lifecycle.
  ///
  /// This cannot be implemented with [TweenAnimationBuilder] because that
  /// widget runs a transition toward a target value and then stops. Loading
  /// indicators need a persistent animation until the loading UI is removed.
  late final AnimationController _controller;

  /// Curved opacity animation derived from [_controller].
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

    // Keep the existing controller alive when only the configuration changes.
    // Recreating the controller would restart the pulse unnecessarily.
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
    // The effect owns the controller, so it must release it when the skeleton
    // leaves the tree. This prevents ticker leaks in long-lived screens.
    _controller.dispose();
    super.dispose();
  }

  /// Creates the opacity tween used by the visual pulse.
  ///
  /// This is extracted because [didUpdateWidget] may need to rebuild the tween
  /// when the opacity bounds change without recreating the controller.
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
