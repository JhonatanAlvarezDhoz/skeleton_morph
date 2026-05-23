import 'package:flutter/widgets.dart';

/// Contract for transitions between skeleton UI and real UI.
///
/// A [SkeletonTransition] controls how `SkeletonMorph` switches between:
/// - the generated skeleton tree while loading;
/// - the original child tree when loading finishes.
///
/// This is different from `SkeletonEffect`.
///
/// `SkeletonEffect` animates the placeholder itself while loading.
/// `SkeletonTransition` animates the replacement of one subtree with another.
///
/// Design pattern: Strategy.
abstract class SkeletonTransition {
  const SkeletonTransition();

  /// Wraps [child] with the transition behavior.
  ///
  /// [child] is already either the skeleton tree or the real content tree.
  /// [loading] tells the transition which state is currently visible and is
  /// commonly used to key animated switchers.
  /// [duration] controls how long the transition takes.
  Widget build({
    required Widget child,
    required bool loading,
    required Duration duration,
  });
}
