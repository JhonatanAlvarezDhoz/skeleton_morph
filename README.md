# skeleton_morph

<p align="center">
  <img src="https://raw.githubusercontent.com/JhonatanAlvarezDhoz/assets/main/branding/banner.png" alt="skeleton_morph banner" width="100%" />
</p>

Create automatic loading skeletons from your real Flutter UI, with optional hints for precise placeholders in cards, images, text, lists, and custom widgets.

## Effects demo

| <div align="center">Pulse effect</div> | <div align="center">Shimmer effect</div> |
| :---: | :---: |
| <div align="center"><img src="https://raw.githubusercontent.com/JhonatanAlvarezDhoz/assets/main/preview/gif/pulseEffect.gif" alt="PulseEffect demo" width="320" /></div> | <div align="center"><img src="https://raw.githubusercontent.com/JhonatanAlvarezDhoz/assets/main/preview/gif/shimmerEffect.gif" alt="ShimmerEffect demo" width="320" /></div> |
| Use `PulseEffect()` for a soft breathing placeholder animation. | Use `ShimmerEffect()` for a moving highlight placeholder animation. |

> Demo preview fallback: if the animations are not rendered on Pub.dev, open the GitHub README to view the animated demos:
>
> [Open GitHub README demos](https://github.com/JhonatanAlvarezDhoz/skeleton_morph/blob/main/README.md#effects-demo)

## Version

 <a href="https://pub.dev/packages/skeleton_morph">
    <img src="https://img.shields.io/pub/v/skeleton_morph.svg" alt="Pub Version" />
  </a>

## Platform support

`skeleton_morph` is a pure Flutter widget package and supports all Flutter platforms.

<p>
  <img src="https://img.shields.io/badge/Android-supported-brightgreen?logo=android" alt="Android supported" />
  <img src="https://img.shields.io/badge/iOS-supported-brightgreen?logo=apple" alt="iOS supported" />
  <img src="https://img.shields.io/badge/Web-supported-brightgreen?logo=googlechrome" alt="Web supported" />
  <img src="https://img.shields.io/badge/macOS-supported-brightgreen?logo=apple" alt="macOS supported" />
  <img src="https://img.shields.io/badge/Windows-supported-brightgreen?logo=windows" alt="Windows supported" />
  <img src="https://img.shields.io/badge/Linux-supported-brightgreen?logo=linux" alt="Linux supported" />
</p>

## Features

- Automatic skeletons for common Flutter widgets.
- `SkeletonHint` to guide placeholder generation.
- `SkeletonReplace` for fully custom skeletons.
- `SkeletonIgnore` to keep parts of the UI unchanged.
- Reusable primitives: `SkeletonBox`, `SkeletonText`, `SkeletonImage`, `SkeletonCard`, and `SkeletonList`.
- Configurable effects: shimmer, pulse, and static.
- Configurable transitions between skeleton and real content.
- Shared styling through `SkeletonTheme` and `SkeletonConfig`.

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  skeleton_morph: ^0.2.0
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

### Transitions

`SkeletonEffect` animates the placeholder while loading. `SkeletonTransition` animates the switch between the skeleton tree and the real content tree.

The default transition is `FadeSkeletonTransition`. You can configure transitions globally:

```dart
SkeletonTheme(
  config: const SkeletonConfig(
    transition: FadeThroughSkeletonTransition(),
    transitionDuration: Duration(milliseconds: 300),
  ),
  child: MyApp(),
)
```

To disable transitions globally, set `NoSkeletonTransition` in `SkeletonTheme`:

```dart
SkeletonTheme(
  config: const SkeletonConfig(
    transition: NoSkeletonTransition(),
  ),
  child: MyApp(),
)
```

Available transitions:

- `FadeSkeletonTransition`: simple cross-fade between skeleton and content.
- `FadeThroughSkeletonTransition`: fades through the loading state, useful when skeleton and content shapes differ.
- `ScaleFadeSkeletonTransition`: fades and subtly scales the incoming subtree.
- `NoSkeletonTransition`: disables skeleton/content transition animations.

For a local transition override:

```dart
SkeletonMorph(
  enabled: isLoading,
  config: const SkeletonConfig(
    transition: ScaleFadeSkeletonTransition(),
  ),
  child: ProductCard(),
)
```

To disable the transition only for one `SkeletonMorph`, use
`NoSkeletonTransition`:

```dart
SkeletonMorph(
  enabled: isLoading,
  config: const SkeletonConfig(
    transition: NoSkeletonTransition(),
  ),
  child: ProductCard(),
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
