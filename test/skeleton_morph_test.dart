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
}
