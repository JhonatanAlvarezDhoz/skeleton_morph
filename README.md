# skeleton_morph

Create automatic loading skeletons from your real Flutter UI, with optional hints for precise placeholders in cards, images, text, lists, and custom widgets.

## Version

Current version: `0.1.0`

## Features

- Automatic skeletons for common Flutter widgets.
- `SkeletonHint` to guide placeholder generation.
- `SkeletonReplace` for fully custom skeletons.
- `SkeletonIgnore` to keep parts of the UI unchanged.
- Reusable primitives: `SkeletonBox`, `SkeletonText`, `SkeletonImage`, `SkeletonCard`, and `SkeletonList`.
- Configurable effects: shimmer, pulse, and static.
- Shared styling through `SkeletonTheme` and `SkeletonConfig`.

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  skeleton_morph: ^0.1.0
```

Then import it:

```dart
import 'package:skeleton_morph/skeleton_morph.dart';
```

## Core concept

`SkeletonMorph` is the widget that transforms your real UI into a skeleton.

```dart
SkeletonMorph(
  enabled: isLoading,
  child: const Text('Loaded title'),
)
```

When `enabled` is `false`, the original child is rendered. When `enabled` is `true`, `skeleton_morph` renders a skeleton version of that widget tree.

### What needs to be inside `SkeletonMorph`?

| API | Needs `SkeletonMorph`? | Why |
| --- | --- | --- |
| `SkeletonHint` | Yes | It is metadata read by the automatic skeletonizer. Alone, it renders its child unchanged. |
| `SkeletonReplace` | Yes | It replaces the real child only when `SkeletonMorph(enabled: true)` analyzes it. |
| `SkeletonIgnore` | Yes | It tells the analyzer to keep that subtree unchanged. |
| `Text`, `Image`, `Container`, layouts | Yes | They are converted only when wrapped by `SkeletonMorph`. |
| `SkeletonBox`, `SkeletonText`, `SkeletonImage`, `SkeletonCard`, `SkeletonList` | No | These are manual skeleton widgets and can be used directly. |
| `SkeletonTheme` | No | It provides global configuration to every skeleton below it. |

## Global configuration

Use `SkeletonTheme` once above the part of the app that uses skeletons.

```dart
SkeletonTheme(
  config: const SkeletonConfig(
    effect: PulseEffect(),
    animationDuration: Duration(milliseconds: 900),
  ),
  child: MyApp(),
)
```

Every `SkeletonMorph` below that theme will use the same config. You do not need to pass `config` to each `SkeletonMorph`.

For a local override:

```dart
SkeletonMorph(
  enabled: isLoading,
  config: const SkeletonConfig(
    effect: StaticEffect(),
  ),
  child: MyWidget(),
)
```

## Hints for custom widgets

Use `SkeletonHint` when the child is a custom widget that `skeleton_morph` cannot infer automatically.

> `SkeletonHint` must be inside a `SkeletonMorph` tree. The size goes on the hint, not only on the child.

```dart
SkeletonMorph(
  enabled: isLoading,
  child: SkeletonHint.box(
    width: 200,
    height: 80,
    child: MyCustomCard(),
  ),
)
```

For custom text-like widgets:

```dart
SkeletonMorph(
  enabled: isLoading,
  child: SkeletonHint.text(
    width: 140,
    height: 16,
    child: CustomText('Movement title'),
  ),
)
```

For custom image-like widgets:

```dart
SkeletonMorph(
  enabled: isLoading,
  child: SkeletonHint.image(
    width: 96,
    height: 96,
    borderRadius: BorderRadius.circular(16),
    child: ProductImage(url: imageUrl),
  ),
)
```

`SkeletonImage` shows a centered image icon by default. You can customize or hide it when composing manual skeletons:

```dart
const SkeletonImage(
  width: 96,
  height: 96,
  showIcon: true,
  icon: Icons.image_outlined,
)
```

## Manual replacement

Use `SkeletonReplace` when automatic inference is not enough.

```dart
SkeletonMorph(
  enabled: isLoading,
  child: SkeletonReplace(
    skeleton: const SkeletonBox(width: 50, height: 50),
    child: Avatar(user: user),
  ),
)
```

## Ignoring content

Use `SkeletonIgnore` for widgets that should remain visible while loading.

```dart
SkeletonMorph(
  enabled: isLoading,
  child: SkeletonIgnore(
    child: IconButton(
      icon: const Icon(Icons.more_vert),
      onPressed: onMorePressed,
    ),
  ),
)
```

## Example

```dart
import 'package:flutter/material.dart';
import 'package:skeleton_morph/skeleton_morph.dart';

void main() {
  runApp(
    const SkeletonTheme(
      config: SkeletonConfig(
        effect: ShimmerEffect(),
      ),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('skeleton_morph'),
          actions: [
            Switch(
              value: isLoading,
              onChanged: (value) => setState(() => isLoading = value),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SkeletonMorph(
            enabled: isLoading,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    SkeletonHint.image(
                      width: 64,
                      height: 64,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 64,
                        height: 64,
                        color: Colors.blue.shade100,
                        child: const Icon(Icons.image),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Product title'),
                          SizedBox(height: 8),
                          Text('Product description'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

## Null safety

`skeleton_morph` supports sound null safety through its Dart SDK constraint:

```yaml
environment:
  sdk: ">=3.3.0 <4.0.0"
```

## Additional information

Issues, feature requests, and contributions should be reported through the package repository.
