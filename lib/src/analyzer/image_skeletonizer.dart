import 'package:flutter/widgets.dart';

import '../core/skeleton_context.dart';
import '../widgets/skeleton_image.dart';

/// Converts image-like widgets into image placeholders.
///
/// Design pattern: Strategy.
class ImageSkeletonizer {
  const ImageSkeletonizer();

  bool canHandle(Widget widget) {
    return widget is Image ||
        widget.runtimeType.toString().contains('CachedNetworkImage');
  }

  Widget build(Widget widget, SkeletonBuildContext context) {
    if (widget is Image) {
      return SkeletonImage(
        width: widget.width,
        height: widget.height,
        borderRadius: context.config.borderRadius,
      );
    }

    return const SkeletonImage(
      width: double.infinity,
      height: 160,
    );
  }
}
