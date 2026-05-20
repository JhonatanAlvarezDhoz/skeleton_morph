import 'package:flutter/material.dart';

import '../effects/shimmer_effect.dart';
import 'skeleton_effect.dart';

/// Immutable configuration object for skeleton_morph.
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
    this.ignorePointersWhenLoading = true,
  });

  final Color baseColor;
  final Color highlightColor;
  final BorderRadius borderRadius;
  final BorderRadius textBorderRadius;
  final double textHeight;
  final double spacing;
  final SkeletonEffect effect;
  final Duration animationDuration;
  final bool ignorePointersWhenLoading;

  SkeletonConfig copyWith({
    Color? baseColor,
    Color? highlightColor,
    BorderRadius? borderRadius,
    BorderRadius? textBorderRadius,
    double? textHeight,
    double? spacing,
    SkeletonEffect? effect,
    Duration? animationDuration,
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
      ignorePointersWhenLoading:
          ignorePointersWhenLoading ?? this.ignorePointersWhenLoading,
    );
  }

  static SkeletonConfig of(BuildContext context) {
    final theme =
        context.dependOnInheritedWidgetOfExactType<SkeletonThemeData>();
    return theme?.config ?? const SkeletonConfig();
  }
}

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
