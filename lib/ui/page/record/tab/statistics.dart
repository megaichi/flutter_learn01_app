import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///
/// PageRecordStatictics
///
class PageRecordStatictics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    log("PageRecordStatictics.build");

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Page RecordStatictics 0',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RecordStaticticsPage(title: 'RecordStatictics'),
    );
  }
}

///
///
///
class RecordStaticticsPage extends StatefulWidget {
  RecordStaticticsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RecordStaticticsPageState createState() => _RecordStaticticsPageState();
}

///
///
///
class _RecordStaticticsPageState extends State<RecordStaticticsPage> {
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
    log('PageRecordStatictics.initState');
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    log("_HomePageState.build");

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
        padding: EdgeInsets.all(4.0),
        child: Container(
            margin: const EdgeInsets.all(4.0),
            width: MediaQuery.of(context).size.width * 0.92,
//            height: 600,
            child: Column(
              children: [
                Card(
                  margin: const EdgeInsets.all(4.0),
                  child: Container(
                      margin: const EdgeInsets.all(4.0),
                      width: MediaQuery.of(context).size.width * 0.96,
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '練習時間合計：',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            '32:25:16',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      )),
                ),
                Card(
                  margin: const EdgeInsets.all(4.0),
                  child: Container(
                      margin: const EdgeInsets.all(4.0),
                      width: MediaQuery.of(context).size.width * 0.96,
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '1日の平均練習時間：',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            '01:32:16',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      )),
                ),
                Card(
                  margin: const EdgeInsets.all(4.0),
                  child: Container(
                      margin: const EdgeInsets.all(4.0),
                      width: MediaQuery.of(context).size.width * 0.96,
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '練習した日数：',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            '25日',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      )),
                ),
                Card(
                  margin: const EdgeInsets.all(4.0),
                  child: Container(
                      margin: const EdgeInsets.all(4.0),
                      width: MediaQuery.of(context).size.width * 0.96,
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '今週の練習時間：',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            '25日',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      )),
                ),
                Card(
                  margin: const EdgeInsets.all(4.0),
                  child: Container(
                      margin: const EdgeInsets.all(4.0),
                      width: MediaQuery.of(context).size.width * 0.96,
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '今月の練習時間：',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            '25日',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      )),
                ),
                Card(
                  margin: const EdgeInsets.all(4.0),
                  child: Container(
                      margin: const EdgeInsets.all(4.0),
                      width: MediaQuery.of(context).size.width * 0.96,
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '今年の練習時間：',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            '25日',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      )),
                ),
              ],
            )),
      ),
    );
  }
}
