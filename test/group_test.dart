import 'package:almanacinc_auto_size_text/almanacinc_auto_size_text.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

class GroupTest extends StatefulWidget {
  const GroupTest({super.key});

  @override
  State<GroupTest> createState() => GroupTestState();
}

class GroupTestState extends State<GroupTest> {
  final group = AutoSizeGroup();
  var width1 = 300.0;
  var width2 = 300.0;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        children: <Widget>[
          SizedBox(
            width: width1,
            height: 100,
            child: AutoSizeText(
              'XXXXXX',
              style: TextStyle(fontSize: 60),
              minFontSize: 1,
              maxLines: 1,
              group: group,
            ),
          ),
          SizedBox(
            width: width2,
            height: 100.0,
            child: AutoSizeText(
              'XXXXXX',
              style: TextStyle(fontSize: 60),
              minFontSize: 1,
              maxLines: 1,
              group: group,
            ),
          ),
        ],
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}

void _expectFontSizes(WidgetTester tester, double fontSize) {
  final texts = tester.widgetList(find.byType(Text));
  for (final text in texts) {
    expect(effectiveFontSize(text as Text), fontSize);
  }
}

void main() {
  testWidgets('Group sync', (tester) async {
    await tester.pumpWidget(const GroupTest());

    _expectFontSizes(tester, 50);

    final state = tester.state(find.byType(GroupTest)) as GroupTestState;

    state.width1 = 200;
    state.refresh();
    await tester.pump(Duration.zero);
    _expectFontSizes(tester, 33);

    state.width2 = 150;
    state.refresh();
    await tester.pump(Duration.zero);
    _expectFontSizes(tester, 25);

    state.width2 = 100;
    state.refresh();
    await tester.pump(Duration.zero);
    _expectFontSizes(tester, 16);

    state.width1 = 60;
    state.width2 = 60;
    state.refresh();
    await tester.pump(Duration.zero);
    _expectFontSizes(tester, 10);

    state.width1 = 200;
    state.refresh();
    await tester.pump(Duration.zero);
    _expectFontSizes(tester, 10);

    state.width2 = 250;
    state.refresh();
    await tester.pump(Duration.zero);
    _expectFontSizes(tester, 33);

    state.width1 = 250;
    state.refresh();
    await tester.pump(Duration.zero);
    _expectFontSizes(tester, 41);

    state.width1 = 300;
    state.width2 = 300;
    state.refresh();
    await tester.pump(Duration.zero);
    await tester.pump(Duration.zero);
    _expectFontSizes(tester, 50);

    await tester.pump(Duration.zero);
  });
}
