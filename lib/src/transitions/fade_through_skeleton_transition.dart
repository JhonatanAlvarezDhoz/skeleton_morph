import 'package:flutter/widgets.dart';

import '../core/skeleton_transition.dart';

/// Fades through the skeleton state into the real content state.
///
/// `FadeThroughSkeletonTransition` is more deliberate than a plain cross-fade.
/// A regular fade lets the outgoing and incoming subtrees overlap immediately.
/// Fade-through delays the incoming subtree with an [Interval], which gives the
/// outgoing skeleton a short moment to disappear before the real content becomes
/// fully visible.
///
/// This is useful when the skeleton and the real content have noticeably
/// different shapes. In those cases, a direct cross-fade can feel visually busy
/// because both trees compete for attention at the same time.
///
/// The transition is implemented with [AnimatedSwitcher]. The [loading] value is
/// used as the key so Flutter treats the skeleton and content states as distinct
/// children and actually runs the switch animation.
///
/// This transition does not animate placeholder internals. Shimmer, pulse, and
/// static behavior still belong to `SkeletonEffect`. This class only animates
/// the replacement of the whole skeleton subtree with the real content subtree.
///
/// Design pattern: Strategy.
class FadeThroughSkeletonTransition extends SkeletonTransition {
  const FadeThroughSkeletonTransition({
    this.curve = Curves.easeOut,
    this.reverseCurve = Curves.easeIn,
    this.intervalBegin = 0.25,
    this.intervalEnd = 1.0,
  });

  /// Curve used when the new subtree fades in.
  ///
  /// This curve is applied inside the fade-through interval, not across the
  /// entire transition timeline.
  final Curve curve;

  /// Curve used when the old subtree fades out.
  final Curve reverseCurve;

  /// Start of the incoming fade interval.
  ///
  /// The default `0.25` means the incoming child starts fading in after the
  /// first quarter of the transition has elapsed.
  final double intervalBegin;

  /// End of the incoming fade interval.
  ///
  /// The default `1.0` means the incoming child reaches full opacity at the end
  /// of the transition.
  final double intervalEnd;

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
        // AnimatedSwitcher provides one animation per entering/leaving child.
        // The interval delays the incoming fade so the change reads as
        // "fade out, then fade in" instead of both states competing at once.
        final fadeIn = CurvedAnimation(
          parent: animation,
          curve: Interval(intervalBegin, intervalEnd, curve: curve),
          reverseCurve: reverseCurve,
        );

        return FadeTransition(
          opacity: fadeIn,
          child: child,
        );
      },
      child: KeyedSubtree(
        key: ValueKey<bool>(loading),
        child: child,
      ),
    );
  }
}
