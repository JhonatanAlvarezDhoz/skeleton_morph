import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skeleton_morph/skeleton_morph.dart';

void main() {
  testWidgets('shows child when disabled', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SkeletonMorph(
          enabled: false,
          child: Text('Loaded title'),
        ),
      ),
    );

    expect(find.text('Loaded title'), findsOneWidget);
  });

  testWidgets('hides original text when enabled', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SkeletonMorph(
          enabled: true,
          child: Text('Loaded title'),
        ),
      ),
    );

    expect(find.text('Loaded title'), findsNothing);
    expect(find.byType(SkeletonText), findsOneWidget);
  });

  testWidgets('uses SkeletonReplace when enabled', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SkeletonMorph(
          enabled: true,
          child: SkeletonReplace(
            skeleton: SkeletonBox(width: 50, height: 50),
            child: Text('Real content'),
          ),
        ),
      ),
    );

    expect(find.text('Real content'), findsNothing);
    expect(find.byType(SkeletonBox), findsOneWidget);
  });

  testWidgets('skeletonizes Padding child when enabled', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SkeletonMorph(
          enabled: true,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('Padded content'),
          ),
        ),
      ),
    );

    expect(find.text('Padded content'), findsNothing);
    expect(find.byType(Padding), findsWidgets);
    expect(find.byType(SkeletonText), findsOneWidget);
  });

  testWidgets('PulseEffect repeats while skeleton is mounted', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SkeletonTheme(
          config: SkeletonConfig(
            effect: PulseEffect(minOpacity: 0.2, maxOpacity: 1.0),
            animationDuration: Duration(milliseconds: 100),
          ),
          child: SkeletonBox(width: 20, height: 20),
        ),
      ),
    );

    double opacity() {
      final transition = tester
          .widgetList<FadeTransition>(find.byType(FadeTransition))
          .where((transition) => transition.child is Container)
          .single;
      return transition.opacity.value;
    }

    final initialOpacity = opacity();

    await tester.pump(const Duration(milliseconds: 50));
    final midOpacity = opacity();

    await tester.pump(const Duration(milliseconds: 25));
    final laterOpacity = opacity();

    expect(midOpacity, isNot(equals(initialOpacity)));
    expect(laterOpacity, isNot(equals(midOpacity)));

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
