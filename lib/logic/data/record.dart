import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lelele_proto1/logic/define/lelele_constants.dart';
import 'package:lelele_proto1/lelelearn_app.dart';
import 'package:lelele_proto1/logic/data/firestore_data.dart';

///
/// レコード (録音データ)
///
class Record extends FireStoreData {
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

  /// Duration
  Duration duration;

  /// Path
  String path;

  /// Length
  int length;

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
  DateTime updated;

  /// 作成日時
  DateTime created;

  //================
  // 実装
  //================

  ///
  /// コンストラクタ
  ///
  Record({this.reference, this.id, this.duration, this.path, this.length, this.created}) {
    initCollection();
  }

  //=====================
  // Firestore
  //=====================

  /// Firestore Collection
  CollectionReference collection;

  initCollection() {
    collection = FirebaseFirestore.instance
        .collection(FS_COLLECTION_USERS)
        .doc(LelelearnApp.firebaseUser.uid)
        .collection('items')
        .doc('pattern')
        .collection('folders');
  }
}
