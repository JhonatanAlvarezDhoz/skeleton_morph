import 'package:flutter/widgets.dart';

/// Prevents a subtree from being transformed into a skeleton.
///
/// Use this for controls, badges, icons, or content that should remain visible
/// while the rest of the surrounding UI is loading. The marker only has special
/// behavior when an ancestor `SkeletonMorph` analyzes it.
///
/// Design pattern: Marker / Annotation Widget.
/// It communicates intent to the analyzer without changing the visual output
/// when loading is disabled.
class SkeletonIgnore extends StatelessWidget {
  const SkeletonIgnore({
    super.key,
    required this.child,
  });

  /// Subtree that should bypass skeleton conversion.
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}
