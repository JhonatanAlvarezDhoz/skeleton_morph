import 'package:flutter/material.dart';

import '../core/skeleton_config.dart';
import 'skeleton_box.dart';

/// Placeholder that simulates one or more lines of text.
///
/// Text skeletons are built from multiple [SkeletonBox] lines so they inherit
/// the active global/local effect automatically. When [width] is omitted and
/// there is more than one line, the last line is shortened to look more like a
/// natural paragraph.
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

  /// Number of text lines to render.
  final int lines;

  /// Optional fixed width for every line.
  final double? width;

  /// Optional line height. Defaults to [SkeletonConfig.textHeight].
  final double? height;

  /// Optional spacing between lines. Defaults to [SkeletonConfig.spacing].
  final double? spacing;

  /// Width factor used by the last line when [width] is omitted.
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
