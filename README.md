# almanacinc_auto_size_text

[![pub package](https://img.shields.io/pub/v/almanacinc_auto_size_text.svg)](https://pub.dev/packages/almanacinc_auto_size_text)

A Flutter widget that automatically resizes text to fit perfectly within its
bounds. Maintained by **Almanac Inc.** and modernized for **Flutter 3.16+**.

This package is a modernized derivative of the original
[`auto_size_text`](https://github.com/leisim/auto_size_text) by Simon Leier,
redistributed under the MIT License (see [Attribution](#attribution)).

## What's new in this fork

- **`TextScaler` support** — uses `MediaQuery.textScalerOf` and a new
  `textScaler` parameter, replacing the deprecated `textScaleFactor` /
  `MediaQuery.textScaleFactorOf`.
- **Zero `TextPainter` leaks** — every painter created while measuring is
  disposed in a `try`/`finally` block.
- **Modern `Text` parameters** — `selectionColor`, `textWidthBasis`,
  `textHeightBehavior`.
- **Correct Indic rendering** — tall Devanagari/Gujarati matras and diacritics
  are measured accurately, so text is sized to its real height.
- Pure Dart/Flutter package: supports Android, iOS, web, macOS, Windows, Linux.

## Installation

```yaml
dependencies:
  almanacinc_auto_size_text: ^1.0.0
```

```dart
import 'package:almanacinc_auto_size_text/almanacinc_auto_size_text.dart';
```

## Usage

### `AutoSizeText`

Behaves like `Text`, but automatically resizes to respect its constraints.

```dart
SizedBox(
  width: 200,
  child: AutoSizeText(
    'The text to display',
    style: TextStyle(fontSize: 40),
    maxLines: 2,
  ),
)
```

### `maxLines`

The text is resized (and wrapped) to fit within `maxLines`:

```dart
AutoSizeText(
  'A really long String',
  style: TextStyle(fontSize: 30),
  maxLines: 2,
)
```

### `minFontSize` & `maxFontSize`

Constrain the resulting size. If the text still doesn't fit at `minFontSize`,
it is handled according to `overflow` (or `overflowReplacement`).

```dart
AutoSizeText(
  'A really long String',
  style: TextStyle(fontSize: 30),
  minFontSize: 18,
  maxLines: 4,
  overflow: TextOverflow.ellipsis,
)
```

### `presetFontSizes`

Restrict sizing to a fixed, **descending** set of sizes:

```dart
AutoSizeText(
  'A really long String',
  presetFontSizes: [40, 20, 14],
  maxLines: 4,
)
```

### `overflowReplacement`

Show a different widget when the text cannot fit even at `minFontSize`:

```dart
AutoSizeText(
  'A really long String',
  minFontSize: 18,
  overflowReplacement: Text('Too long!'),
)
```

### `textScaler`

Control accessibility text scaling. Prefer `textScaler` over the deprecated
`textScaleFactor`:

```dart
AutoSizeText(
  'A really long String',
  textScaler: TextScaler.linear(2.0),
)
```

If `textScaler` is null the widget falls back to `MediaQuery.textScalerOf`.

### `AutoSizeText.rich`

Supports `TextSpan` trees. Each `TextSpan` is scaled relative to the root
`style.fontSize`:

```dart
AutoSizeText.rich(
  TextSpan(
    text: 'Hello ',
    children: [
      TextSpan(text: 'World', style: TextStyle(fontWeight: FontWeight.bold)),
    ],
  ),
  style: TextStyle(fontSize: 30),
  maxLines: 1,
)
```

### `AutoSizeGroup`

Synchronize the font size across multiple `AutoSizeText`s — they all adopt the
size of the smallest one:

```dart
final group = AutoSizeGroup();

AutoSizeText('Text 1', group: group);
AutoSizeText('Text 2', group: group);
```

Or scope a group to a subtree with `AutoSizeGroupBuilder`:

```dart
AutoSizeGroupBuilder(
  builder: (context, group) => Column(
    children: [
      AutoSizeText('Text 1', group: group),
      AutoSizeText('Text 2', group: group),
    ],
  ),
)
```

### Indic scripts (Devanagari, Gujarati, …)

Tall matras and stacked diacritics increase the measured line height.
`AutoSizeText` accounts for this, so Hindi/Gujarati strings are sized to their
real bounds rather than clipping:

```dart
SizedBox(
  width: 220,
  height: 56,
  child: AutoSizeText(
    'નમસ્તે દુનિયા, સ્વાગત છે',
    style: TextStyle(fontSize: 40),
    maxLines: 1,
  ),
)
```

### Layout notes

`AutoSizeText` uses a `LayoutBuilder` internally to measure the available space
before sizing the text. Because of this, it should **not** be wrapped directly
inside an `IntrinsicHeight` or `IntrinsicWidth`, which ask their child for an
intrinsic size that a `LayoutBuilder` cannot provide (this throws at layout
time). Give the widget bounded constraints instead — for example a `SizedBox`,
an `Expanded`, or a fixed-size parent.

## Parameters

Most parameters mirror Flutter's `Text` widget. Additional parameters:

| Parameter             | Description                                                      |
| --------------------- | ---------------------------------------------------------------- |
| `minFontSize`         | Smallest size (ignored when `presetFontSizes` is set).           |
| `maxFontSize`         | Largest size (ignored when `presetFontSizes` is set).            |
| `stepGranularity`     | Size step used while sizing.                                     |
| `presetFontSizes`     | Fixed, descending list of allowed sizes.                         |
| `group`               | `AutoSizeGroup` to synchronize multiple widgets.                 |
| `wrapWords`           | If `false`, words that don't fit shrink instead of wrapping.     |
| `overflowReplacement` | Widget shown when text can't fit even at `minFontSize`.          |
| `textScaler`          | Accessibility scaling (replaces deprecated `textScaleFactor`).   |

## Example

A complete, runnable example lives in [`example/`](example/lib/main.dart).

## Attribution

This package is based on
[`auto_size_text`](https://github.com/leisim/auto_size_text) by Simon Leier,
used under the MIT License. The original copyright
(`Copyright (c) 2018 Simon Leier`) is retained in [LICENSE](LICENSE) alongside
`Copyright (c) 2026 Almanac Inc.`

## License

MIT — see [LICENSE](LICENSE).
