import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lelele_proto1/lelelearn_app.dart';
import 'package:lelele_proto1/logic/data/firestore_data.dart';
import 'package:lelele_proto1/logic/define/lelele_constants.dart';
import 'package:lelele_proto1/logic/util/lelele_util.dart';

///
/// 将来の目標
///
class Longterm extends FireStoreData {
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

  /// target
  String target = '';

  /// 終了日
  DateTime goaled;

  String get goaledString {
    return LeleleUtil.dateTimeToString(goaled);
  }

  String get createdString {
    return LeleleUtil.dateTimeToString(created);
  }

  //================
  // メタデータ
  //================

  // /// 複製可能
  // bool isDupulicatable = false;
  //
  // /// 移動可能
  // bool isMovable = false;
  //
  // /// 編集可能
  // bool isEditable = false;
  //
  // /// 削除可能
  // bool isDeletable = false;

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
  Longterm({this.reference, this.id, this.target, this.goaled, this.updated, this.created}) {
    initCollection();
  }

  ///
  /// コンストラクタ fromMap
  ///
  Longterm.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['target'] != null),
        id = reference.id,
        target = map['target'],
        goaled = LeleleUtil.parseTime(map['goaled']),
        updated = LeleleUtil.parseTime(map['updated']),
        created = LeleleUtil.parseTime(map['created']) {
    initCollection();
  }

  ///
  /// コンストラクタ fromSnapshot
  ///
  Longterm.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);

  /// toString()
  @override
  String toString() {
    return super.toString() + data.toString();
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
        .collection('tasks')
        .doc('task')
        .collection('longterms');
  }

  Map<String, dynamic> get data {
    return <String, dynamic>{
//      'id': this.id,
      'target': this.target,
      'goaled': this.goaled,
      'updated': this.updated,
      'created': this.created,
    };
  }

  ///
  /// Firestore Select
  ///
  static String getCurrentLongterm() {
    // FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(userId)
    //     .get()
    //     .then((DocumentSnapshot documentSnapshot) {
    //   if (documentSnapshot.exists) {
    //     print('Document data: ${documentSnapshot.data()}');
    //   } else {
    //     print('Document does not exist on the database');
    //   }
    // });

    // collection
    //     .orderBy('created')
    //     .limit(1)
    //     .get().then((value) => )

//    Future<QuerySnapshot> snapShot =
    String result = '';

    if (LelelearnApp.firebaseUser != null) {
      FirebaseFirestore.instance
          .collection(FS_COLLECTION_USERS)
          .doc(LelelearnApp.firebaseUser.uid)
          .collection('tasks')
          .doc('task')
          .collection('longterms')
          .orderBy('created', descending: true)
          .limit(1)
          .snapshots()
          .first
          .then((value) {
        dynamic data = value.docs.first;
        return data['target'];
        // print("☆★☆★☆★☆★☆★☆★");
        // print(docs[0].data());

        // Map<String, dynamic> dataMap = docs[0].data();
        // print(dataMap['target']);
        // result = dataMap['target'];
        // return result;
      });
    }

//    return result;
  }

  ///
  /// Longterm Select
  ///
  static Stream<QuerySnapshot> select({String orderByField = 'created'}) {
    Stream<QuerySnapshot> result = FirebaseFirestore.instance
        .collection("users/${LelelearnApp.firebaseUser.uid}/tasks/task/longterms")
        .orderBy(orderByField, descending: true)
        .snapshots();

    return result;

//     return FirebaseFirestore.instance
//         .collection(FS_COLLECTION_USERS)
//         .doc(LelelearnApp.firebaseUser.uid)
//         .collection('tasks')
//         .doc('task')
//         .collection('longterms')
//
// //      return collection
// //                        .where("favorite", isEqualTo: _isFavorite)
//         .orderBy(orderByField, descending: true)
//         .snapshots();
  }
}
