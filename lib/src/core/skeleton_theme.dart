import 'package:flutter/widgets.dart';

import 'skeleton_config.dart';

/// Provides a shared [SkeletonConfig] to all skeleton_morph widgets below it.
///
/// Design pattern: Inherited Configuration / Theme.
/// Similar to Flutter's Theme, this avoids passing visual configuration through
/// every widget constructor.
class SkeletonTheme extends StatelessWidget {
  const SkeletonTheme({
    super.key,
    required this.config,
    required this.child,
  });

  final SkeletonConfig config;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SkeletonThemeData(
      config: config,
      child: child,
    );
  }
}
