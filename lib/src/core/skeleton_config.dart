import 'package:flutter/material.dart';

import '../effects/shimmer_effect.dart';
import '../transitions/fade_skeleton_transition.dart';
import 'skeleton_effect.dart';
import 'skeleton_transition.dart';

/// Immutable configuration object for skeleton_morph.
///
/// `SkeletonConfig` is the single place where visual defaults live. Widgets do
/// not hardcode colors, radius, spacing, or animation choices; they read those
/// values from the nearest `SkeletonTheme` or from this default configuration.
///
/// This makes the package predictable:
/// - app-wide styling goes through `SkeletonTheme`;
/// - one-off styling goes through `SkeletonMorph.config`;
/// - tests can use `StaticEffect` to avoid animated output;
/// - transition behavior is configured separately from skeleton placeholder
///   effects.
///
/// Design pattern: Value Object.
/// This class centralizes visual decisions so widgets do not duplicate default
/// values. It also makes theming and testing easier.
@immutable
class SkeletonConfig {
  const SkeletonConfig({
    this.baseColor = const Color(0xFFE2E8F0),
    this.highlightColor = const Color(0xFFF8FAFC),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.textBorderRadius = const BorderRadius.all(Radius.circular(999)),
    this.textHeight = 14,
    this.spacing = 8,
    this.effect = const ShimmerEffect(),
    this.animationDuration = const Duration(milliseconds: 1200),
    this.transition = const FadeSkeletonTransition(),
    this.transitionDuration = const Duration(milliseconds: 250),
    this.ignorePointersWhenLoading = true,
  });

  /// Main color used by skeleton shapes.
  final Color baseColor;

  /// Secondary color used by animated effects such as shimmer.
  final Color highlightColor;

  /// Default radius for box-like placeholders.
  final BorderRadius borderRadius;

  /// Default radius for text placeholders.
  ///
  /// The large default value creates pill-shaped text lines.
  final BorderRadius textBorderRadius;

  /// Default height used by generated text skeleton lines.
  final double textHeight;

  /// Default vertical spacing between generated text lines.
  final double spacing;

  /// Visual effect applied to every skeleton primitive.
  final SkeletonEffect effect;

  /// Duration used by animated loading effects.
  ///
  /// This controls effects such as `ShimmerEffect` and `PulseEffect`; it does
  /// not control the transition between skeleton and real content.
  final Duration animationDuration;

  /// Transition used when `SkeletonMorph.enabled` switches between loading and
  /// loaded states.
  ///
  /// This is intentionally separate from [effect]. The effect animates the
  /// placeholder while loading; the transition animates the replacement of the
  /// skeleton subtree with the real content subtree.
  final SkeletonTransition transition;

  /// Duration used by [transition].
  final Duration transitionDuration;

  /// Whether skeletonized content should ignore pointer events while loading.
  ///
  /// This prevents users from tapping invisible/placeholder versions of real
  /// controls during loading.
  final bool ignorePointersWhenLoading;

  /// Creates a new config by overriding only selected fields.
  SkeletonConfig copyWith({
    Color? baseColor,
    Color? highlightColor,
    BorderRadius? borderRadius,
    BorderRadius? textBorderRadius,
    double? textHeight,
    double? spacing,
    SkeletonEffect? effect,
    Duration? animationDuration,
    SkeletonTransition? transition,
    Duration? transitionDuration,
    bool? ignorePointersWhenLoading,
  }) {
    return SkeletonConfig(
      baseColor: baseColor ?? this.baseColor,
      highlightColor: highlightColor ?? this.highlightColor,
      borderRadius: borderRadius ?? this.borderRadius,
      textBorderRadius: textBorderRadius ?? this.textBorderRadius,
      textHeight: textHeight ?? this.textHeight,
      spacing: spacing ?? this.spacing,
      effect: effect ?? this.effect,
      animationDuration: animationDuration ?? this.animationDuration,
      transition: transition ?? this.transition,
      transitionDuration: transitionDuration ?? this.transitionDuration,
      ignorePointersWhenLoading:
          ignorePointersWhenLoading ?? this.ignorePointersWhenLoading,
    );
  }

  /// Resolves the nearest skeleton configuration from the widget tree.
  ///
  /// If no [SkeletonTheme] exists above [context], package defaults are used.
  static SkeletonConfig of(BuildContext context) {
    final theme =
        context.dependOnInheritedWidgetOfExactType<SkeletonThemeData>();
    return theme?.config ?? const SkeletonConfig();
  }
}

/// Internal inherited widget used by [SkeletonTheme].
///
/// This is intentionally not exported as the primary public API. Consumers
/// should use `SkeletonTheme`, while package widgets use this inherited widget
/// to resolve configuration efficiently.
class SkeletonThemeData extends InheritedWidget {
  const SkeletonThemeData({
    super.key,
    required this.config,
    required super.child,
  });

  final SkeletonConfig config;

  @override
  bool updateShouldNotify(SkeletonThemeData oldWidget) {
    return config != oldWidget.config;
  }
}
