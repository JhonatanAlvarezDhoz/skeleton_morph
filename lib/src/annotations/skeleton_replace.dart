import 'package:flutter/widgets.dart';

/// Replaces a real widget with a custom skeleton when loading is enabled.
///
/// Use this when automatic inference and `SkeletonHint` are not expressive
/// enough. The [child] remains the real UI for the loaded state, while
/// [skeleton] is used only when an ancestor `SkeletonMorph` is enabled.
///
/// Design pattern: Adapter / Replacement.
/// It gives consumers full control when automatic inference is not enough.
class SkeletonReplace extends StatelessWidget {
  const SkeletonReplace({
    super.key,
    required this.child,
    required this.skeleton,
  });

  /// Real widget rendered when not loading.
  final Widget child;

  /// Replacement widget rendered while loading.
  final Widget skeleton;

  @override
  Widget build(BuildContext context) => child;
}
