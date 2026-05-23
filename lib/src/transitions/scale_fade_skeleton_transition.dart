import 'package:flutter/widgets.dart';

import '../core/skeleton_transition.dart';

/// Combines fade and subtle scale when switching between skeleton and content.
///
/// `ScaleFadeSkeletonTransition` is useful for cards, tiles, and media-heavy UI
/// where a plain opacity transition feels too flat. The incoming subtree fades
/// in while scaling from [beginScale] to `1.0`.
///
/// Keep [beginScale] close to `1.0`. Large scale values make loading states feel
/// jumpy and can cause visual layout discomfort.
///
/// This transition only controls the skeleton/content replacement. It does not
/// affect shimmer, pulse, or any other `SkeletonEffect`.
///
/// Design pattern: Strategy.
class ScaleFadeSkeletonTransition extends SkeletonTransition {
  const ScaleFadeSkeletonTransition({
    this.beginScale = 0.98,
    this.curve = Curves.easeOutCubic,
    this.reverseCurve = Curves.easeInCubic,
  });

  /// Initial scale for the incoming subtree.
  ///
  /// Recommended range: `0.95` to `0.99`.
  final double beginScale;

  /// Curve used when the new subtree fades/scales in.
  final Curve curve;

  /// Curve used when the old subtree fades/scales out.
  final Curve reverseCurve;

  @override
  Widget build({
    required Widget child,
    required bool loading,
    required Duration duration,
  }) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: curve,
      switchOutCurve: reverseCurve,
      transitionBuilder: (child, animation) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: curve,
          reverseCurve: reverseCurve,
        );

        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(
              begin: beginScale,
              end: 1.0,
            ).animate(curved),
            child: child,
          ),
        );
      },
      child: KeyedSubtree(
        key: ValueKey<bool>(loading),
        child: child,
      ),
    );
  }
}
