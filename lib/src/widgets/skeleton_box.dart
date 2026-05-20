import 'package:flutter/material.dart';

import '../core/skeleton_config.dart';

/// Basic rectangular placeholder.
///
/// This is the primitive used by most higher-level skeleton widgets.
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

  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
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

    return config.effect.build(context, box);
  }
}
