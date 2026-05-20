import 'package:flutter/material.dart';

import '../core/skeleton_config.dart';
import 'skeleton_box.dart';

/// Placeholder that simulates one or more lines of text.
///
/// Design pattern: Composite.
/// A text skeleton is composed of multiple [SkeletonBox] widgets.
class SkeletonText extends StatelessWidget {
  const SkeletonText({
    super.key,
    this.lines = 1,
    this.width,
    this.height,
    this.spacing,
    this.lastLineWidthFactor = 0.65,
  }) : assert(lines > 0, 'lines must be greater than zero');

  final int lines;
  final double? width;
  final double? height;
  final double? spacing;
  final double lastLineWidthFactor;

  @override
  Widget build(BuildContext context) {
    final config = SkeletonConfig.of(context);
    final lineHeight = height ?? config.textHeight;
    final lineSpacing = spacing ?? config.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(lines, (index) {
        final isLast = index == lines - 1;

        final line = FractionallySizedBox(
          widthFactor:
              width == null && isLast && lines > 1 ? lastLineWidthFactor : null,
          child: SkeletonBox(
            width: width,
            height: lineHeight,
            borderRadius: config.textBorderRadius,
          ),
        );

        if (isLast) return line;

        return Padding(
          padding: EdgeInsets.only(bottom: lineSpacing),
          child: line,
        );
      }),
    );
  }
}
