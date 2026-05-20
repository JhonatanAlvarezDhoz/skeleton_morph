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

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: minOpacity, end: maxOpacity),
      duration: config.animationDuration,
      curve: Curves.easeInOut,
      builder: (context, opacity, child) {
        return Opacity(opacity: opacity, child: child);
      },
      child: child,
    );
  }
}
