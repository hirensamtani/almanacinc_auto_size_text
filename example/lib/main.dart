import 'package:almanacinc_auto_size_text/almanacinc_auto_size_text.dart';
import 'package:flutter/material.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'almanacinc_auto_size_text',
      theme: ThemeData(useMaterial3: true),
      home: const ExamplePage(),
    );
  }
}

class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AutoSizeText by Almanac Inc.')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _Demo(
            label: 'Single line (shrinks to one line)',
            child: AutoSizeText(
              'This long sentence is squeezed onto a single line.',
              style: TextStyle(fontSize: 40),
              maxLines: 1,
            ),
          ),
          _Demo(
            label: 'Multi line (fills two lines)',
            child: AutoSizeText(
              'This string is automatically resized to fit in two lines.',
              style: TextStyle(fontSize: 40),
              maxLines: 2,
            ),
          ),
          _Demo(
            label: 'AutoSizeText.rich',
            child: AutoSizeText.rich(
              TextSpan(
                text: 'Rich ',
                children: [
                  TextSpan(
                    text: 'formatted ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: 'auto-sizing text.',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              style: TextStyle(fontSize: 40),
              maxLines: 1,
            ),
          ),
          _GroupDemo(),
          _Demo(
            label: 'Devanagari (tall matras respected)',
            child: AutoSizeText(
              'नमस्ते दुनिया, स्वागत है',
              style: TextStyle(fontSize: 40),
              maxLines: 1,
            ),
          ),
          _Demo(
            label: 'Gujarati (tall matras respected)',
            child: AutoSizeText(
              'નમસ્તે દુનિયા, સ્વાગત છે',
              style: TextStyle(fontSize: 40),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _Demo extends StatelessWidget {
  const _Demo({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 4),
          SizedBox(width: 220, height: 56, child: child),
          const Divider(),
        ],
      ),
    );
  }
}

class _GroupDemo extends StatelessWidget {
  const _GroupDemo();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: AutoSizeGroupBuilder(
        builder: (context, group) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AutoSizeGroup (all share the smallest size)',
                style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 4),
            SizedBox(
              width: 220,
              height: 32,
              child: AutoSizeText('Synced short',
                  style: const TextStyle(fontSize: 30),
                  maxLines: 1,
                  group: group),
            ),
            SizedBox(
              width: 120,
              height: 32,
              child: AutoSizeText('Synced much longer line',
                  style: const TextStyle(fontSize: 30),
                  maxLines: 1,
                  group: group),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
