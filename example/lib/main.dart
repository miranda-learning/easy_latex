import 'package:easy_latex/easy_latex.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          appBarTheme: const AppBarTheme(color: Colors.white),
          scaffoldBackgroundColor: Colors.white),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Easy Latex'),
        ),
        body: Column(
          children: [
            Container(),
            const Latex(
                r'x_{1,2} = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a} \\ \pi = 3.14159... '),
            LText(
                r'This is **bold text**, this is *italic text*, this is `code`. '
                r'The value of \(\pi\) is \(3.14159...\) and the value of \(\sqrt{2}\) is '
                r'\(1.41421...\)'),
          ],
        ),
      ),
    );
  }
}
