import 'package:flutter/widgets.dart';

import 'skeleton_config.dart';

/// Runtime context passed to skeletonizer strategies.
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

  final BuildContext flutterContext;
  final SkeletonConfig config;
  final int depth;

  SkeletonBuildContext nextDepth() {
    return SkeletonBuildContext(
      flutterContext: flutterContext,
      config: config,
      depth: depth + 1,
    );
  }
}
