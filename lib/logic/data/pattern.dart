import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lelele_proto1/logic/define/lelele_constants.dart';
import 'package:lelele_proto1/logic/define/lelele_enum.dart';
import 'package:lelele_proto1/lelelearn_app.dart';
import 'package:lelele_proto1/logic/data/folder.dart';
import 'package:lelele_proto1/logic/util/lelele_util.dart';

///
/// パターン
///
class Pattern {
  //================
  // 定数
  //================

  /// お手本再生開始位置デフォルト
  static const soundRangeStartDefault = 0;

  /// お手本再生終了位置デフォルト
  static const soundRangeEndDefault = 20000;

  ///
  static const tempoBaseDefault = 120;

  ///
  static const tempoGoalDefault = 120;

  ///
  static const tempoCurrentDefault = 100;

  ///
  static const tempoupFlgDefault = false;

  ///
  static const tempoupCountDefault = 2;

  ///
  static const tempoupBpmDefault = 6;

  ///
  static const recordTimeDefault = 180000;

  ///
  static const repeatCountDefault = 10;

  ///
  static const beatDefault = 4;

  ///
  static const measureCountInDefault = 2;

  ///
  static const measureCountDefault = 4;

  //================
  // オブジェクト項目
  //================

  /// ドキュメントリファレンス
  final DocumentReference reference;

  /// Folder  Firestoreには保存しない
  Folder folder;

  //================
  // 管理データ
  //================

  /// ID
  String id;

  /// User ID
  String userId;

  // parentId と publicIdは、未使用なので一旦コメントアウト

  /// 親ID、公式からのコピーの場合の元ID
//  String parentId;

  /// 公開ID
//  String publicId;

  //================
  // 基本データ
  //================

  /// パターン名
  String name = '';

  // 未使用なので、一旦コメントアウト フォルダと同じアイコンを表示する
  /// 楽器アイコン
//  int instrument = 0;

  //================
  // お手本関連 (サウンド)
  //================

  /// お手本ファイル名
  String soundFileName;

  /// お手本ファイルパス
  String soundFilePath;

  /// お手本再生開始位置
  int soundRangeStart = soundRangeStartDefault;

  /// お手本再生終了位置
  int soundRangeEnd = soundRangeEndDefault;

  //================
  // 楽譜関連
  //================

  /// 楽譜ファイル名
  String scoreFileName;

  /// 楽譜ファイルパス
  String scoreFilePath;

  //================
  // メトロノームモード関連
  //================

  /// 練習テンポ (設定値)
  num tempoBase = 80;

  /// 目標テンポ
  num tempoGoal = 120;

  /// 設定中のテンポ (練習値)
  num tempoCurrent = 100;

  /// テンポアップするかどうか
  bool tempoupFlg = false;

  /// テンポアップカウント、何回ごとにテンポアップするか
  num tempoupCount = 2;

  /// テンポアップするBPM数
  num tempoupBpm = 6;

  //================
  // タイムモード
  //================

  /// タイムモードでの録音時間
  ///   UI用のDuration
  Duration _recordTimeDuration = Duration(hours: 0, minutes: 2, seconds: 0);

  set recordTimeDuration(Duration duration) {
    _recordTime = duration.inMilliseconds;
    _recordTimeDuration = duration;
  }

  Duration get recordTimeDuration {
    return _recordTimeDuration;
  }

  /// タイムモードでの録音時間
  /// ミリ秒 (1/1000秒) Firestoreには、この値を保存する
  num _recordTime;

  set recordTime(num recordTime) {
    int rt = recordTime == null ? null : recordTime.toInt();

    _recordTimeDuration = recordTime == null ? null : Duration(milliseconds: rt);
    _recordTime = recordTime;
  }

  num get recordTime {
    return _recordTime;
  }

  /// タイムモードでの録音時間をを文字列で返す
  String get recordTimeString {
    return LeleleUtil.durationToString(recordTimeDuration);
  }

  //================
  // 再生関連
  //================

  /// 練習回数
  int repeatCount = repeatCountDefault;

  /// 練習回数の再生中の回数
  /// Firestoreには、保存しない
  int repeatCountNow = 0;

  /// 拍子
  int beat = 4;

  /// カウントイン小節数
  int measureCountIn = 2;

  /// 練習小節数
  int measureCount = 4;

  /// ワンポイント
  String onePoint = '';

  //================
  // 統計情報
  //================

  /// 今までの練習回数
  int learnCount;

  /// 今までの練習時間
  int learnTime;

  //================
  // メタデータ
  //================

  /// 複製可能
  bool isDupulicatable = true;

  /// 移動可能
  bool isMovable = true;

  /// 編集可能
  bool isEditable = true;

  /// 削除可能
  bool isDeletable = true;

  /// 更新日時
  DateTime updated = null;

  /// 作成日時
  DateTime created = null;

  //================
  // 実装
  //================

  ///
  /// コンストラクタ
  ///
//  Pattern({this.reference, this.id, this.name}) {
  Pattern({this.reference, this.id, this.folder}) {
    init();
  }

  Map<String, dynamic> dataMap;

  ///
  /// コンストラクタ fromMap
  ///
  Pattern.fromMap(Map<String, dynamic> this.dataMap, this.reference, this.folder)
      : assert(reference.id != null),
        assert(dataMap['name'] != null),
        id = reference.id,
        userId = dataMap['userId'],
//        parentId = map['parentId'],
//        publicId = map['publicId'],
        name = dataMap['name'] == null ? "" : dataMap['name'],
//        instrument = map['instrument'],
        soundFileName = dataMap['soundFileName'] == null ? "" : dataMap['soundFileName'],
        soundFilePath = dataMap['soundFilePath'] == null ? "" : dataMap['soundFilePath'],
        soundRangeStart =
            dataMap['soundRangeStart'] == null ? soundRangeStartDefault : dataMap['soundRangeStart'].toInt(),
        soundRangeEnd = dataMap['soundRangeEnd'] == null ? soundRangeEndDefault : dataMap['soundRangeEnd'].toInt(),
        scoreFileName = dataMap['scoreFileName'] == null ? "" : dataMap['scoreFileName'],
        scoreFilePath = dataMap['scoreFilePath'] == Null ? "" : dataMap['scoreFilePath'],
        tempoBase = dataMap['tempoBase'] == null ? tempoBaseDefault : dataMap['tempoBase'].toInt(),
        tempoGoal = dataMap['tempoGoal'] == null ? tempoGoalDefault : dataMap['tempoGoal'].toInt(),
        tempoCurrent = dataMap['tempoCurrent'] == null ? tempoCurrentDefault : dataMap['tempoCurrent'].toInt(),
        tempoupFlg = dataMap['tempoupFlg'] == null ? tempoupFlgDefault : dataMap['tempoupFlg'],
        tempoupCount = dataMap['tempoupCount'] == null ? tempoupCountDefault : dataMap['tempoupCount'].toInt(),
        tempoupBpm = dataMap['tempoupBpm'] == null ? tempoupBpmDefault : dataMap['tempoupBpm'].toInt(),
        // recordTimeはinitで初期化
        repeatCount = dataMap['repeatCount'] == null ? repeatCountDefault : dataMap['repeatCount'].toInt(),
        beat = dataMap['beat'] == null ? beatDefault : dataMap['beat'].toInt(),
        measureCountIn = dataMap['measureCountIn'] == null ? measureCountInDefault : dataMap['measureCountIn'].toInt(),
        measureCount = dataMap['measureCount'] == null ? measureCountDefault : dataMap['measureCount'].toInt(),
        onePoint = dataMap['onePoint'] == null ? "" : dataMap['onePoint'],
        isDupulicatable = dataMap['isDupulicatable'] == null ? true : dataMap['isDupulicatable'],
        isMovable = dataMap['isMovable'] == null ? true : dataMap['isMovable'],
        isEditable = dataMap['isEditable'] == null ? true : dataMap['isEditable'],
        isDeletable = dataMap['isDeletable'] == null ? true : dataMap['isDeletable'],
        updated = LeleleUtil.parseTime(dataMap['updated']),
        created = LeleleUtil.parseTime(dataMap['created']) {
    init();
  }

  ///
  /// コンストラクタ fromSnapshot
  ///
  Pattern.fromSnapshot(DocumentSnapshot snapshot, Folder folder)
      : this.fromMap(snapshot.data(), snapshot.reference, folder);

  /// toString()
  @override
  String toString() {
    return super.toString() + data.toString();
  }

  init() {
    collection = FirebaseFirestore.instance
        .collection(FS_COLLECTION_USERS)
        .doc(LelelearnApp.firebaseUser.uid)
        .collection('items')
        .doc('pattern')
        .collection('folders')
        .doc(folder.id)
        .collection("patterns");
// ToDo: 20201025 要修正
    if (dataMap != null) {
      recordTime = dataMap['recordTime'] == null ? recordTimeDefault : dataMap['recordTime'].toInt();
    }
  }

  ///
  /// テンポアップする場合のゴールテンポ
  /// 練習テンポ + (繰り返し回数 / テンポアップカウント * テンポアップBPM)
  ///
  int get goalTempo {
    int result;

    if (tempoupFlg) {
      result = tempoBase + (repeatCount / tempoupCount).floor() * tempoupBpm;
    } else {
      result = tempoBase;
    }

    return result;
  }

  ///
  /// 予想練習時間の取得
  ///
  String get practiceTime {
    double ms = 60 / tempoBase * beat * measureCount * repeatCount * 2;
    int seconds = ms.floor();
    print("seconds: $seconds");
    Duration d = Duration(seconds: seconds);
    String resultText = LeleleUtil.durationToString(d);
    return resultText;
  }

  ///
  /// 予想練習時間
  ///

  //=====================
  // Firestore
  //=====================

  /// Firestore Collection
  CollectionReference collection;

  ///
  /// Firestore保存用データ
  ///
  Map<String, dynamic> get data {
    return <String, dynamic>{
      'userId': this.userId,
//      'parentId': this.parentId,
//      'publicId': this.publicId,
      'name': this.name,
//      'instrument': this.instrument,
      'soundFileName': this.soundFileName,
      'soundFilePath': this.soundFilePath,
      'soundRangeStart': this.soundRangeStart,
      'soundRangeEnd': this.soundRangeEnd,
      'scoreFileName': this.scoreFileName,
      'scoreFilePath': this.scoreFilePath,
      'tempoBase': this.tempoBase,
      'tempoGoal': this.tempoGoal,
      'tempoCurrent': this.tempoCurrent,
      'tempoupFlg': this.tempoupFlg,
      'tempoupCount': this.tempoupCount,
      'tempoupBpm': this.tempoupBpm,
      'recordTime': this.recordTime,
      'repeatCount': this.repeatCount,
      'beat': this.beat,
      'measureCountIn': this.measureCountIn,
      'measureCount': this.measureCount,
      'onePoint': this.onePoint,
      'isDupulicatable': this.isDupulicatable,
      'isMovable': this.isMovable,
      'isEditable': this.isEditable,
      'isDeletable': this.isDeletable,
      'updated': this.updated,
      'created': this.created,
    };
  }

  ///
  /// Firestore Select
  ///
  static Stream<QuerySnapshot> select({FolderType folderType = FolderType.User, String folderId, String orderByField}) {
    Stream<QuerySnapshot> snapshots;

    // フォルダタイプごとに処理を分ける (取得階層が違う)
    switch (folderType) {
      // ユーザフォルダ
      case FolderType.User:
        snapshots = FirebaseFirestore.instance
            .collection(FS_COLLECTION_USERS)
            .doc(LelelearnApp.firebaseUser.uid)
            .collection('items')
            .doc('pattern')
            .collection('folders')
            .doc(folderId)
            .collection("patterns")
            .orderBy("name")
            .snapshots();
        break;
      // 基礎練習フォルダ
      case FolderType.Basic:
        break;

      // シェアフォルダ
      case FolderType.Share:
        break;

      // コンテンツフォルダ (販売データ用)
      case FolderType.Contents:
        break;

      default:
        break;
    }

    // ToDo: パターン取得ロジック修正 ↑

    return FirebaseFirestore.instance
        .collection(FS_COLLECTION_USERS)
        .doc(LelelearnApp.firebaseUser.uid)
        .collection('items')
        .doc('pattern')
        .collection('folders')
        .doc(folderId)
        .collection("patterns")
        .orderBy("name")
        .snapshots();
  }

  /// Pattern Add
  add() {
    created = DateTime.now();
    collection.add(data);
  }

  /// Pattern Update
  update() {
    print('data: $data');
    updated = DateTime.now();
    collection.doc(this.id).update(data);
  }

  /// Pattern Upsert
  upsert() {
    if (this.id == null) {
      add();
    } else {
      update();
    }
  }

  /// Pattern Delete
  delete() {
    this.reference.delete();
  }
}
