import 'package:flutter/material.dart';

import '../core/skeleton_context.dart';
import '../widgets/skeleton_text.dart';

/// Converts [Text] widgets into text placeholders.
///
/// Design pattern: Strategy.
/// Each skeletonizer is responsible for one widget family.
class TextSkeletonizer {
  const TextSkeletonizer();

  bool canHandle(Widget widget) => widget is Text || widget is RichText;

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

  int _estimateLines(String text) {
    if (text.length > 80) return 3;
    if (text.length > 36) return 2;
    return 1;
  }

  double _estimateTextWidth(String text, double fontSize) {
    if (text.trim().isEmpty) return 80;

    final width = text.length * fontSize * 0.55;

    return width.clamp(48, 320).toDouble();
  }
}
