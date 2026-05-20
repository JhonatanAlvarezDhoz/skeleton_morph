import 'package:flutter/widgets.dart';

import '../core/skeleton_effect.dart';

/// Effect that renders the placeholder without animation.
///
/// Design pattern: Null Object.
/// It follows the same [SkeletonEffect] contract, but intentionally does
/// nothing. Useful for low-end devices, accessibility, screenshots, and tests.
class StaticEffect extends SkeletonEffect {
  const StaticEffect();

  @override
  Widget build(BuildContext context, Widget child) => child;
}
