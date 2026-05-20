import 'package:flutter/widgets.dart';

import '../analyzer/widget_skeletonizer.dart';
import '../core/skeleton_config.dart';
import '../core/skeleton_context.dart';
import '../core/skeleton_theme.dart';
import 'skeleton_list.dart';

/// Main entry point of the package.
///
/// It receives the real UI and renders either:
/// - [child], when [enabled] is false.
/// - a skeleton version of [child], when [enabled] is true.
///
/// Design patterns:
/// - Decorator/Proxy: wraps another widget and changes behavior based on state.
/// - Facade: hides the analyzer complexity behind a simple public API.
class SkeletonMorph extends StatelessWidget {
  const SkeletonMorph({
    super.key,
    required this.enabled,
    required this.child,
    this.config,
    this.skeletonizer,
  });

  final bool enabled;
  final Widget child;
  final SkeletonConfig? config;
  final WidgetSkeletonizer? skeletonizer;

  @override
  Widget build(BuildContext context) {
    final effectiveConfig = config ?? SkeletonConfig.of(context);

    Widget content = enabled
        ? (skeletonizer ?? WidgetSkeletonizer()).build(
            child,
            SkeletonBuildContext(
              flutterContext: context,
              config: effectiveConfig,
              depth: 0,
            ),
          )
        : child;

    if (enabled && effectiveConfig.ignorePointersWhenLoading) {
      content = IgnorePointer(child: content);
    }

    if (config != null) {
      return SkeletonTheme(
        config: effectiveConfig,
        child: content,
      );
    }

    return content;
  }

  factory SkeletonMorph.list({
    Key? key,
    required bool enabled,
    required IndexedWidgetBuilder itemBuilder,
    required IndexedWidgetBuilder skeletonBuilder,
    required int itemCount,
    int skeletonCount = 6,
    IndexedWidgetBuilder? separatorBuilder,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
  }) {
    return _SkeletonMorphList(
      key: key,
      enabled: enabled,
      itemBuilder: itemBuilder,
      skeletonBuilder: skeletonBuilder,
      itemCount: itemCount,
      skeletonCount: skeletonCount,
      separatorBuilder: separatorBuilder,
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
    );
  }
}

class _SkeletonMorphList extends SkeletonMorph {
  _SkeletonMorphList({
    super.key,
    required super.enabled,
    required IndexedWidgetBuilder itemBuilder,
    required IndexedWidgetBuilder skeletonBuilder,
    required int itemCount,
    required int skeletonCount,
    IndexedWidgetBuilder? separatorBuilder,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
  }) : super(
          child: Builder(
            builder: (context) {
              if (enabled) {
                return SkeletonList(
                  itemCount: skeletonCount,
                  itemBuilder: skeletonBuilder,
                  separatorBuilder: separatorBuilder,
                  padding: padding,
                  physics: physics,
                  shrinkWrap: shrinkWrap,
                );
              }

              return SkeletonList(
                itemCount: itemCount,
                itemBuilder: itemBuilder,
                separatorBuilder: separatorBuilder,
                padding: padding,
                physics: physics,
                shrinkWrap: shrinkWrap,
              );
            },
          ),
        );
}
