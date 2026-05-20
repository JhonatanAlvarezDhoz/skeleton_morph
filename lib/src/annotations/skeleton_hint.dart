import 'package:flutter/material.dart';

/// Provides semantic information to the automatic skeletonizer.
///
/// A hint does not draw a skeleton by itself. It is metadata consumed by
/// `SkeletonMorph` while the real widget tree is being transformed.
///
/// This is especially useful for custom widgets. Flutter does not expose the
/// private internals of a widget such as `ProductImage`, `Avatar`, or
/// `CustomText`, so automatic inference cannot always know whether that widget
/// should become an image, text line, or generic box.
///
/// Design pattern: Metadata / Annotation Widget.
/// Flutter cannot reliably infer every visual property from an arbitrary custom
/// widget. Hints make the automatic system precise without forcing consumers to
/// write an entirely separate skeleton layout.
class SkeletonHint extends StatelessWidget {
  const SkeletonHint({
    super.key,
    required this.child,
    this.kind = SkeletonHintKind.box,
    this.width,
    this.height,
    this.lines,
    this.aspectRatio,
    this.borderRadius,
  });

  const SkeletonHint.text({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.lines = 1,
    this.borderRadius,
  })  : kind = SkeletonHintKind.text,
        aspectRatio = null;

  const SkeletonHint.image({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.aspectRatio,
    this.borderRadius,
  })  : kind = SkeletonHintKind.image,
        lines = null;

  const SkeletonHint.box({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius,
  })  : kind = SkeletonHintKind.box,
        lines = null,
        aspectRatio = null;

  /// Real widget rendered when not skeletonized.
  final Widget child;

  /// Semantic skeleton shape to generate while loading.
  final SkeletonHintKind kind;

  /// Preferred skeleton width.
  ///
  /// This value belongs on the hint. The skeletonizer does not inspect the
  /// child's layout constraints to infer it.
  final double? width;

  /// Preferred skeleton height.
  final double? height;

  /// Number of text lines to generate for [SkeletonHintKind.text].
  final int? lines;

  /// Aspect ratio to preserve for [SkeletonHintKind.image].
  final double? aspectRatio;

  /// Optional radius override for image and box placeholders.
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) => child;
}

/// Semantic placeholder types understood by [SkeletonHint].
enum SkeletonHintKind {
  /// Text-like placeholder rendered as one or more horizontal lines.
  text,

  /// Image-like placeholder that can preserve size, ratio, and radius.
  image,

  /// Generic rectangular placeholder.
  box,
}
