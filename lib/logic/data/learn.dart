import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:lelele_proto1/logic/define/lelele_constants.dart';
import 'package:lelele_proto1/lelelearn_app.dart';
import 'package:lelele_proto1/logic/data/firestore_data.dart';

///
/// Learn (練習データ記録)
///
class Learn extends FireStoreData {
  //================
  // オブジェクト項目
  //================

  /// ドキュメントリファレンス
  final DocumentReference reference;

  //================
  // 管理データ
  //================

  /// ID
  String id;

  // ユーザID シェアしたとき用
//  String userId;

  //================
  // 基本データ
  //================

  /// ファイルパス
  String filePath;

  /// ファイル名
  String fileName;

  /// 録音時間 Duration
  Duration recordTimeDuration;

  /// 録音時間
  int recordTime;

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

  // 更新日時
  // 登録専用なので更新日時は無し
//  DateTime updated;

  /// 作成日時
  DateTime created;

  //================
  // 実装
  //================

  ///
  /// コンストラクタ
  ///
  Learn({this.reference, this.id, this.filePath, this.fileName}) {
    _initCollection();
  }

  /// toString()
  @override
  String toString() {
    return super.toString() + data.toString();
  }

  //=====================
  // Firestore
  //=====================

  /// Firestore Collection
//  CollectionReference ymCollection;

  /// フォルダのコレクション IDは、yyyymmdd
  CollectionReference folderCollection;

  /// Learnのコレクション IDは、yyyymmdd_hhMMss
  CollectionReference learnCollection;

  /// Recordのコレクション IDは、yyyymmdd_hhMMss ToDo: RecordのIDがyyyymmdd_hhMMssになってない実装修正
  CollectionReference recordCollection;

  ///
  /// 使用するコレクションを初期化する
  /// https://docs.google.com/spreadsheets/d/1QDjtG4NiU6gGL36s9yw5DG5OBHZx6U-66-lykK6VWhI/edit#gid=0
  ///
  _initCollection() {
    var now = DateTime.now();

    var dateFormatter = new DateFormat('yyyyMMdd', Intl.systemLocale);
    var timestampFormatter = new DateFormat('yyyyMMdd_HHmmss', Intl.systemLocale);

    String dateId = dateFormatter.format(now);
    String timestampId = timestampFormatter.format(now);

    folderCollection = FirebaseFirestore.instance
        .collection(FS_COLLECTION_USERS)
        .doc(LelelearnApp.firebaseUser.uid)
        .collection('items')
        .doc('learn')
        .collection('folders');

    learnCollection = folderCollection.doc(dateId).collection('learns');

    recordCollection = learnCollection.doc(timestampId).collection('records');
  }

  // Todo: 要項目追加
  Map<String, dynamic> get data {
    return <String, dynamic>{
//      'id': this.id,
      'filePath': this.filePath,
      'fileName': this.fileName,
//      'updated': this.updated,
      'created': this.created,
    };
  }

  CollectionReference getFolderCollections(dynamic field, {bool descending = false}) {
    return folderCollection.orderBy(field, descending: descending);
  }

  //=====================
  // CRUD
  //=====================

  ///
  /// Learn Add
  ///
  add() {
    this.created = DateTime.now();
    recordCollection.add(data);
  }

  // 登録専用なので、Updateは、無し
  // Learn Update
  //
  // update() {
  //   this.updated = DateTime.now();
  //   recordCollection.doc(this.id).update(data);
  // }

  ///
  /// Learn Upsert
  ///
  // upsert() {
  //   if (this.id == null) {
  //     add();
  //   } else {
  //     update();
  //   }
  // }

  ///
  /// Learn Delete
  ///
  delete() {
    this.reference.delete();
  }
}
