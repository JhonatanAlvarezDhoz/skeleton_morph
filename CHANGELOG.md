## 0.1.1

- Added a centered image icon to `SkeletonImage` by default.
- Added `showIcon`, `icon`, `iconSize`, and `iconColor` customization options to `SkeletonImage`.
- Added optional `child` support to `SkeletonBox` for semantic placeholder composition.

## 0.1.0

Initial development release.

- Added `SkeletonMorph` as the main widget for generating skeletons from real UI trees.
- Added reusable skeleton widgets: `SkeletonBox`, `SkeletonText`, `SkeletonImage`, `SkeletonCard`, and `SkeletonList`.
- Added annotation widgets: `SkeletonHint`, `SkeletonReplace`, and `SkeletonIgnore`.
- Added configurable effects: shimmer, pulse, and static.
- Added `SkeletonTheme` and `SkeletonConfig` for shared styling.
- Added example app and initial widget tests.
- Fixed `PulseEffect` so it repeats continuously while mounted and disposes its animation controller correctly.
