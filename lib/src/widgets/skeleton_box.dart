import 'package:flutter/material.dart';

import '../core/skeleton_config.dart';

/// Basic rectangular placeholder.
///
/// This is the primitive used by most higher-level skeleton widgets.
/// It owns the shape, while [SkeletonConfig.effect] owns the visual animation.
///
/// `SkeletonBox` can be used directly when writing a manual skeleton, and it is
/// also used internally by text, image, card, and fallback placeholders.
///
/// Design patterns:
/// - Primitive Component: small reusable base widget.
/// - Strategy: delegates the animation to the active [SkeletonEffect].
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.margin,
    this.padding,
    this.alignment,
  });

  /// Optional fixed width for the placeholder.
  final double? width;

  /// Optional fixed height for the placeholder.
  final double? height;

  /// Optional radius override. Defaults to [SkeletonConfig.borderRadius].
  final BorderRadiusGeometry? borderRadius;

  /// External spacing around the placeholder.
  final EdgeInsetsGeometry? margin;

  /// Internal spacing for advanced/manual skeleton composition.
  final EdgeInsetsGeometry? padding;

  /// Alignment passed to the underlying container.
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    final config = SkeletonConfig.of(context);

    final box = Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      alignment: alignment,
      decoration: BoxDecoration(
        color: config.baseColor,
        borderRadius: borderRadius ?? config.borderRadius,
      ),
    );

    // Effects decorate an already-built shape. This keeps sizing/layout
    // independent from animation strategy.
    return config.effect.build(context, box);
  }
}
