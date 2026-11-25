import 'package:almanacinc_auto_size_text/almanacinc_auto_size_text.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

/// A deliberately non-linear [TextScaler]: it doubles small font sizes but
/// grows more slowly above 20pt. Used to prove that scaling flows through
/// [TextScaler.scale] rather than a single hard-coded multiplier.
class _SquashScaler extends TextScaler {
  const _SquashScaler();

  @override
  double scale(double fontSize) =>
      fontSize <= 20 ? fontSize * 2 : 40 + (fontSize - 20);

  @override
  // ignore: deprecated_member_use
  double get textScaleFactor => 2;
}

void main() {
  testWidgets('Linear TextScaler enlarges text that already fits',
      (tester) async {
    await pumpAndExpectFontSize(
      tester: tester,
      expectedFontSize: 60,
      widget: AutoSizeText(
        'Some Text',
        style: TextStyle(fontSize: 15),
        textScaler: TextScaler.linear(4),
      ),
    );
  });

  testWidgets('Ambient MediaQuery TextScaler is honored', (tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: AutoSizeText(
              'Some Text',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
      ),
    );
    final text = tester.widget<Text>(find.byType(Text));
    expect(effectiveFontSize(text), 30);
  });

  testWidgets('Non-linear TextScaler drives the scale', (tester) async {
    // scale(15) == 30, so a fitting default font renders at 30pt.
    await pumpAndExpectFontSize(
      tester: tester,
      expectedFontSize: 30,
      widget: AutoSizeText(
        'X',
        style: TextStyle(fontSize: 15),
        textScaler: _SquashScaler(),
      ),
    );
  });

  testWidgets('Deprecated textScaleFactor still works', (tester) async {
    await pumpAndExpectFontSize(
      tester: tester,
      expectedFontSize: 60,
      widget: AutoSizeText(
        'Some Text',
        style: TextStyle(fontSize: 15),
        // ignore: deprecated_member_use_from_same_package
        textScaleFactor: 4,
      ),
    );
  });

  testWidgets('textScaler and textScaleFactor are mutually exclusive',
      (tester) async {
    expect(
      () => AutoSizeText(
        'Some Text',
        textScaler: TextScaler.noScaling,
        // ignore: deprecated_member_use_from_same_package
        textScaleFactor: 2,
      ),
      throwsAssertionError,
    );
  });
}
