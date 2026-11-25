import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// The rendered font size of [text], resolved through its [Text.textScaler].
///
/// `AutoSizeText` bakes the chosen size into `style.fontSize` and renders plain
/// text with [TextScaler.noScaling], and rich text with a linear scaler. In
/// both cases `scaler.scale(style.fontSize)` yields the on-screen pixel size.
double effectiveFontSize(Text text) {
  final scaler = text.textScaler ?? TextScaler.noScaling;
  return scaler.scale(text.style!.fontSize!);
}

Future<void> pump({
  required WidgetTester tester,
  required Widget widget,
}) async {
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: widget,
      ),
    ),
  );
}

Future<Text> pumpAndGetText({
  required WidgetTester tester,
  required Widget widget,
}) async {
  await pump(tester: tester, widget: widget);
  return tester.widget<Text>(find.byType(Text));
}

Future<void> pumpAndExpectFontSize({
  required WidgetTester tester,
  required double expectedFontSize,
  required Widget widget,
}) async {
  final text = await pumpAndGetText(tester: tester, widget: widget);
  expect(effectiveFontSize(text), expectedFontSize);
}

RichText getRichText(WidgetTester tester) =>
    tester.widget(find.byType(RichText));

/// Attempts to register a font [family] from the first existing path in
/// [candidatePaths]. Returns `true` on success, `false` if none were found.
///
/// Used by the Indic-script tests to load a real Devanagari/Gujarati face so
/// that tall matras/diacritics produce genuine glyph metrics (the default test
/// font renders every glyph as a uniform box). Fonts are loaded from the host
/// at runtime and are never shipped in the published package.
Future<bool> tryLoadFont(String family, List<String> candidatePaths) async {
  for (final path in candidatePaths) {
    final file = File(path);
    if (!file.existsSync()) continue;
    try {
      final bytes = await file.readAsBytes();
      final loader = FontLoader(family)
        ..addFont(Future.value(ByteData.sublistView(bytes)));
      await loader.load();
      return true;
    } catch (_) {
      // Try the next candidate.
    }
  }
  return false;
}
