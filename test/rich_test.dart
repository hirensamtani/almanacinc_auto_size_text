import 'package:almanacinc_auto_size_text/almanacinc_auto_size_text.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

void main() {
  testWidgets('Rich text shrinks to fit width', (tester) async {
    await pumpAndExpectFontSize(
      tester: tester,
      expectedFontSize: 20,
      widget: SizedBox(
        width: 100,
        child: AutoSizeText.rich(
          TextSpan(text: 'XXXXX'),
          style: TextStyle(fontSize: 60),
          maxLines: 1,
        ),
      ),
    );
  });

  testWidgets('Rich text with children is preserved and sized', (tester) async {
    await pumpAndExpectFontSize(
      tester: tester,
      expectedFontSize: 20,
      widget: SizedBox(
        width: 100,
        child: AutoSizeText.rich(
          TextSpan(
            text: 'X',
            children: [TextSpan(text: 'XXXX')],
          ),
          style: TextStyle(fontSize: 60),
          maxLines: 1,
        ),
      ),
    );

    final richText = getRichText(tester);
    expect(richText.text.toPlainText(), 'XXXXX');
  });

  testWidgets('Rich text builds a Text.rich (no data)', (tester) async {
    final text = await pumpAndGetText(
      tester: tester,
      widget: AutoSizeText.rich(
        TextSpan(text: 'Hello'),
        style: TextStyle(fontSize: 20),
      ),
    );
    expect(text.data, isNull);
    expect(text.textSpan, isNotNull);
  });

  testWidgets('Rich overflowReplacement shows on overflow', (tester) async {
    final text = await pumpAndGetText(
      tester: tester,
      widget: SizedBox(
        width: 100,
        height: 20,
        child: AutoSizeText.rich(
          TextSpan(text: 'XXXXXX'),
          minFontSize: 20,
          overflowReplacement: Text('OVERFLOW!'),
        ),
      ),
    );
    expect(text.data, 'OVERFLOW!');
  });
}
