import 'dart:io';

import 'package:process_run/shell.dart';

void main() async {
  Directory screenshotsDir = Directory('test/screenshots/');
  if (screenshotsDir.existsSync()) screenshotsDir.deleteSync(recursive: true);
  screenshotsDir.createSync();

  await Shell().run("flutter test --update-goldens");
}
