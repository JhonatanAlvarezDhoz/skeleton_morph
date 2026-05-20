import 'package:flutter/material.dart';

import '../core/skeleton_config.dart';
import 'skeleton_box.dart';

/// Placeholder that simulates an image.
///
/// It supports fixed sizes and aspect ratios, making it useful for thumbnails,
/// banners, avatars and product images.
class SkeletonImage extends StatelessWidget {
  const SkeletonImage({
    super.key,
    this.width,
    this.height,
    this.aspectRatio,
    this.borderRadius,
  });

  final double? width;
  final double? height;
  final double? aspectRatio;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    final config = SkeletonConfig.of(context);

    final child = SkeletonBox(
      width: width,
      height: height,
      borderRadius: borderRadius ?? config.borderRadius,
    );

    if (aspectRatio == null) return child;

    return AspectRatio(
      aspectRatio: aspectRatio!,
      child: child,
    );
  }
}
