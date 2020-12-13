import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lelele_proto1/logic/data/longterm.dart';
import 'package:lelele_proto1/logic/define/lelele_constants.dart';

// class PageLongtermHistory extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Page LongtermHistory 0',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: LongtermHistoryHomePage(title: 'LongtermHistory Home 1'),
//     );
//   }
// }

///
/// 将来の目標の履歴ページ
///
class LongtermHistoryHomePage extends StatefulWidget {
  LongtermHistoryHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LongtermHistoryHomePageState createState() => _LongtermHistoryHomePageState();
}

class _LongtermHistoryHomePageState extends State<LongtermHistoryHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(appBarHeight),
          child: AppBar(
            title: Text(widget.title),
          ),
        ),
        body: _buildBody(context));
  }

  ///
  /// _BuildBody
  ///
  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          // padding: EdgeInsets.all(4.0),
          child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: Longterm.select(),
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
    final longterm = Longterm.fromSnapshot(data);

    return Container(
      decoration: BoxDecoration(
//          border: Border.all(color: Colors.grey),
        border: Border(bottom: BorderSide(color: Colors.black54)),
//          borderRadius: BorderRadius.circular(4.0),
      ),
      child: Container(
        decoration: new BoxDecoration(
//            color: Colors.orangeAccent,
//             color: Color(folder.color),
            ),
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: ListTile(
            leading: Icon(Icons.ac_unit
//                leleleInstrumentIconsMap[folder.instrument],
//              size: 20,
                ),
//          title: Text(record.name),
            title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
//                  folder.name,
                longterm.target,
                style: TextStyle(
//                fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ]),
            subtitle: Text(
//                folder.id,
              '登録日: ${longterm.createdString} - 目標日: ${longterm.goaledString}',
              style: TextStyle(
                fontSize: 11,
                color: Colors.black54,
              ),
            ),
            trailing: IconButton(
//                icon: folder.favorite ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
              icon: Icon(Icons.title),
              onPressed: () {
//                  print("favfav");
                setState(() {
//                    folder.favoriteChange();
                });
              },
            ),

            onTap: () {
//                 Navigator.push(
//                     context,
//                     CupertinoPageRoute(
// //                    MaterialPageRoute(
// //                    builder: (context) => PagePatternList(
//                       builder: (context) => PatternListHomePage(
//                         title: folder.name,
//                         folder: folder,
//                       ),
//                     ));
            },
          ),
          actions: <Widget>[
            IconSlideAction(
              caption: '削除',
              color: Colors.red,
              icon: Icons.delete,
              // onTap: () => _folderDelete(folder),
            ),
          ],
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: '編集',
              color: Colors.orangeAccent,
              icon: Icons.edit,
//                   onTap: () {
//                     print("folder: $folder");
//                     _folderEdit(folder: folder);
// //                    _patternEdit(pattern: pattern);
//                   }
            ),
          ],
        ),
      ),
    );
  }
}
