import 'package:flutter/material.dart';

import '../core/skeleton_config.dart';
import 'skeleton_box.dart';

/// Placeholder that simulates an image.
///
/// It supports fixed sizes and aspect ratios, making it useful for thumbnails,
/// banners, avatars and product images.
///
/// By default, the placeholder includes a centered image icon above the
/// animated skeleton shape. The icon is intentionally painted outside the
/// shimmer mask so it remains visible while the background animates.
///
/// When [width], [height], or [aspectRatio] are provided, they are applied to
/// the outer layout box so the icon overlay cannot change the requested image
/// footprint.
///
/// This widget is still just a skeleton shape; it does not load, decode, cache,
/// or inspect real image providers.
class SkeletonImage extends StatelessWidget {
  const SkeletonImage({
    super.key,
    this.width,
    this.height,
    this.aspectRatio,
    this.borderRadius,
    this.showIcon = true,
    this.icon = Icons.image_outlined,
    this.iconSize,
    this.iconColor,
  });

  /// Optional fixed width.
  final double? width;

  /// Optional fixed height.
  final double? height;

  /// Optional aspect ratio for responsive image placeholders.
  final double? aspectRatio;

  /// Optional radius override.
  final BorderRadiusGeometry? borderRadius;

  /// Whether to show a centered media icon inside the image placeholder.
  final bool showIcon;

  /// Icon displayed when [showIcon] is true.
  final IconData icon;

  /// Optional icon size. Defaults to a medium size that works for thumbnails.
  final double? iconSize;

  /// Optional icon color. Defaults to a subtle highlight color from config.
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final config = SkeletonConfig.of(context);

    final placeholder = SkeletonBox(
      borderRadius: borderRadius ?? config.borderRadius,
    );

    Widget child = showIcon
        ? Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(child: placeholder),
              Icon(
                icon,
                size: iconSize ?? 28,
                color:
                    iconColor ?? config.highlightColor.withValues(alpha: 0.85),
              ),
            ],
          )
        : placeholder;

    if (aspectRatio != null) {
      child = AspectRatio(
        aspectRatio: aspectRatio!,
        child: child,
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: child,
    );
  }
}
