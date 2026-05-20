import 'package:flutter/widgets.dart';

import '../core/skeleton_context.dart';
import 'widget_skeletonizer.dart';

/// Converts layout widgets while preserving their structural behavior.
///
/// Layout widgets are different from visual leaf widgets. They usually do not
/// draw meaningful pixels themselves; they arrange children. Because of that,
/// the correct skeleton behavior is to preserve the layout widget and
/// recursively skeletonize its children.
///
/// Example:
/// - a `Row` remains a `Row`;
/// - each child inside that row is converted to its skeleton equivalent;
/// - spacing/alignment values are copied so the loading UI keeps the same
///   visual rhythm as the loaded UI.
///
/// Design pattern: Composite.
/// Row, Column, Wrap and Flex are trees of children, so the skeletonizer maps
/// each child through the main [WidgetSkeletonizer].
class LayoutSkeletonizer {
  const LayoutSkeletonizer();

  /// Returns whether this strategy knows how to preserve [widget]'s layout role.
  ///
  /// A `true` result does not mean the widget draws a skeleton by itself. It
  /// means the widget is safe to rebuild while delegating its children back to
  /// [WidgetSkeletonizer].
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
      // Rows are structural. Keep their alignment contract and transform each
      // child independently so the skeleton occupies the same horizontal space.
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
      // Columns behave like rows but on the vertical axis. Preserving the
      // original axis settings prevents loading states from jumping.
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

      // Padding may legally have a null child. Do not force unwrap it; keeping
      // null preserves Flutter's own widget contract and keeps the package
      // sound-null-safe.
      return Padding(
        padding: widget.padding,
        child: child == null
            ? null
            : skeletonizer.build(child, context.nextDepth()),
      );
    }

    if (widget is Expanded) {
      // Expanded only makes sense inside Flex-based parents. Keep its flex
      // value and transform the child inside the same layout constraint.
      return Expanded(
        flex: widget.flex,
        child: skeletonizer.build(widget.child, context.nextDepth()),
      );
    }

    if (widget is Flexible) {
      // Flexible is similar to Expanded, but it also carries a fit strategy.
      // Copy both values so the skeleton respects the original constraints.
      return Flexible(
        flex: widget.flex,
        fit: widget.fit,
        child: skeletonizer.build(widget.child, context.nextDepth()),
      );
    }

    // Some layout widgets may be recognized by canHandle before a dedicated
    // branch exists. Returning the original widget is conservative, but new
    // branches should be added as support grows.
    return widget;
  }
}
