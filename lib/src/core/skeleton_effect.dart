import 'package:flutter/widgets.dart';

/// Contract used by all visual loading effects.
///
/// Design pattern: Strategy.
/// Each effect encapsulates a different animation algorithm while exposing the
/// same method: [build]. The widgets do not know whether the effect is shimmer,
/// pulse, static, or any future custom implementation.
abstract class SkeletonEffect {
  const SkeletonEffect();

  /// Wraps [child] with the visual effect.
  ///
  /// The child should already be a placeholder shape. The effect should not
  /// decide the size or layout; it only decorates/animates the placeholder.
  Widget build(BuildContext context, Widget child);
}
