import 'package:flutter/material.dart';

import '../core/skeleton_config.dart';
import 'skeleton_box.dart';

/// Generic card-shaped placeholder.
///
/// Use this when a screen has a repeated card layout and a single box is not
/// expressive enough. If [child] is omitted, the card behaves like a simple
/// rounded rectangle. If [child] is provided, the card becomes a low-contrast
/// container for manually composed skeleton content.
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

  /// Optional fixed width.
  final double? width;

  /// Optional fixed height.
  final double? height;

  /// Optional radius override.
  final BorderRadiusGeometry? borderRadius;

  /// Inner spacing used when [child] is provided.
  final EdgeInsetsGeometry padding;

  /// External spacing around the card.
  final EdgeInsetsGeometry? margin;

  /// Optional custom skeleton content.
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
