import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lelele_proto1/logic/data/folder.dart';
import 'package:lelele_proto1/logic/define/lelele_enum.dart';
import 'package:lelele_proto1/ui/page/learn/folder_edit.dart';
import 'package:lelele_proto1/ui/page/learn/pattern_list.dart';
import 'package:page_transition/page_transition.dart';

///
///
///
//class PageLearn extends StatelessWidget {
// class PageLearnBasics extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     log("PageLearn.build");
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Page Home 0',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: LearnTabBasicsPage(title: 'Learn Folder List'),
//     );
//   }
// }

///
///
///
class LearnTabBasicsFolderList extends StatefulWidget {
  LearnTabBasicsFolderList({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LearnTabBasicsFolderListState createState() => _LearnTabBasicsFolderListState();
}

///
///
///
class _LearnTabBasicsFolderListState extends State<LearnTabBasicsFolderList> {
//  Metronome metronome = Metronome();

  ///
  ///
  ///
  @override
  void initState() {
    log('PageHome.initState');
    super.initState();
  }

  ///
  final GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();

  void _showSnackBar(String msg) {
    scaffoldState.currentState
        .showSnackBar(new SnackBar(content: new Text(msg), duration: Duration(milliseconds: 600)));
  }

  ///
  /// Firestore のパターンフォルダを作成する
  ///
//   _fireStorePatternFolderCreate() {
//     Map<String, dynamic> data = <String, dynamic>{
//       'name': _folderName,
// //      'color': 4294947770,
// //      'color': 14938877,
//       'color': Colors.lime.value,
//       'instrument': 100
//     };
//
//     Future<DocumentReference> ref = FirebaseFirestore.instance
//         .collection(FS_COLLECTION_USERS)
//         .doc(LelelearnApp.firebaseUser.uid)
//         .collection('items')
//         .doc('pattern')
//         .collection('folders')
//         .add(data);
//
//     print("_fireStorePatternFolderCreate ref: $ref");
//   }

  _folderEdit({Folder folder}) {
//    Navigator.push(context, CupertinoPageRoute(builder: (context) => PageLearnFolderCreate()));
//    Navigator.push(context, MaterialPageRoute(builder: (context) => PageLearnFolderCreate()));

    folder = folder == null ? Folder(color: Colors.white.value) : folder;

    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.bottomToTop,
            child: LearnFolderEditHomePage(folder: folder, title: "Edit Folder")));
  }

  _folderDelete(Folder folder) async {
    var value = await showDialog(
      context: context,
      builder: (BuildContext context) => new AlertDialog(
        title: Text('Folder Delete'),
        content: Text('フォルダ「${folder.name}」を削除しますか？ フォルダ内にあるパターンも削除されます。', softWrap: true),
        actions: <Widget>[
          new SimpleDialogOption(
            child: Text('NO'),
            onPressed: () {
              Navigator.pop(context, Answers.NO);
            },
          ),
          new SimpleDialogOption(
            child: Text(
              'Yes',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Navigator.pop(context, Answers.YES);
            },
          ),
        ],
      ),
    );
    switch (value) {
      case Answers.YES:
        folder.delete();
        break;
      case Answers.NO:
        break;
    }
  }

  IconData favoriteIcon = Icons.favorite_border;

  String orderBySelectedValue = 'name';
  var _usStates = ["name", "color", "instrument"];
  var popupMenuItem = [
    PopupMenuItem(
      child: Text("Name"),
      value: "name",
    ),
    PopupMenuItem(
      child: Text("Color"),
      value: "color",
    ),
    PopupMenuItem(
      child: Text("Instrument"),
      value: "instrument",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    log("_LearnPageState.build");
    return Scaffold(
      key: scaffoldState,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(4.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Row(children: [Text("基礎練習 未実装、楽器ごとの無料の練習コンテンツ")]),
              // Row(children: [Text("+ ボタンは、無効")]),
              StreamBuilder<QuerySnapshot>(
                stream: Folder.select(folderType: FolderType.Basic, orderByField: orderBySelectedValue),
                builder: (context, snapshot) {
//                  if (!snapshot.hasData) return LinearProgressIndicator();
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return _buildList(context, snapshot.data.docs);
                },
              ),
            ],
          ),
        ));
  }

//  Widget _buildList(BuildContext context, List<Map> snapshot) {
  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return Container(
        child: ListView(
      //
      // つけないとコンテナの中でエラーが起きる
      // https://qiita.com/tabe_unity/items/4c0fa9b167f4d0a7d7c2
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 2.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    ));
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    ///
    final folder = Folder.fromSnapshot(data);

    return Padding(
      key: ValueKey(folder.name),
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Container(
          decoration: new BoxDecoration(
//            color: Colors.orangeAccent,
            color: Color(folder.color),
          ),
          child: Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: ListTile(
              leading: Icon(
                Icons.music_note,
//              size: 20,
              ),
//          title: Text(record.name),
              title:

                  // FittedBox(
                  //     fit: BoxFit.fitWidth,
                  //     child: Text(
                  //       folder.name,
                  //       style: (TextStyle(fontSize: 16, color: Theme.of(context).primaryColor)),
                  //     )),

                  Text(
                folder.name,
                style: TextStyle(
//                fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.favorite_border),
                onPressed: () {},
              ),

              onTap: () {
                Navigator.push(
                    context,
// Todo: 戻るが出ない要確認
                    CupertinoPageRoute(
//                    MaterialPageRoute(
//                    builder: (context) => PagePatternList(
                      builder: (context) => PatternListHomePage(
                        title: folder.name,
                        folder: folder,
                      ),
                    ));
              },
            ),
            actions: <Widget>[
              IconSlideAction(
                caption: '削除',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () => _folderDelete(folder),
              ),
            ],
            secondaryActions: <Widget>[
              IconSlideAction(
                  caption: '編集',
                  color: Colors.orangeAccent,
                  icon: Icons.edit,
                  onTap: () {
                    _folderEdit(folder: folder);
//                    _patternEdit(pattern: pattern);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
