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
/// `SkeletonMorph` is the boundary between the loaded UI and the loading UI.
/// Annotation widgets such as `SkeletonHint`, `SkeletonReplace`, and
/// `SkeletonIgnore` only have special behavior when they are inside this
/// boundary. Outside of it, they simply render their child.
///
/// Use [config] for a local override, or wrap a higher subtree with
/// `SkeletonTheme` for app-wide defaults.
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

  /// Whether the child should be transformed into a skeleton.
  final bool enabled;

  /// Real UI that should be shown when [enabled] is false and analyzed when
  /// [enabled] is true.
  final Widget child;

  /// Optional local configuration override for this skeleton subtree.
  final SkeletonConfig? config;

  /// Optional custom analyzer.
  ///
  /// This is mostly useful for tests or advanced integrations that want to
  /// replace the default widget-to-skeleton mapping.
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
      // Loading placeholders should not behave like real controls. Ignoring
      // pointer events avoids accidental taps on UI that is not ready yet.
      content = IgnorePointer(child: content);
    }

    if (config != null) {
      // Local config overrides are exposed to nested manual skeleton widgets
      // through a short-lived SkeletonTheme.
      return SkeletonTheme(
        config: effectiveConfig,
        child: content,
      );
    }

    return content;
  }

  /// Convenience constructor for list loading states.
  ///
  /// Lists often need a different item count while loading. This constructor
  /// switches between [itemBuilder]/[itemCount] and
  /// [skeletonBuilder]/[skeletonCount] without forcing consumers to write that
  /// branching logic at every call site.
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
