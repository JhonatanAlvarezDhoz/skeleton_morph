import 'package:flutter/widgets.dart';

import 'skeleton_config.dart';

/// Runtime context passed to skeletonizer strategies.
///
/// This object carries the shared runtime data needed while recursively
/// transforming a widget tree. Passing a single context object keeps analyzer
/// method signatures small and leaves room for future metadata such as max
/// depth, diagnostics, or accessibility preferences.
///
/// Design pattern: Context Object.
/// Instead of passing multiple parameters to every strategy, we group shared
/// runtime data in one immutable object.
@immutable
class SkeletonBuildContext {
  const SkeletonBuildContext({
    required this.flutterContext,
    required this.config,
    required this.depth,
  });

  /// Original Flutter build context.
  ///
  /// Strategies use this to resolve inherited Flutter values such as
  /// `DefaultTextStyle`.
  final BuildContext flutterContext;

  /// Effective skeleton configuration for this transformation.
  final SkeletonConfig config;

  /// Current recursion depth in the analyzed widget tree.
  final int depth;

  /// Creates a copy for a nested child.
  SkeletonBuildContext nextDepth() {
    return SkeletonBuildContext(
      flutterContext: flutterContext,
      config: config,
      depth: depth + 1,
    );
  }
}
