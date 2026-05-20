import 'package:flutter/widgets.dart';

import '../core/skeleton_context.dart';
import 'widget_skeletonizer.dart';

/// Converts layout widgets while preserving their structural behavior.
///
/// Design pattern: Composite.
/// Row, Column, Wrap and Flex are trees of children, so the skeletonizer maps
/// each child through the main [WidgetSkeletonizer].
class LayoutSkeletonizer {
  const LayoutSkeletonizer();

  bool canHandle(Widget widget) {
    return widget is Row ||
        widget is Column ||
        widget is Flex ||
        widget is Wrap ||
        widget is Padding ||
        widget is Center ||
        widget is Align ||
        widget is Expanded ||
        widget is Flexible;
  }

  Widget build(
    Widget widget,
    SkeletonBuildContext context,
    WidgetSkeletonizer skeletonizer,
  ) {
    if (widget is Row) {
      return Row(
        mainAxisAlignment: widget.mainAxisAlignment,
        mainAxisSize: widget.mainAxisSize,
        crossAxisAlignment: widget.crossAxisAlignment,
        textDirection: widget.textDirection,
        verticalDirection: widget.verticalDirection,
        textBaseline: widget.textBaseline,
        children: widget.children
            .map((child) => skeletonizer.build(child, context.nextDepth()))
            .toList(),
      );
    }

    if (widget is Column) {
      return Column(
        mainAxisAlignment: widget.mainAxisAlignment,
        mainAxisSize: widget.mainAxisSize,
        crossAxisAlignment: widget.crossAxisAlignment,
        textDirection: widget.textDirection,
        verticalDirection: widget.verticalDirection,
        textBaseline: widget.textBaseline,
        children: widget.children
            .map((child) => skeletonizer.build(child, context.nextDepth()))
            .toList(),
      );
    }

    if (widget is Padding) {
      final child = widget.child;

      return Padding(
        padding: widget.padding,
        child: child == null
            ? null
            : skeletonizer.build(child, context.nextDepth()),
      );
    }

    if (widget is Expanded) {
      return Expanded(
        flex: widget.flex,
        child: skeletonizer.build(widget.child, context.nextDepth()),
      );
    }

    if (widget is Flexible) {
      return Flexible(
        flex: widget.flex,
        fit: widget.fit,
        child: skeletonizer.build(widget.child, context.nextDepth()),
      );
    }

    return widget;
  }
}
