import 'package:flutter/material.dart';

import '../core/skeleton_context.dart';
import '../widgets/skeleton_box.dart';

/// Converts box-like widgets into rectangular placeholders.
///
/// Design pattern: Strategy.
/// This is intentionally conservative. It handles the common widgets that expose
/// size and decoration information publicly.
class ContainerSkeletonizer {
  const ContainerSkeletonizer();

  bool canHandle(Widget widget) {
    return widget is Container ||
        widget is SizedBox ||
        widget is DecoratedBox ||
        widget is Card ||
        widget is CircleAvatar;
  }

  Widget build(Widget widget, SkeletonBuildContext context) {
    if (widget is SizedBox) {
      return SkeletonBox(
        width: widget.width,
        height: widget.height,
      );
    }

    if (widget is Container) {
      final decoration = widget.decoration;
      BorderRadiusGeometry? borderRadius;

      if (decoration is BoxDecoration) {
        borderRadius = decoration.borderRadius;
      }

      return SkeletonBox(
        width: widget.constraints?.maxWidth.isFinite == true
            ? widget.constraints?.maxWidth
            : null,
        height: widget.constraints?.maxHeight.isFinite == true
            ? widget.constraints?.maxHeight
            : null,
        margin: widget.margin,
        padding: widget.padding,
        alignment: widget.alignment,
        borderRadius: borderRadius ?? context.config.borderRadius,
      );
    }

    if (widget is Card) {
      return SkeletonBox(
        borderRadius: context.config.borderRadius,
      );
    }

    if (widget is CircleAvatar) {
      final radius = widget.radius ?? 20;

      return SkeletonBox(
        width: radius * 2,
        height: radius * 2,
        borderRadius: BorderRadius.circular(radius),
      );
    }

    return const SkeletonBox(height: 48);
  }
}
