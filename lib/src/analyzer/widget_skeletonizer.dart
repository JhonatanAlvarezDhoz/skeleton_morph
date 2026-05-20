import 'package:flutter/material.dart';
import 'package:skeleton_morph/skeleton_morph.dart';
import 'package:skeleton_morph/src/analyzer/container_skeletonizer.dart';
import 'package:skeleton_morph/src/analyzer/image_skeletonizer.dart';
import 'package:skeleton_morph/src/analyzer/layout_skeletonizer.dart';
import 'package:skeleton_morph/src/analyzer/text_skeletonizer.dart';

/// Central service that transforms widgets into skeleton placeholders.
///
/// This class is the package's internal "router" for skeleton generation. It
/// receives a real Flutter widget and decides which specialized skeletonizer
/// should handle it.
///
/// The order of checks is intentional:
/// 1. explicit user intent (`SkeletonIgnore`, `SkeletonReplace`,
///    `SkeletonHint`);
/// 2. structural layout widgets (`Row`, `Column`, `Padding`, etc.);
/// 3. semantic leaf widgets (`Text`, `Image`, boxes);
/// 4. a conservative fallback box.
///
/// That priority matters because hints/replacements must always win over
/// automatic inference. If users took the time to provide metadata, the package
/// should trust that metadata first.
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

  /// Builds a skeleton equivalent for [widget].
  ///
  /// The method does not mutate or mount [widget]. Flutter widgets are immutable
  /// configuration objects, so the skeletonizer creates a new widget tree that
  /// approximates the original layout.
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

  /// Converts explicit user metadata into concrete skeleton widgets.
  ///
  /// `SkeletonHint` exists because custom widgets hide their internal structure.
  /// For example, a `ProductImage` widget may visually be an image, but from the
  /// outside it is just an opaque widget configuration. The hint bridges that
  /// gap without forcing consumers to duplicate entire loading layouts.
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

  /// Last-resort placeholder for widgets the package cannot understand.
  ///
  /// The fallback is intentionally simple. A wrong but stable placeholder is
  /// better than trying to inspect private widget internals and producing
  /// fragile behavior.
  Widget _fallback(Widget widget, SkeletonBuildContext context) {
    return SkeletonBox(
      height: context.config.textHeight * 2.6,
      borderRadius: context.config.borderRadius,
    );
  }
}
