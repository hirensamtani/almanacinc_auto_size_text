import 'package:almanacinc_auto_size_text/almanacinc_auto_size_text.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

void main() {
  // Every TextPainter created while measuring is disposed in a try/finally
  // block, so a stress layout that runs the binary search many times must not
  // throw or leak. Flutter asserts on a leaked/undisposed native Paragraph in
  // debug builds, so a clean run across many rebuilds is the smoke signal.
  testWidgets('Stress resize does not throw or leak painters', (tester) async {
    for (final width in <double>[500, 6, 220, 1, 333, 90]) {
      await pump(
        tester: tester,
        widget: SizedBox(
          width: width,
          height: 60,
          child: AutoSizeText(
            'XXXXX XXXXX XXXXX',
            style: TextStyle(fontSize: 200),
            minFontSize: 1,
            maxLines: 3,
            wrapWords: false,
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(find.byType(Text), findsOneWidget);
    }
  });

  testWidgets('Disposing an AutoSizeText with a group leaves no exception',
      (tester) async {
    final group = AutoSizeGroup();
    await pump(
      tester: tester,
      widget: AutoSizeText(
        'XXXXX',
        style: TextStyle(fontSize: 40),
        group: group,
        maxLines: 1,
      ),
    );
    // Remove the widget: its State.dispose must deregister from the group.
    await pump(tester: tester, widget: const SizedBox());
    expect(tester.takeException(), isNull);
  });
}
