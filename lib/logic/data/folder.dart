import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lelele_proto1/lelelearn_app.dart';
import 'package:lelele_proto1/logic/define/lelele_constants.dart';
import 'package:lelele_proto1/logic/define/lelele_enum.dart';
import 'package:lelele_proto1/logic/util/lelele_util.dart';

///
/// フォルダー
///
//class Folder extends FireStoreData {
class Folder {
  //================
  // オブジェクト項目
  //================

  /// ドキュメントリファレンス
  final DocumentReference reference;

  /// フォルダータイプ
  FolderType folderType;

  //================
  // 管理データ
  //================

  /// ID
  String id;

  // ユーザID シェアしたとき用
  String userId;

  //================
  // 基本データ
  //================

  /// フォルダ名
  String name;

  /// 楽器アイコン
  int instrument = 0;

  /// カラー
  int color;

  /// お気に入り
  bool favorite;

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
  Folder(
      {this.reference,
      this.id,
      this.userId,
      this.name,
      this.instrument,
      this.favorite,
      this.color,
      this.updated,
      this.created}) {
    initCollection();
  }

  ///
  /// コンストラクタ fromMap
  ///
  Folder.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['instrument'] != null),
        assert(map['color'] != null),
        id = reference.id,
        userId = map['userId'],
        name = map['name'],
        instrument = map['instrument'],
        color = map['color'],
        favorite = map['favorite'],
        updated = LeleleUtil.parseTime(map['updated']),
        created = LeleleUtil.parseTime(map['created']) {
    initCollection();
  }

  ///
  /// コンストラクタ fromSnapshot
  ///
  Folder.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);

  /// toString()
  @override
  String toString() {
    return super.toString() + data.toString();
  }

  //=====================
  // Firestore
  //=====================

  /// Firestore Collection
  static CollectionReference collection;

  initCollection() {
    switch (folderType) {
      case FolderType.User:
        collection = FirebaseFirestore.instance
            .collection(FS_COLLECTION_USERS)
            .doc(LelelearnApp.firebaseUser.uid)
            .collection('items')
            .doc('pattern')
            .collection('folders');
        break;

      case FolderType.Basic:
        collection = FirebaseFirestore.instance.collection('basics').doc('pattern').collection('folders');

        break;

      case FolderType.Share:
        break;
      default:
        print("FoldetType Error initCollection");
    }
  }

  Map<String, dynamic> get data {
    this.favorite = this.favorite == null ? false : this.favorite;

    return <String, dynamic>{
//      'id': this.id,
      'name': this.name,
      'instrument': this.instrument,
      'color': this.color,
      'favorite': this.favorite,
      'updated': this.updated,
      'created': this.created,
    };
  }

  ///
  /// Firestore Select
  ///
  static Stream<QuerySnapshot> select(
      {FolderType folderType = FolderType.User, String orderByField, bool favorite = false}) {
    CollectionReference collect;
    switch (folderType) {
      case FolderType.User:
        collect = FirebaseFirestore.instance
            .collection(FS_COLLECTION_USERS)
            .doc(LelelearnApp.firebaseUser.uid)
            .collection('items')
            .doc('pattern')
            .collection('folders');
        break;

      case FolderType.Basic:
        collect = FirebaseFirestore.instance.collection('basics').doc('pattern').collection('folders');

        break;

      case FolderType.Share:
        break;
      default:
        print("FoldetType Error select");
    }

    return collect
        // ToDo: フォルダーのfavorite 指定すると処理が戻らなくなる。要調査
        // .where("favorite", isEqualTo: favorite)
        .orderBy(orderByField)
        .snapshots();

    // return FirebaseFirestore.instance
    //     .collection(FS_COLLECTION_USERS)
    //     .doc(LelelearnApp.firebaseUser.uid)
    //     .collection('items')
    //     .doc('pattern')
    //     .collection('folders')
    //     // ToDo: フォルダーのfavorite 指定すると処理が戻らなくなる。要調査
    //     // .where("favorite", isEqualTo: favorite)
    //     .orderBy(orderByField)
    //     .snapshots();
  }

  ///
  /// Folder Add
  ///
  add() {
    this.created = DateTime.now();
    collection.add(data);
  }

  ///
  /// Folder Update
  ///
  update() {
    this.updated = DateTime.now();
    collection.doc(this.id).update(data);
  }

  ///
  /// Folder Upsert
  ///
  upsert() {
    initCollection();
    if (this.id == null) {
      add();
    } else {
      update();
    }
  }

  ///
  /// Folder Delete
  ///
  delete() {
    this.reference.delete();
  }

  ///
  /// お気に入りの切替
  ///
  favoriteChange() {
    this.favorite = !this.favorite;
    update();
  }
}
