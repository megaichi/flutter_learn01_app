import 'package:cloud_firestore/cloud_firestore.dart';

///
///
///
///
class LeFirestore {
  String userId = "";

  ///
  LeFirestore({this.userId}) {
    print("userId: $userId");
  }

  ///
  ///  パターン一覧の取得
  ///
  Stream<QuerySnapshot> getPatterns({String folderId}) {
    Stream<QuerySnapshot> stream = FirebaseFirestore.instance.collection('baby').snapshots();

    return stream;
  }
}
