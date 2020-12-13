import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

///
/// Firebase 共通処理
///
class LeFirebase {
  ///
  /// 初期化処理
  ///
  static init() async {
    // 端末の向き初期化の処理だが書かないとエラーになる
    // https://stackoverflow.com/questions/57689492/flutter-unhandled-exception-servicesbinding-defaultbinarymessenger-was-accesse
    WidgetsFlutterBinding.ensureInitialized();

    // Flutter
    await Firebase.initializeApp();
  }
}
