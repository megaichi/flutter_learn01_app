import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lelele_proto1/ui/page/other/test_page/_PageListViewTest.dart';
import 'package:lelele_proto1/ui/page/other/test_page/_foo_bar.dart';
import 'package:path_provider/path_provider.dart';

class PageOtherCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Page Template 0',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TemplateHomePage(title: 'Template Home 1'),
    );
  }
}

class TemplateHomePage extends StatefulWidget {
  TemplateHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TemplateHomePageState createState() => _TemplateHomePageState();
}

class _TemplateHomePageState extends State<TemplateHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.all(16.0),
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  RaisedButton(
                    child: Text("Crashlytics Test"),
                    onPressed: () {
                      // Crashlytics Crash
                      try {
                        FirebaseCrashlytics.instance.crash();
                      } catch (e, stackTrace) {
                        print(e); //Bad state: the door is locked
                        print(stackTrace);
                      }
                    },
                  ),
                  Text("← 押すとアプリが落ちます")
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  RaisedButton(
                    child: Text("File List"),
                    onPressed: () {
                      getFileList();
                    },
                  ),
                  Text("ファイル一覧、サイズまだ")
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  RaisedButton(
                    child: Text("Animated Dialog"),
                    onPressed: () {
                      // https://medium.com/flutter-community/how-to-animate-dialogs-in-flutter-here-is-answer-492ea3a7262f
                      showGeneralDialog(
                          barrierColor: Colors.black.withOpacity(0.5),
                          transitionBuilder: (context, a1, a2, widget) {
                            return Transform.scale(
                              scale: a1.value,
                              child: Opacity(
                                opacity: a1.value,
                                child: AlertDialog(
                                  shape: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                                  title: Text('Hello!!'),
                                  content: Text('How are you?'),
                                ),
                              ),
                            );
                          },
                          transitionDuration: Duration(milliseconds: 300),
                          barrierDismissible: true,
                          barrierLabel: '',
                          context: context,
                          pageBuilder: (context, animation1, animation2) {});
                    },
                  ),
                  Text("アニメポップアップ")
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  RaisedButton(
                    child: Text("AutoHide Dialog"),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            Future.delayed(Duration(seconds: 2), () {
                              Navigator.of(context).pop(true);
                            });
                            return AlertDialog(
                              title: Text('Title'),
                            );
                          });
                    },
                  ),
                  Text("自動で消えるダイアログ")
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  RaisedButton(
                    child: Text("ListView test"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
//                    MaterialPageRoute(
//                    builder: (context) => PagePatternList(
                            builder: (context) => ListViewTestHomePage(
                              title: 'ListView test',
                            ),
                          ));
                    },
                  ),
                  Text("ListView動作確認")
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  RaisedButton(
                    child: Text("FooBarHomePage"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
//                    MaterialPageRoute(
//                    builder: (context) => PagePatternList(
                            builder: (context) => FooBarHomePage(
                              title: 'FooBarHomePage',
                            ),
                          ));
                    },
                  ),
                  Text("FooBarHomePage")
                ]),
                Card(
                    color: Colors.grey,
                    child: Padding(
                      padding: EdgeInsets.all(2.0),
                      child: TextField(
                        maxLines: null,
                        decoration: InputDecoration.collapsed(hintText: fileList),
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    )),
              ])),
        ));
  }

  String fileList = "";

  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  ///
  /// 動かない ▶ 2020/10/18 動いた
  /// Unhandled Exception: type 'Future<dynamic>' is not a subtype of type 'Directory'
  ///
  getFileList() async {
    Future<String> futurePath = this.localPath;
    String value = await futurePath;

//    var entry = Directory(dir.path).listSync();
    List<FileSystemEntity> entryList = Directory(value).listSync();

    entryList.forEach((entry) {
      List<String> listString = entry.path.split('/');
      String fileName = listString[listString.length - 1];

      File file = File(entry.path);
      int fileSize = 0;
      Future<int> futureFileSize = file.length();
      futureFileSize.then((value) => fileSize = value);

      print(fileName + " " + fileSize.toString());
      setState(() {
        fileList += fileName + "\n";
      });
    });

    //    List<FileSystemEntity> entry = LeUtil.dirContents(dir) as List<FileSystemEntity>;
  }
}
