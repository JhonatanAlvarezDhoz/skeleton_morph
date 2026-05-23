import 'package:flutter/widgets.dart';
import 'package:skeleton_morph/src/core/skeleton_transition.dart';

/// Cross-fades between the skeleton tree and the real content tree.
///
/// `FadeSkeletonTransition` is the default transition because it is simple,
/// cheap, predictable, and works consistently across Flutter platforms.
///
/// This transition does not animate the skeleton placeholders themselves.
/// Placeholder animation belongs to `SkeletonEffect` (`ShimmerEffect`,
/// `PulseEffect`, etc.). This class only controls how the whole loading subtree
/// is replaced by the real content when `SkeletonMorph.enabled` changes.
///
/// Internally it uses [AnimatedSwitcher], which keeps the outgoing child alive
/// long enough to fade it out while the incoming child fades in.
///
/// The [loading] flag is used as the child key. That is important: without a
/// different key, Flutter may update the existing child in place and skip the
/// transition.
///
/// Design pattern: Strategy.
class FadeSkeletonTransition extends SkeletonTransition {
  const FadeSkeletonTransition({
    this.curve = Curves.easeInOut,
    this.reverseCurve = Curves.easeInOut,
  });

  /// Curve used when the new child fades in.
  final Curve curve;

  /// Curve used when the old child fades out.
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
      child: KeyedSubtree(
        key: ValueKey<bool>(loading),
        child: child,
      ),
    );
  }
}
