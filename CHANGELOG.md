## 1.0.0

Initial release of `almanacinc_auto_size_text`, maintained by Almanac Inc.

This package is a modernized derivative of the original
[`auto_size_text`](https://github.com/leisim/auto_size_text) `3.0.0` by
Simon Leier (MIT), updated for Flutter 3.16+:

* **`TextScaler` support.** Added the `textScaler` parameter and resolution via
  `MediaQuery.textScalerOf`, replacing the deprecated
  `MediaQuery.textScaleFactorOf`. The old `textScaleFactor` parameter is kept as
  `@Deprecated` for a seamless migration (an assert prevents passing both).
* **Leak-free measurement.** Every internal `TextPainter` is now disposed in a
  `try`/`finally` block, preventing native `Paragraph` memory leaks.
* **Modern `Text` pass-through.** Forwards `selectionColor`, `textWidthBasis`
  and `textHeightBehavior` to the underlying `Text`/`Text.rich`.
* **Dart 3.** Internals use a typed record `(double fontSize, bool fits)` while
  keeping the O(log n) binary-search font sizing.
* Retains full support for `AutoSizeGroup`, `AutoSizeGroupBuilder`,
  `AutoSizeText.rich`, `presetFontSizes`, `wrapWords`, `overflowReplacement`,
  and correct rendering of tall Indic (Devanagari/Gujarati) diacritics.
