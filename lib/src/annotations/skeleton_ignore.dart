import 'package:flutter/widgets.dart';

/// Prevents a subtree from being transformed into a skeleton.
///
/// Design pattern: Marker / Annotation Widget.
/// It communicates intent to the analyzer without changing the visual output
/// when loading is disabled.
class SkeletonIgnore extends StatelessWidget {
  const SkeletonIgnore({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}
