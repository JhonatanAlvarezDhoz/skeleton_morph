import 'package:flutter/material.dart';
import 'package:skeleton_morph/skeleton_morph.dart';
import 'package:skeleton_morph/src/analyzer/container_skeletonizer.dart';
import 'package:skeleton_morph/src/analyzer/image_skeletonizer.dart';
import 'package:skeleton_morph/src/analyzer/layout_skeletonizer.dart';
import 'package:skeleton_morph/src/analyzer/text_skeletonizer.dart';

/// Central service that transforms widgets into skeleton placeholders.
///
/// Design patterns:
/// - Facade: exposes one [build] method for the rest of the package.
/// - Chain of Responsibility: delegates to specialized skeletonizers.
/// - Strategy: each specialized skeletonizer owns one transformation algorithm.
///
/// Important limitation:
/// Flutter widgets are immutable configuration objects. For custom widgets, the
/// package cannot always inspect the private internals. That is why the package
/// supports [SkeletonHint], [SkeletonReplace] and [SkeletonIgnore].
class WidgetSkeletonizer {
  WidgetSkeletonizer({
    TextSkeletonizer textSkeletonizer = const TextSkeletonizer(),
    ImageSkeletonizer imageSkeletonizer = const ImageSkeletonizer(),
    ContainerSkeletonizer containerSkeletonizer = const ContainerSkeletonizer(),
    LayoutSkeletonizer layoutSkeletonizer = const LayoutSkeletonizer(),
  })  : _textSkeletonizer = textSkeletonizer,
        _imageSkeletonizer = imageSkeletonizer,
        _containerSkeletonizer = containerSkeletonizer,
        _layoutSkeletonizer = layoutSkeletonizer;

  final TextSkeletonizer _textSkeletonizer;
  final ImageSkeletonizer _imageSkeletonizer;
  final ContainerSkeletonizer _containerSkeletonizer;
  final LayoutSkeletonizer _layoutSkeletonizer;

  Widget build(Widget widget, SkeletonBuildContext context) {
    if (widget is SkeletonIgnore) {
      return widget.child;
    }

    if (widget is SkeletonReplace) {
      return widget.skeleton;
    }

    if (widget is SkeletonHint) {
      return _fromHint(widget, context);
    }

    if (_layoutSkeletonizer.canHandle(widget)) {
      return _layoutSkeletonizer.build(widget, context, this);
    }

    if (_textSkeletonizer.canHandle(widget)) {
      return _textSkeletonizer.build(widget, context);
    }

    if (_imageSkeletonizer.canHandle(widget)) {
      return _imageSkeletonizer.build(widget, context);
    }

    if (_containerSkeletonizer.canHandle(widget)) {
      return _containerSkeletonizer.build(widget, context);
    }

    return _fallback(widget, context);
  }

  Widget _fromHint(SkeletonHint hint, SkeletonBuildContext context) {
    switch (hint.kind) {
      case SkeletonHintKind.text:
        return SkeletonText(
          lines: hint.lines ?? 1,
          width: hint.width,
          height: hint.height,
        );
      case SkeletonHintKind.image:
        return SkeletonImage(
          width: hint.width,
          height: hint.height,
          aspectRatio: hint.aspectRatio,
          borderRadius: hint.borderRadius,
        );
      case SkeletonHintKind.box:
        return SkeletonBox(
          width: hint.width,
          height: hint.height,
          borderRadius: hint.borderRadius ?? context.config.borderRadius,
        );
    }
  }

  Widget _fallback(Widget widget, SkeletonBuildContext context) {
    return SkeletonBox(
      height: context.config.textHeight * 2.6,
      borderRadius: context.config.borderRadius,
    );
  }
}
