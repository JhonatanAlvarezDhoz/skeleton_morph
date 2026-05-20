import 'package:flutter/material.dart';

import '../core/skeleton_context.dart';
import '../widgets/skeleton_text.dart';

/// Converts [Text] widgets into text placeholders.
///
/// Text is one of the few Flutter widgets where the package can infer useful
/// skeleton dimensions from public data. The strategy estimates:
/// - line count from text length;
/// - line height from the effective text style;
/// - line width from character count and font size.
///
/// These estimates are intentionally approximate. The goal is a stable loading
/// layout, not pixel-perfect text measurement.
///
/// Design pattern: Strategy.
/// Each skeletonizer is responsible for one widget family.
class TextSkeletonizer {
  const TextSkeletonizer();

  /// Returns whether [widget] is text-like.
  bool canHandle(Widget widget) => widget is Text || widget is RichText;

  /// Builds a text skeleton using public widget/style information.
  Widget build(Widget widget, SkeletonBuildContext context) {
    if (widget is Text) {
      final style =
          widget.style ?? DefaultTextStyle.of(context.flutterContext).style;

      final fontSize = style.fontSize ?? 14;
      final lineHeight = fontSize * (style.height ?? 1.2);
      final text = widget.data ?? '';
      final estimatedWidth = _estimateTextWidth(text, fontSize);

      return SkeletonText(
        lines: _estimateLines(text),
        width: estimatedWidth,
        height: lineHeight.clamp(10, 32).toDouble(),
      );
    }

    return SkeletonText(height: context.config.textHeight);
  }

  /// Estimates how many placeholder lines are needed for [text].
  int _estimateLines(String text) {
    if (text.length > 80) return 3;
    if (text.length > 36) return 2;
    return 1;
  }

  /// Estimates a readable skeleton width without doing expensive text layout.
  double _estimateTextWidth(String text, double fontSize) {
    if (text.trim().isEmpty) return 80;

    final width = text.length * fontSize * 0.55;

    return width.clamp(48, 320).toDouble();
  }
}
