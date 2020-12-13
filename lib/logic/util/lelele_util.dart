import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

///
/// Utility クラス
///
class LeleleUtil {
  ///
  /// Duration を ミリセコンドを削除した String表現にする 00:00:00
  ///
  static durationToString(Duration d) {
    return d.toString().split('.').first.padLeft(8, "0");
  }

  ///
  /// DateTimeとTimestampの変換
  ///
  static DateTime parseTime(dynamic date) {
//    return Platform.isIOS ? (date as Timestamp).toDate() : (date as DateTime);
    if (date == null) {
      return null;
    } else {
      return Platform.isIOS
          ? (date as Timestamp).toDate()
          : DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch);
    }
  }

  ///
  /// DateTimeを日付の文字列にする
  /// ToDo: DateTime型を文字列にする。国際化の対応が必要
  ///
  static String dateTimeToString(dynamic dateTime) {
    var formatter = new DateFormat('yyyy/MM/dd', Intl.systemLocale);
    var formatted = formatter.format(dateTime); // DateからString
    return formatted;
  }

  ///
  /// プラットフォームごとアプリケーションディレクトリ取得
  ///
  static getAppDirectory() async {
    Directory directory;
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = await getExternalStorageDirectory();
    }
    return directory;
  }

  ///
  /// ディレクトリのファイル一覧を取得する
  /// http://www.366service.com/jp/qa/9064af088dc74907a13fd7809dce24c5
  ///
  static Future<List<FileSystemEntity>> dirContents(Directory dir) {
    var files = <FileSystemEntity>[];
    var completer = Completer();
    var lister = dir.list(recursive: false);
    lister.listen((file) => files.add(file),
        // should also register onError
        onDone: () => completer.complete(files));
    return completer.future;
  }

  ///
  /// 自動で消えるダイアログ
  ///
  static autoHideDialog(BuildContext context, Duration duration, String message) {
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(duration, () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            title: Text(message, textAlign: TextAlign.center),
            backgroundColor: Colors.yellow,
          );
        });
  }

  ///
  /// DateTime型を日付のフォーマットにする
  /// // ToDo: 要国際化対応
  ///
  static dateTimeToDateString(DateTime dateTime) {
    var dateFormatter = DateFormat('yyyy/MM/dd', Intl.systemLocale);
    String formatDate = dateFormatter.format(dateTime);
    return formatDate;
  }
}
