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

## Usage

```dart
SkeletonMorph(
  enabled: isLoading,
  child: const Text('Loaded title'),
)
```

When `enabled` is `false`, the original child is rendered. When `enabled` is `true`, `skeleton_morph` renders a skeleton version of that widget tree.

### Custom configuration

```dart
SkeletonTheme(
  config: const SkeletonConfig(
    effect: ShimmerEffect(),
  ),
  child: MyPage(),
)
```

### Hints for custom widgets

```dart
SkeletonHint.image(
  width: 96,
  height: 96,
  borderRadius: BorderRadius.circular(16),
  child: ProductImage(url: imageUrl),
)
```

### Manual replacement

```dart
SkeletonReplace(
  skeleton: const SkeletonBox(width: 50, height: 50),
  child: Avatar(user: user),
)
```

## Example

See the `/example` folder for a runnable Flutter example.

## Null safety

`skeleton_morph` supports sound null safety through its Dart SDK constraint:

```yaml
environment:
  sdk: ">=3.3.0 <4.0.0"
```

## Additional information

Issues, feature requests, and contributions should be reported through the package repository.
