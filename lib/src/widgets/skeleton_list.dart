import 'package:flutter/widgets.dart';

/// Reusable skeleton list.
///
/// This widget does not try to infer a list from existing content. It is a
/// builder-based helper for manual loading states where the consumer already
/// knows what one skeleton row should look like.
///
/// Design pattern: Builder.
/// The package controls the repeated structure while the consumer provides how
/// each skeleton item should look.
class SkeletonList extends StatelessWidget {
  const SkeletonList({
    super.key,
    required this.itemBuilder,
    this.itemCount = 6,
    this.separatorBuilder,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
  });

  /// Number of skeleton rows/items to render.
  final int itemCount;

  /// Builds each skeleton item.
  final IndexedWidgetBuilder itemBuilder;

  /// Optional separator between skeleton items.
  final IndexedWidgetBuilder? separatorBuilder;

  /// List padding.
  final EdgeInsetsGeometry? padding;

  /// Scroll physics forwarded to the underlying list.
  final ScrollPhysics? physics;

  /// Whether the list should size itself to its children.
  final bool shrinkWrap;

  /// Scroll direction for the generated list.
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    if (separatorBuilder == null) {
      return ListView.builder(
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        padding: padding,
        physics: physics,
        shrinkWrap: shrinkWrap,
        scrollDirection: scrollDirection,
      );
    }

    return ListView.separated(
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      separatorBuilder: separatorBuilder!,
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
      scrollDirection: scrollDirection,
    );
  }
}
