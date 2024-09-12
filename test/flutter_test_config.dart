import 'dart:async';

import 'package:easy_latex/easy_latex.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  setUpAll(() async {
    await (FontLoader('kt-ams')
          ..addFont(rootBundle.load('lib/fonts/kt-ams.ttf')))
        .load();
    await (FontLoader('kt-cal')
          ..addFont(rootBundle.load('lib/fonts/kt-cal.ttf')))
        .load();
    await (FontLoader('kt-fraktur')
          ..addFont(rootBundle.load('lib/fonts/kt-fraktur.ttf')))
        .load();
    await (FontLoader('kt-main')
          ..addFont(rootBundle.load('lib/fonts/kt-main.ttf'))
          ..addFont(rootBundle.load('lib/fonts/kt-main-bold.ttf'))
          ..addFont(rootBundle.load('lib/fonts/kt-main-bold-italic.ttf')))
        .load();
    await (FontLoader('kt-main-italic')
          ..addFont(rootBundle.load('lib/fonts/kt-main-italic.ttf'))
          ..addFont(rootBundle.load('lib/fonts/kt-main-bold-italic.ttf')))
        .load();
    await (FontLoader('kt-script')
          ..addFont(rootBundle.load('lib/fonts/kt-script.ttf')))
        .load();
    await (FontLoader('kt-typewriter')
          ..addFont(rootBundle.load('lib/fonts/kt-typewriter.ttf')))
        .load();
    LatexFont.isGoldenTest = true;
  });

  await testMain();
}
