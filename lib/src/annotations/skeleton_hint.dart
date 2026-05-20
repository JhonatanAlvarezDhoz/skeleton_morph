import 'package:flutter/material.dart';

/// Provides semantic information to the automatic skeletonizer.
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

  final Widget child;
  final SkeletonHintKind kind;
  final double? width;
  final double? height;
  final int? lines;
  final double? aspectRatio;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) => child;
}

enum SkeletonHintKind {
  text,
  image,
  box,
}
