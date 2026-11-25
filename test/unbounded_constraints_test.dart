import 'package:almanacinc_auto_size_text/almanacinc_auto_size_text.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

/// Wraps [child] so it receives an unbounded (infinite) maximum width, the way
/// a horizontal [Row]/[ListView] or an [UnconstrainedBox] would.
Widget unboundedWidth(Widget child) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [child],
  );
}

void main() {
  testWidgets('Keeps default size under unbounded width', (tester) async {
    await pumpAndExpectFontSize(
      tester: tester,
      expectedFontSize: 30,
      widget: unboundedWidth(
        AutoSizeText(
          'XXXXX',
          style: TextStyle(fontSize: 30),
          maxLines: 1,
        ),
      ),
    );
  });

  testWidgets('Clamps to maxFontSize under unbounded width', (tester) async {
    await pumpAndExpectFontSize(
      tester: tester,
      expectedFontSize: 20,
      widget: unboundedWidth(
        AutoSizeText(
          'XXXXX',
          style: TextStyle(fontSize: 80),
          maxFontSize: 20,
          maxLines: 1,
        ),
      ),
    );
  });

  testWidgets('overflowReplacement never triggers when text always fits',
      (tester) async {
    final text = await pumpAndGetText(
      tester: tester,
      widget: unboundedWidth(
        AutoSizeText(
          'XXXXXXXXXX',
          style: TextStyle(fontSize: 40),
          minFontSize: 10,
          maxLines: 1,
          overflowReplacement: Text('OVERFLOW!'),
        ),
      ),
    );
    expect(text.data, 'XXXXXXXXXX');
  });
}
