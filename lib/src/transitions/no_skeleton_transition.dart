import 'package:flutter/widgets.dart';

import '../core/skeleton_transition.dart';

/// Disables transitions between the skeleton tree and the real content tree.
///
/// `NoSkeletonTransition` returns the current child immediately, without
/// wrapping it in `AnimatedSwitcher` or any other animation widget.
///
/// This is useful when:
/// - tests need deterministic widget trees;
/// - the parent screen already owns its own transition;
/// - accessibility/performance requirements prefer instant replacement;
/// - consumers want the skeleton/content switch to happen with no visual delay.
///
/// This transition does not affect `SkeletonEffect`.
/// For example, a skeleton may still shimmer or pulse while loading. This class
/// only controls the moment when `SkeletonMorph.enabled` switches between the
/// skeleton subtree and the real child subtree.
///
/// Design pattern: Null Object.
class NoSkeletonTransition extends SkeletonTransition {
  const NoSkeletonTransition();

  @override
  Widget build({
    required Widget child,
    required bool loading,
    required Duration duration,
  }) {
    return child;
  }
}
