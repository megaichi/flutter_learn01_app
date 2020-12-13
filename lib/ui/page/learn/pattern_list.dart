import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lelele_proto1/assets/lelele_icon_map.dart';
import 'package:lelele_proto1/logic/define/lelele_constants.dart';
import 'package:lelele_proto1/logic/define/lelele_enum.dart';
import 'package:lelele_proto1/lelelearn_app.dart';
import 'package:lelele_proto1/logic/data/folder.dart';
import 'package:lelele_proto1/logic/data/pattern.dart';
import 'package:lelele_proto1/ui/page/learn/pattern_edit.dart';
import 'package:lelele_proto1/ui/page/learn/pattern_play.dart';
import 'package:page_transition/page_transition.dart';

///
/// パターンリストページ
///
class PagePatternList extends StatelessWidget {
  final Folder folder;

  PagePatternList({Key key, this.folder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("folder: $folder");

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Page PatternList 0',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
//      home: PatternListHomePage(title: folder.name),
      home: PatternListHomePage(title: folder.name, folder: folder),
    );
  }
}

class PatternListHomePage extends StatefulWidget {
  PatternListHomePage({Key key, this.title, this.folder}) : super(key: key);

  final String title;
  final Folder folder;

  @override
  _PatternListHomePageState createState() => _PatternListHomePageState(folder);
}

class _PatternListHomePageState extends State<PatternListHomePage> {
  ///
  final GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();

  final Folder folder;

  _PatternListHomePageState(this.folder);

//  TextEditingController _textEditingControllerOne;

  @override
  initState() {
    _listIndex = 1;

//    _textEditingControllerOne = TextEditingController();

    super.initState();
  }

  void _showSnackBar(String msg) {
    scaffoldState.currentState
        .showSnackBar(new SnackBar(content: new Text(msg), duration: Duration(milliseconds: 600)));
  }

  // void _favorite() {}

  _patternDelete(Pattern pattern) async {
    var value = await showDialog(
      context: context,
      builder: (BuildContext context) => new AlertDialog(
        title: new Text('Pattern Delete'),
        content: new Text('パターン「${pattern.name}」を削除しますか？ ', softWrap: true),
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
        pattern.delete();
        break;
      case Answers.NO:
        break;
    }
  }

  ///
  /// パターン編集
  ///
  void _patternEdit({Pattern pattern}) {
    if (pattern == null) {
      pattern = Pattern(folder: folder);
    }

    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.bottomToTop,
            child: PatternEditPage(title: 'Pattern Edit', pattern: pattern, folder: folder)));
  }

  ///
  /// パターン複製
  ///
  void _patternDupulicate({Pattern pattern}) {
    _showSnackBar(pattern.name + "を複製しました");
    pattern.id = null;
    pattern.add();
  }

  var _selectedValue = 'name';

  @override
  Widget build(BuildContext context) {
    // List<Pattern> patterns = [];
    // for (int i = 1; i <= 10; i++) {
    //   patterns.add(Pattern(id: Uuid().v4(), name: "chromatic$i"));
    // }

    return Scaffold(
      key: scaffoldState,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight + 10),
        child: AppBar(
//        backgroundColor: Color(folder.color),
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            //mainAxisSize: MainAxisSize.min,
//          mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.of(context).pop(),
              ),
//            IconButton(icon: Icon(Icons.favorite_border)),
            ],
          ),

          centerTitle: true,
          title: Text(widget.title),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _patternEdit();
                }),
          ],
        ),
      ),
      body: _buildBody(context),
    );
  }

  // 交互に色つけ用
  int _listIndex = 1;

  Widget _buildBody(BuildContext context) {
    print("folder: $folder");

    _listIndex = 1;
    return Container(
//        padding: EdgeInsets.all(4.0),
        child: SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: Pattern.select(folderType: FolderType.User, folderId: folder.id, orderByField: "name"),
            builder: (context, snapshot) {
//                  if (!snapshot.hasData) return LinearProgressIndicator();
              if (!snapshot.hasData) return LinearProgressIndicator();
              return _buildList(context, snapshot.data.docs);
            },
          )
        ],
      ),
    ));
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return Container(
        child: ListView(
      // つけないとコンテナの中でエラーが起きる
      // https://qiita.com/tabe_unity/items/4c0fa9b167f4d0a7d7c2
      shrinkWrap: true,
//      padding: const EdgeInsets.only(top: 4.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    ));
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    ///
    final pattern = Pattern.fromSnapshot(data, folder);
    _listIndex++;

    Color folderColor = _listIndex % 2 == 0 ? Color(folder.color) : Colors.white;
    Text subtitle = Text(
      'T=' +
          pattern.tempoGoal.toString() +
          ', B=' +
          pattern.beat.toString() +
          ', R=' +
          pattern.repeatCount.toString() +
          ', TU=' +
          pattern.tempoupBpm.toString() +
          '/' +
          pattern.tempoupCount.toString(),
      style: TextStyle(fontSize: 14),
    );

    return Container(
      key: ValueKey(pattern.name),
      decoration: BoxDecoration(
//        border: Border.all(color: Colors.grey),
//        borderRadius: BorderRadius.circular(4.0),
          ),
      child: Container(
        decoration: new BoxDecoration(
//            color: Colors.orangeAccent,
          color: folderColor,
//          color: folderColor,
        ),
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: ListTile(
            leading: Icon(
//              Icons.music_note,
              leleleInstrumentIconsMap[folder.instrument],
//              size: 20,
            ),
            title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              // AutoSizeTextField(
              //   controller: _textEditingControllerOne,
              //   minFontSize: 10,
              //   style: TextStyle(fontSize: 18),
              // ),
              Text(
                pattern.name,
                style: TextStyle(
//                fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Text(
                pattern.id,
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.grey,
                ),
              )
            ]),
            isThreeLine: true,
            subtitle: subtitle,
            trailing: InkWell(
              child: IconButton(
                icon: Icon(Icons.play_arrow),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  print("aaa");
                },
              ),
            ),

            // IconButton(
            //   icon: Icon(Icons.play_arrow),
            //   onPressed: () {},
            // ),

            onTap: () {

            // ToDo: ここで AdMobを非表示にしたい
            // https://stackoverflow.com/questions/50972863/admob-banner-how-to-show-only-on-home
//              LelelearnApp.admobBanner.;
              Navigator.push(
                  context,
                  CupertinoPageRoute(
//                      builder: (context) => PageLearnPatternPlay(pattern: pattern), fullscreenDialog: true));
                      builder: (context) => LearnPatternPlay(title: pattern.name, pattern: pattern),
                      fullscreenDialog: true));
            },
          ),
          actions: <Widget>[
            IconSlideAction(
              caption: '移動',
              color: Colors.lightGreenAccent,
              icon: Icons.content_copy,
              onTap: () => _showSnackBar('移動'),
            ),
            IconSlideAction(
              caption: '削除',
              color: Colors.red,
              icon: Icons.delete,
//              onTap: () => _showSnackBar('Delete'),
              onTap: () => _patternDelete(pattern),
            ),
//            IconSlideAction(
//              caption: 'Archive',
//              color: Colors.blue,
//              icon: Icons.archive,
//              onTap: () => _showSnackBar('Archive'),
//            ),
          ],
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: '複製',
              color: Colors.limeAccent,
              icon: Icons.content_copy,
              onTap: () => _patternDupulicate(pattern: pattern),
            ),
            IconSlideAction(
                caption: '編集',
                color: Colors.orangeAccent,
                icon: Icons.edit,
                onTap: () {
                  _patternEdit(pattern: pattern);
                }),
          ],
        ),
      ),
    );
  }
}
