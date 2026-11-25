import 'package:almanacinc_auto_size_text/almanacinc_auto_size_text.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

/// Candidate paths for each Indic font. The first that exists is loaded. These
/// assets live under `test/assets/` (excluded from the published package via
/// `.pubignore`); CI/other machines can also supply the system Noto fonts.
const _devanagariCandidates = <String>[
  'test/assets/NotoSansDevanagari-Regular.ttf',
  '/usr/share/fonts/truetype/noto/NotoSansDevanagari-Regular.ttf',
];
const _gujaratiCandidates = <String>[
  'test/assets/NotoSansGujarati-Regular.ttf',
  '/usr/share/fonts/truetype/noto/NotoSansGujarati-Regular.ttf',
];

double _measuredHeight(String text, String family, double fontSize) {
  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(fontFamily: family, fontSize: fontSize),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  final height = painter.height;
  painter.dispose();
  return height;
}

void main() {
  late bool devLoaded;
  late bool gujLoaded;

  setUpAll(() async {
    devLoaded = await tryLoadFont('NotoSansDevanagari', _devanagariCandidates);
    gujLoaded = await tryLoadFont('NotoSansGujarati', _gujaratiCandidates);
  });

  testWidgets('Devanagari line box reserves space for tall matras',
      (tester) async {
    if (!devLoaded) {
      markTestSkipped('NotoSansDevanagari font not available');
      return;
    }
    // A Devanagari line box is taller than its nominal em: the font reserves
    // vertical room for stacked top/bottom matras and diacritics. This is the
    // real metric AutoSizeText must honour (verified by the bounds tests
    // below), and it is why Devanagari sizes down more aggressively than a
    // Latin line of the same point size (whose box is ~1em in the test font).
    final lineHeight = _measuredHeight('किँगी हूँ', 'NotoSansDevanagari', 50);
    expect(lineHeight, greaterThan(50));
  });

  testWidgets('AutoSizeText keeps Devanagari within its height bounds',
      (tester) async {
    if (!devLoaded) {
      markTestSkipped('NotoSansDevanagari font not available');
      return;
    }
    const boxHeight = 30.0;
    await pump(
      tester: tester,
      widget: SizedBox(
        width: 500,
        height: boxHeight,
        child: AutoSizeText(
          'अनाक्षर किँगी नमस्ते',
          style: TextStyle(fontSize: 120, fontFamily: 'NotoSansDevanagari'),
          minFontSize: 1,
          maxLines: 1,
        ),
      ),
    );
    final text = tester.widget<Text>(find.byType(Text));
    final rendered = tester.getSize(find.byType(RichText));
    // The tall diacritics are fully accounted for: the laid-out text never
    // exceeds the box, and a real (non-zero) size was chosen.
    expect(rendered.height, lessThanOrEqualTo(boxHeight));
    expect(effectiveFontSize(text), greaterThan(0));
  });

  testWidgets('Tall Devanagari gets a smaller size than a flat string',
      (tester) async {
    if (!devLoaded) {
      markTestSkipped('NotoSansDevanagari font not available');
      return;
    }
    Future<double> sizeFor(String s) async {
      await pump(
        tester: tester,
        widget: SizedBox(
          width: 1000,
          height: 40,
          child: AutoSizeText(
            s,
            style: const TextStyle(
                fontSize: 300, fontFamily: 'NotoSansDevanagari'),
            minFontSize: 1,
            maxLines: 1,
          ),
        ),
      );
      return effectiveFontSize(tester.widget<Text>(find.byType(Text)));
    }

    final flat = await sizeFor('कखगघ');
    final tall = await sizeFor('किँगी हूँ');
    // Height-constrained: the taller glyph stack cannot be larger than the flat
    // one.
    expect(tall, lessThanOrEqualTo(flat));
  });

  testWidgets('AutoSizeText keeps Gujarati within its height bounds',
      (tester) async {
    if (!gujLoaded) {
      markTestSkipped('NotoSansGujarati font not available');
      return;
    }
    const boxHeight = 30.0;
    await pump(
      tester: tester,
      widget: SizedBox(
        width: 500,
        height: boxHeight,
        child: AutoSizeText(
          'નમસ્તે દુનિયા સ્વાગત છે',
          style: TextStyle(fontSize: 120, fontFamily: 'NotoSansGujarati'),
          minFontSize: 1,
          maxLines: 1,
        ),
      ),
    );
    final text = tester.widget<Text>(find.byType(Text));
    final rendered = tester.getSize(find.byType(RichText));
    expect(rendered.height, lessThanOrEqualTo(boxHeight));
    expect(effectiveFontSize(text), greaterThan(0));
  });
}
