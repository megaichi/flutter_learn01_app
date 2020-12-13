import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lelele_proto1/lelelearn_app.dart';

Future<void> main() async {
  log("lelele main");

//  LeFirebase.init();

  // 端末の向き初期化の処理だが書かないとエラーになる
  // https://stackoverflow.com/questions/57689492/flutter-unhandled-exception-servicesbinding-defaultbinarymessenger-was-accesse
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase Init
  await Firebase.initializeApp();

  // Crashlytics Init
  // https://blog.takuchalle.dev/post/2020/05/05/setup_firebase_crashlytics/
  FlutterError.onError = (details) {
    FlutterError.dumpErrorToConsole(details);
    FirebaseCrashlytics.instance.recordFlutterError(details);
    if (kReleaseMode) exit(1);
  };

  // https://blog.takuchalle.dev/post/2020/05/05/setup_firebase_crashlytics/
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  //  runApp(LelelearnApp());

  // https://pub.dev/packages/table_calendar
//  initializeDateFormatting().then((_) => runApp(LelelearnApp()));

  // ↑Flutter が多言語化に正式対応したことにより不要になった、入れるとエラーになる
  // https://qiita.com/welchi/items/99f7041a3e1f54a06c15

  runApp(LelelearnApp());
}

// ToDo: File PickerがAndroid Emulatorでは、エラーになる
// I/flutter (19170): [MethodChannelFilePicker] Platform exception: PlatformException(invalid_format_type, Can't handle the provided file type., null)
// I/flutter (19170): Unsupported operationPlatformException(invalid_format_type, Can't handle the provided file type., null)
// 以下のデモでも同じ
//void main0() => runApp(new FilePickerDemo());

memo() {
  // Memo: パステルカラー
  // https://www.color-hex.com/color-palette/5361
  // int c1 = Colors.orangeAccent.value;
  // int c2 = Color.fromARGB(0xff, 0xff, 0xb3, 0xba).value;
  // int c3 = Color.fromARGB(0xff, 0xfc, 0xe4, 0xec).value;
  // print('c1: $c1');
  // print('c2: $c2');
  // print('c3: $c3');
}
