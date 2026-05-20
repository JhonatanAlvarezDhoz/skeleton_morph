import 'package:flutter/widgets.dart';

/// Replaces a real widget with a custom skeleton when loading is enabled.
///
/// Design pattern: Adapter / Replacement.
/// It gives consumers full control when automatic inference is not enough.
class SkeletonReplace extends StatelessWidget {
  const SkeletonReplace({
    super.key,
    required this.child,
    required this.skeleton,
  });

  final Widget child;
  final Widget skeleton;

  @override
  Widget build(BuildContext context) => child;
}
