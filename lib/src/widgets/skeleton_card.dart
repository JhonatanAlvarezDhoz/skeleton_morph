import 'package:flutter/material.dart';

import '../core/skeleton_config.dart';
import 'skeleton_box.dart';

/// Generic card-shaped placeholder.
///
/// Design pattern: Template Method, at widget composition level.
/// The outer structure is fixed as a card-like placeholder, while the optional
/// [child] lets consumers customize the inner content.
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.child,
  });

  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final config = SkeletonConfig.of(context);

    if (child == null) {
      return SkeletonBox(
        width: width,
        height: height,
        margin: margin,
        borderRadius: borderRadius ?? config.borderRadius,
      );
    }

    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: config.baseColor.withValues(alpha: 0.35),
        borderRadius: borderRadius ?? config.borderRadius,
      ),
      child: child,
    );
  }
}
