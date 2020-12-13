import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

///
/// PageRecordList
///
class PageRecordList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    log("PageRecordList.build");

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Page RecordList 0',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RecordListPage(title: 'RecordList'),
    );
  }
}

///
///
///
class RecordListPage extends StatefulWidget {
  RecordListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RecordListPageState createState() => _RecordListPageState();
}

///
///
///
class _RecordListPageState extends State<RecordListPage> {
  final GlobalKey<ScaffoldState> scaffoldstate = new GlobalKey<ScaffoldState>();

//  void _showSnackBar(String msg) {
//    scaffoldstate.currentState
//        .showSnackBar(new SnackBar(content: new Text(msg), duration: Duration(milliseconds: 600)));
//  }

  ///
  ///
  ///
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log('PageRecordList.initState');
  }

  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    log("_HomePageState.build");

    // ToDo: 一時的
    var dateFormatter = new DateFormat('yyyy/MM/dd', Intl.systemLocale);
    String today = dateFormatter.format(DateTime.now());

    return Scaffold(
        key: scaffoldstate,
//        appBar: AppBar(
//          toolbarHeight: kToolbarHeight * 0.8,
//          leading: Icon(Icons.more_horiz),
//          title: Text(widget.title),
//          actions: [
////            IconButton(
////              icon: Icon(Icons.favorite_border),
////              onPressed: () => setState(() {
////                _createNew();
////              }),
////            ),
//          ],
//        ),
        body: Container(
          decoration: BoxDecoration(color: Colors.greenAccent),
          padding: EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.orange),
//                margin: const EdgeInsets.all(2.0),
                width: MediaQuery.of(context).size.width * 0.92,
                height: 300,
                child: ListView(children: [
                  _menuItem("$today クロマチックスケール01", Icon(Icons.folder_open), Icon(Icons.playlist_play)),
                  Container(
                    decoration: BoxDecoration(color: Colors.yellow),
                    margin: EdgeInsets.all(4.0),
                    child: ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        _menuItem("  14:00:15", Icon(Icons.music_video), Icon(Icons.play_arrow)),
                        _menuItem("  13:26:32", Icon(Icons.music_video), Icon(Icons.play_arrow)),
                        _menuItem("  13:20:10", Icon(Icons.music_video), Icon(Icons.play_arrow)),
                        _menuItem("  13:11:55", Icon(Icons.music_video), Icon(Icons.play_arrow)),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ));
  }
}

Widget _menuItem(String title, Icon icon, Icon icon2) {
  return GestureDetector(
    child: Container(
        padding: EdgeInsets.all(2.0),
        decoration: new BoxDecoration(border: new Border(bottom: BorderSide(width: 1.0, color: Colors.grey))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: icon,
              margin: EdgeInsets.all(2.0),
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
            ),
            icon2,
          ],
        )),
    onTap: () {
      print("onTap called.");
    },
  );
}
