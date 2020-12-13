import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lelele_proto1/assets/lelele_icon_map.dart';
import 'package:lelele_proto1/logic/data/folder.dart';
import 'package:lelele_proto1/logic/define/lelele_enum.dart';
import 'package:lelele_proto1/ui/page/learn/_learn.dart';
import 'package:lelele_proto1/ui/page/learn/folder_edit.dart';
import 'package:lelele_proto1/ui/page/learn/pattern_list.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

//--------------------------------------------------------------------------------------------------------------------//

///
class PageLearnMyFolderList extends StatelessWidget {
  bool favorite;

  PageLearnMyFolderList({this.favorite});

  @override
  Widget build(BuildContext context) {
    log("PageLearn.build");

    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: 'Page Home 0',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //     visualDensity: VisualDensity.adaptivePlatformDensity,
    //   ),
    //   home: LearnTabMyFolderPage(title: 'Learn Folder List'),
    // );

    return LearnTabMyFolderListPage(title: 'Learn Folder List', favorite: favorite);
  }
}

//--------------------------------------------------------------------------------------------------------------------//

///
class LearnTabMyFolderListPage extends StatefulWidget {
  LearnTabMyFolderListPage({Key key, this.title, this.favorite}) : super(key: key);

  final String title;
  bool favorite;

  @override
  _LearnTabMyFolderListPageState createState() => _LearnTabMyFolderListPageState();
}

//--------------------------------------------------------------------------------------------------------------------//

///
/// マイフォルダリスト Stateクラス
///
class _LearnTabMyFolderListPageState extends State<LearnTabMyFolderListPage> {
  //-----------------//
  //  Class Param    //
  //-----------------//

  /// OrderBy項目
  String _orderBySelectedValue = 'name';
  bool _favorite = false;

  //-----------------//
  // LOGIC           //
  //-----------------//

  ///
  ///
  ///
  @override
  void initState() {
    log('PageHome.initState');
    super.initState();
  }

  ///
  /// SnackBar
  ///
  final GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();
  void _showSnackBar(String msg) {
    scaffoldState.currentState
        .showSnackBar(new SnackBar(content: new Text(msg), duration: Duration(milliseconds: 600)));
  }

  ///
  /// フォルダ編集
  ///
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

  ///
  /// フォルダ削除
  ///
  _folderDelete(Folder folder) async {
    var value = await showDialog(
      context: context,
      builder: (BuildContext context) => new AlertDialog(
        title: new Text('Folder Delete'),
        content: new Text('フォルダ「${folder.name}」を削除しますか？ フォルダ内にあるパターンも削除されます。', softWrap: true),
        actions: <Widget>[
          new SimpleDialogOption(
            child: new Text('NO'),
            onPressed: () {
              Navigator.pop(context, Answers.NO);
            },
          ),
          new SimpleDialogOption(
            child: new Text(
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

  //-----------------//
  // LAYOUT          //
  //-----------------//

  ///
  /// Build
  ///
  @override
  Widget build(BuildContext context) {
    log("_LearnPageState.build");

    //    fbQuery = Provider.of<FirebaseQuery>(context);
    // https://www.flutter-study.dev/create-app/provider/
    final FirebaseQuery fbQuery = context.watch<FirebaseQuery>();
    _orderBySelectedValue = fbQuery.orderBy;
    _favorite = fbQuery.favorite;
    print("fbQuery: $fbQuery");
    return Scaffold(
      key: scaffoldState,
      body: _buildBody(context),
    );
  }

  ///
  /// _BuildBody
  ///
  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.all(4.0),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: Folder.select(
                    folderType: FolderType.User, orderByField: _orderBySelectedValue, favorite: _favorite),
                builder: (context, snapshot) {
//                  if (!snapshot.hasData) return LinearProgressIndicator();
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return _buildList(context, snapshot.data.docs);
                },
              )
            ],
          )),
    );
  }

  ///
  /// _buildList
  ///
  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    ScrollController _controller = new ScrollController();

    // List<Text> texts = List<Text>();
    // for (int i = 0; i < 20; i++) {
    //   texts.add(Text(
    //     "text" + i.toString(),
    //     style: TextStyle(fontSize: 40),
    //   ));
    // }

    return ListView(
      //
      // つけないとコンテナの中でエラーが起きる
      // https://qiita.com/tabe_unity/items/4c0fa9b167f4d0a7d7c2
      shrinkWrap: true,

      // スクロール位置保持
      // https://qiita.com/umechanhika/items/a2aca1ead61045803a02
      key: PageStorageKey(0),

      // ToDo: スクロールが戻ってしまう対応 うまく行かない、要調査
      // https://www.it-swarm-ja.tech/ja/listview/flutter%EF%BC%9Alistview%E3%81%8C%E3%82%B9%E3%82%AF%E3%83%AD%E3%83%BC%E3%83%AB%E3%81%A7%E3%81%8D%E3%81%AA%E3%81%84%E3%80%81%E3%83%90%E3%82%A6%E3%83%B3%E3%82%B9%E3%81%97%E3%81%AA%E3%81%84/836853489/
      controller: _controller,
      physics: const AlwaysScrollableScrollPhysics(),

      padding: const EdgeInsets.only(top: 2.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
//      children: texts,
    );
  }

  ///
  /// _buildListItem
  ///
  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    ///
    final folder = Folder.fromSnapshot(data);

//    print("folder: $folder");

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
                leleleInstrumentIconsMap[folder.instrument],
//              size: 20,
              ),
//          title: Text(record.name),
              title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  folder.name,
                  style: TextStyle(
//                fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ]),
              subtitle: Text(
                folder.id,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
              trailing: IconButton(
                icon: folder.favorite ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
                onPressed: () {
//                  print("favfav");
                  setState(() {
                    folder.favoriteChange();
                  });
                },
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
                    print("folder: $folder");
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
