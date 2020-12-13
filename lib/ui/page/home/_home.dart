import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lelele_proto1/logic/data/longterm.dart';
import 'package:lelele_proto1/logic/define/lelele_constants.dart';
import 'package:lelele_proto1/ui/mixin/cupertino_navigator.dart';
import 'package:lelele_proto1/ui/page/home/longterm_edit.dart';
import 'package:lelele_proto1/ui/page/home/longterm_history.dart';
import 'package:lelele_proto1/ui/page/home/song_edit.dart';
import 'package:lelele_proto1/ui/page/home/song_history.dart';
import 'package:lelele_proto1/ui/page/home/target_edit.dart';
import 'package:lelele_proto1/ui/page/home/target_history.dart';

///
/// PageHome
///
class PageHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    log("PageHome.build");

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Page Home 0',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(title: 'Home'),
    );
  }
}

///
///
///
class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

///
///
///
// ToDo: mixin のテスト実装 記述が長くなるので、短くするために CupertinoNavigator を実装
class _HomePageState extends State<HomePage> with CupertinoNavigator {
  Longterm longterm;

  ///
  ///
  ///
  @override
  void initState() {
    log('PageHome.initState');

    if (longterm == null) {
      longterm = Longterm(target: '');
    }

    _getCurrentTarget();

    if (longterm == null) {
      longterm = Longterm();
    }

    super.initState();
  }

  ///
  final GlobalKey<ScaffoldState> scaffoldstate = new GlobalKey<ScaffoldState>();

  void _showSnackBar(String msg) {
    scaffoldstate.currentState
        .showSnackBar(new SnackBar(content: new Text(msg), duration: Duration(milliseconds: 600)));
  }

  // void _favorite() {}

  String currentFutureTarget;

  _getCurrentTarget() {
    // ToDo: 長期目標(将来の目標) 取得、メソッド内では取得できているが戻ってこない
    String futureTarget = Longterm.getCurrentLongterm();
    setState(() {
//      String futureTarget = FutureTarget.getCurrentFuture();
      currentFutureTarget = Longterm.getCurrentLongterm();
      print('currentFutureTarget: $currentFutureTarget');
    });
  }

  _todayTargetComplete() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('「エーテルをゆっくり弾けるようになる」を達成済みにしますか？'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RaisedButton(
                  color: Colors.blue,
                  onPressed: () {},
                  child: Text('Cancel'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                RaisedButton(
                  color: Colors.blue,
                  onPressed: () {},
                  child: Text('OK'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    log("_HomePageState.build");

//     // Memo: エミュレータを使う場合
// //    var settings = Firestore.instance.settings(host: "http://localhost:4000/", sslEnabled: true);

    // ToDo: 国際化対応、Qiitaとは、説明が違う
    // https://medium.com/flutter-community/new-localization-flutter-1-22-i18n-and-l10n-support-774d6542ee6a
//    S l10n() => S.current;

    return Scaffold(
        key: scaffoldstate,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(appBarHeight),
          child: AppBar(
//            toolbarHeight: kToolbarHeight * 0.8,
            leading: Icon(Icons.home),
            centerTitle: true,
            title: Text(widget.title),
          ),
        ),
        body: _buildBody(context));
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
//            color: Colors.black12,
            padding: EdgeInsets.all(4.0),
            margin: EdgeInsets.all(4.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        child: Text(
                          '長期目標：',
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () {
                          navigatorPush(context, LongtermHistoryHomePage(title: '長期目標履歴'));
                        }),
//                     Text(
// // ToDo: 多言語対応、AppLocalizations.of(context).futureGoals がエラーになる null
//                       "長期目標",
// //                      AppLocalizations.of(context).futureGoals,
//                       style: TextStyle(fontSize: 16),
//                     ),
                    IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          navigatorPush(
                              context,
                              LongtermEditHomePage(
                                title: '長期目標 編集',
                                longterm: longterm,
                              ));
                        })
                  ],
                ),
                Card(
                  child: Container(
                    margin: EdgeInsets.all(2.0),
                    width: MediaQuery.of(context).size.width * 0.98,
                    child: Text(
                      currentFutureTarget ?? '長期目標を設定しましょう',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        child: Text(
                          '現在の目標：',
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () {
                          navigatorPush(context, TargetHistoryHomePage(title: 'Target History'));
                        }),
                    IconButton(
                        icon: Icon(Icons.add_circle_outline),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          navigatorPush(
                              context,
                              TargetEditHomePage(
                                title: '現在の目標',
                                longterm: longterm,
                              ));
                        })
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.blueGrey),
                    ),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.face,
//              size: 20,
                    ),
                    title: Text("エーテルをゆっくり弾けるようになる"),
                    isThreeLine: true,
                    subtitle: Text(
                      "登録日：2020/09/12 経過日数：16日 目標日：2020/10/1 残り23日",
                      style: TextStyle(fontSize: 10),
                    ),
                    trailing: InkWell(
                      child: IconButton(
                        icon: Icon(Icons.check),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          _todayTargetComplete();
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.blueGrey),
                    ),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.face,
//              size: 20,
                    ),
                    title: Text("スケール練習"),
                    isThreeLine: true,
                    subtitle: Text(
                      "登録日：2020/09/12 経過日数：16日 目標日：2020/10/1 残り23日",
                      style: TextStyle(fontSize: 10),
                    ),
                    trailing: InkWell(
                      child: IconButton(
                        icon: Icon(Icons.check),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          _todayTargetComplete();
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.blueGrey),
                    ),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.face,
//              size: 20,
                    ),
                    title: Text("アルペジオをキレイに"),
                    isThreeLine: true,
                    subtitle: Text(
                      "登録日：2020/09/12 経過日数：16日 目標日：2020/10/1 残り23日",
                      style: TextStyle(fontSize: 10),
                    ),
                    trailing: InkWell(
                      child: IconButton(
                        icon: Icon(Icons.check),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          _todayTargetComplete();
                        },
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        child: Text(
                          '課題曲：',
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) {
                                return SongHistoryHomePage(title: 'Assignment Song History');
                              },
                            ),
                          );
                        }),
                    IconButton(
                        icon: Icon(Icons.add_circle_outline),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) {
                                return SongEditHomePage(title: 'Song Edit');
                              },
                            ),
                          );
                        })
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.blueGrey),
                    ),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.music_note,
//              size: 20,
                    ),
                    title: Text("瀧澤克成 - エーテル"),
//                    isThreeLine: true,
//                     subtitle: Text(
//                       "aaa",
//                       style: TextStyle(fontSize: 10),
//                     ),
                    trailing: InkWell(
                      child: IconButton(
                        icon: Icon(Icons.play_arrow),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          print("aaa");
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.blueGrey),
                    ),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.music_note,
//              size: 20,
                    ),
                    title: Text("Beatles - Help"),
//                    isThreeLine: true,
//                     subtitle: Text(
//                       "aaa",
//                       style: TextStyle(fontSize: 10),
//                     ),
                    trailing: InkWell(
                      child: IconButton(
                        icon: Icon(Icons.play_arrow),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          print("aaa");
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            )));
  }
}
