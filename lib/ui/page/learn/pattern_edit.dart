import 'dart:developer';

import 'package:audiotagger/audiotagger.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lelele_proto1/logic/data/folder.dart';
import 'package:lelele_proto1/logic/data/pattern.dart';
import 'package:lelele_proto1/logic/define/lelele_constants.dart';
import 'package:lelele_proto1/logic/define/lelele_enum.dart';
import 'package:lelele_proto1/logic/util/lelele_util.dart';
import 'package:numberpicker/numberpicker.dart';

///
/// PagePatternEdit
///
// class PagePatternEdit extends StatelessWidget {
//   final Pattern pattern;
//   final Folder folder;
//
//   PagePatternEdit({Key key, this.pattern, this.folder}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     log("PagePatternEdit.build");
//
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Page PatternEdit 0',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: PatternEditPage(title: 'PatternEdit Edit', pattern: pattern),
//     );
//   }
// }

///
/// パターン編集ページ
///
class PatternEditPage extends StatefulWidget {
  PatternEditPage({Key key, this.title, this.pattern, this.folder}) : super(key: key);

  final String title;
  final Pattern pattern;
  final Folder folder;

  @override
  _PatternEditPageState createState() => _PatternEditPageState(pattern, folder);
}

///
///
///
class _PatternEditPageState extends State<PatternEditPage> {
  final GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();

  final Pattern pattern;
  final Folder folder;

  _PatternEditPageState(this.pattern, this.folder);

  //  void _showSnackBar(String msg) {
//    scaffoldstate.currentState
//        .showSnackBar(new SnackBar(content: new Text(msg), duration: Duration(milliseconds: 600)));
//  }

  /// お手本サウンドのフルパス
  String _soundFilePath = "";

  /// お手本サウンドの表示名
//  String _soundFileName = "";

  /// スコアのフルパス
  // String _scoreFilePath = "";

  // スコアの表示名
  // String _scoreFileName = "";

  var _playStart = '0:00:00';
  var _playEnd = '0:00:00';
  var _playRangeValues = RangeValues(0.0, 120.0);

  ///
  ///
  ///
  @override
  void initState() {
    log('PagePatternEdit.initState');
//    _setScoreImage();
    _getScoreImage();
    super.initState();
  }

//  NetworkImage _scoreImage;

  // _setScoreImage() {
  //   setState(() {
  //     if (pattern.scoreFilePath != null) {
  //       _scoreImage = NetworkImage(pattern.scoreFilePath);
  //     }
  //   });
  // }

  // Validate
  final _formKey = GlobalKey<FormState>();

  TransformationController controller = TransformationController();
  String velocity = "VELOCITY";

  ///
  /// スコアのイメージを取得する
  ///
  Widget _getScoreImage() {
    Widget widget = Placeholder();

    // ToDo: 謎のエラーが頻発するので一旦コメントアウト learn_pattern_play.dartも
    // bool fileExists = false;
    //
    // if (pattern.scoreFilePath != null) {
    //   Future<bool> futureFileExists = io.File(pattern.scoreFilePath).exists();
    //   futureFileExists.then((value) => fileExists = value == null ? false : fileExists);
    // }
    //
    // if (pattern.scoreFilePath != null && fileExists) {
    //   try {
    //     widget = InteractiveViewer(
    //       child: Image.asset(pattern.scoreFilePath),
    //       transformationController: controller,
    //       boundaryMargin: EdgeInsets.all(5.0),
    //       onInteractionEnd: (ScaleEndDetails endDetails) {
    //         print(endDetails);
    //         print(endDetails.velocity);
    //         controller.value = Matrix4.identity();
    //         setState(() {
    //           velocity = endDetails.velocity.toString();
    //         });
    //       },
    //     );
    //   } catch (e) {
    //     print(e); //Bad state: the door is locked
    //     widget = Placeholder();
    //   }
    // }
    return widget;
  }

  String _fileName;
  List<PlatformFile> _paths;
  String _directoryPath;
  String _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;
  TextEditingController _controller = TextEditingController();

  //    void _openFileExplorer() async {
  void _openFileExplorer(LearnMedia media) async {
    setState(() => _loadingPath = true);
    try {
//        _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
//          type: FileType.any,
//          type: media == LearnMedia.Score ? FileType.image : FileType.audio,
        type: FileType.any,

//          allowMultiple: _multiPick,
        allowMultiple: false,
        allowedExtensions: (_extension?.isNotEmpty ?? false) ? _extension?.replaceAll(' ', '')?.split(',') : null,
      ))
          ?.files;

      print("_paths.path: " + _paths[0].path);
      print("_paths.name: " + _paths[0].name);
    } on PlatformException catch (e) {
      print("Unsupported operation: " + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
//      setState(() async {
    _loadingPath = false;

    // Memo: 修正
    //        _fileName = _paths != null ? _paths.map((e) => e.name).toString() : '...';
    switch (media) {
      case LearnMedia.Sound:
//          _soundFileName = _paths != null ? _paths[0].name : '';
//          _soundFilePath = _paths != null ? _paths[0].path : '';
        pattern.soundFileName = _paths != null ? _paths[0].name : '';
        pattern.soundFilePath = _paths != null ? _paths[0].path : '';
//           if (_paths != null) {
//             _soundFilePath = _paths != null ? _paths[0].path : '';
//             tagMap = await tagger.readTagsAsMap(path: _paths[0].path);
//             _soundFileName = tagMap['artist'] + " - " + tagMap['title'];
//           }
        break;
      case LearnMedia.Score:
        // _scoreFileName = _paths != null ? _paths[0].name : '';
        // _scoreFilePath = _paths != null ? _paths[0].path : '';
        pattern.scoreFileName = _paths != null ? _paths[0].name : '';
        pattern.scoreFilePath = _paths != null ? _paths[0].path : '';
//          _setScoreImage();
        _getScoreImage();
        break;
    }

//      });

    // Tag
    // if (_paths != null) {
    //   tagMap = await tagger.readTagsAsMap(
    //       path: _paths[0].path
    //   );
    //   print("tagMap:");
    //   print(tagMap);
    // } else {
    //   print("_paths=null");
    // }
  }

//    print("tagMap[artist] " + tagMap["artist"] );

  ///
  ///
  ///
  _soundFilePick() {
    setState(() {
      _openFileExplorer(LearnMedia.Sound);
//       _soundFileName = tagMap["artist"] + " - " + tagMap["title"];
    });
  }

  ///
  ///
  ///
  _scoreFilePick() {
    _openFileExplorer(LearnMedia.Score);
  }

  ///
  ///
  ///
  Duration _intToDuration(double seconds) {
    int hour = seconds >= 3600 ? (seconds / 3600).round() : 0;
    int minute = seconds >= 60 ? ((seconds - hour * 3600) / 60).round() : 0;
    int second = seconds > 0 ? ((seconds - (hour * 3600 + minute * 60))).round() : 0;

    Duration d = Duration(hours: hour, minutes: minute, seconds: second);
    return d;
  }

  ///
  ///
  ///
  _updateRangeLabels(RangeValues values) {
    _playStart = LeleleUtil.durationToString(_intToDuration(_playRangeValues.start));
    _playEnd = LeleleUtil.durationToString(_intToDuration(_playRangeValues.end));
  }

  _showModalNumberPicker(dynamic item, int min, int max) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 100,
          child: NumberPicker.integer(
              initialValue: item,
              minValue: min,
              maxValue: max,
              onChanged: (num) {
                setState(() {
                  print("num: $num");
                  item = num;
                });
              }),
        );
      },
    );
  }

  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    log("_HomePageState.build");

    // ToDo: ファイル選択 エラー処理の修正
    //
    // ファイルエクスプローラーをインストールすること？
    // Can't find a valid activity to handle the request. Make sure you've a file explorer installed.
    //

    Map tagMap;
    Audiotagger tagger = Audiotagger();

    // ToDo: メソッドがbuild の中になっているので外出しする

    return Scaffold(
        // 実機でサイズがおかしくなる対応
        // https://qiita.com/fujit33/items/81494e22986083c212f4
        // resizeToAvoidBottomPadding: false,
        key: scaffoldState,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(appBarHeight),
          child: AppBar(
            leading: Icon(Icons.edit),
            title: Text(widget.title),
            actions: [
//            IconButton(
//              icon: Icon(Icons.favorite_border),
//              onPressed: () => setState(() {
//                _createNew();
//              }),
//            ),
            ],
          ),
        ),
        body: Container(
//            color: Colors.yellow,
            margin: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Expanded(
                  flex: 4,
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: TextFormField(
//                              autofocus: true,
                              controller: TextEditingController(text: pattern.name),
                              decoration: InputDecoration(labelText: 'パターン名'),
                              onChanged: (text) {
                                pattern.name = text;
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'パターン名を入力してください';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "お手本",
                                      style: TextStyle(fontSize: 20, color: Theme.of(context).primaryColor),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: FlatButton(
                                              color: Theme.of(context).primaryColor,
                                              child: Text("iCloud"),
                                              onPressed: () => _soundFilePick()),
                                        ),
                                        FlatButton(
                                            color: Theme.of(context).primaryColor,
                                            child: Text("選択"),
                                            onPressed: () => _soundFilePick()),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    // Text(
                                    //   "再生位置",
                                    //   style: TextStyle(fontSize: 16),
                                    // ),
                                    Expanded(
                                      child: RangeSlider(
                                        labels: RangeLabels(_playStart, _playEnd),
                                        values: _playRangeValues,
                                        min: 0,
                                        max: 120,
                                        divisions: 120,
                                        onChanged: (values) {
                                          _playRangeValues = values;
                                          setState(() => _updateRangeLabels(values));
                                        },
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.play_arrow),
                                      color: Theme.of(context).accentColor,
                                      onPressed: () {},
                                    )
                                  ],
                                ),
                                TextFormField(
                                  maxLines: null,
                                  enabled: false,
                                  readOnly: true,
                                  controller: TextEditingController(text: pattern.soundFileName),
                                  decoration: InputDecoration(labelText: 'ファイル名'),
                                ),
                                Visibility(
//                    visible: false,
                                  child: TextFormField(
                                    maxLines: null,
                                    enabled: false,
                                    readOnly: true,
                                    controller: TextEditingController(text: pattern.soundFilePath),
                                    decoration: InputDecoration(labelText: 'お手本フルパス'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Memo:
                          // https://flutter.keicode.com/basics/rangeslider.php
                          Container(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "楽譜",
                                      style: TextStyle(fontSize: 20, color: Theme.of(context).primaryColor),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: FlatButton(
                                              color: Theme.of(context).primaryColor,
                                              child: Text("iCloud"),
                                              onPressed: () => _scoreFilePick()),
                                        ),
                                        FlatButton(
                                            color: Theme.of(context).primaryColor,
                                            child: Text("選択"),
                                            onPressed: () => _scoreFilePick()),
                                      ],
                                    ),
                                  ],
                                ),
                                TextFormField(
                                  maxLines: null,
                                  enabled: false,
                                  readOnly: true,
//                                  controller: TextEditingController(text: _scoreFileName),
                                  controller: TextEditingController(text: pattern.scoreFileName),
                                  decoration: InputDecoration(labelText: 'ファイル名'),
                                ),
                                Visibility(
//                    visible: false,
                                  child: TextFormField(
                                    maxLines: null,
                                    enabled: false,
                                    readOnly: true,
//                                    controller: TextEditingController(text: _scoreFilePath),
                                    controller: TextEditingController(text: pattern.scoreFilePath),
                                    decoration: InputDecoration(labelText: '楽譜フルパス'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width * 0.75,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(child: _getScoreImage()

//                               _scoreImage == null
//                                   ? Placeholder()
// //                                     : PhotoView(
// // //                              imageProvider: AssetImage("assets/images/altanate_guitar.gif"),
// //                                         imageProvider: _scoreImage,
// //                                       )
//                                   : InteractiveViewer(
//                                       child: Image.asset(pattern.scoreFilePath),
//                                       transformationController: controller,
//                                       boundaryMargin: EdgeInsets.all(5.0),
//                                       onInteractionEnd: (ScaleEndDetails endDetails) {
//                                         print(endDetails);
//                                         print(endDetails.velocity);
//                                         controller.value = Matrix4.identity();
//                                         setState(() {
//                                           velocity = endDetails.velocity.toString();
//                                         });
//                                       },
//                                     ),
                                ),
                          ),
                          Container(
                            child: TextFormField(
                              controller: TextEditingController(text: pattern.repeatCount.toString()),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(labelText: '練習回数', hintText: "録音、再生の繰り返し回数です。"),
                              onTap: () {
                                // ToDo: メソッド化したいがうまく動かない
//                                    _showModalNumberPicker(pattern.beat, 1, 24);

                                showModalBottomSheet<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 100,
                                      child: NumberPicker.integer(
                                          initialValue: pattern.repeatCount,
                                          minValue: 1,
                                          maxValue: 99,
                                          onChanged: (num) {
                                            setState(() {
                                              pattern.repeatCount = num;
                                            });
                                          }),
                                    );
                                  },
                                );
                              }, // onTap
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                Text(
                                  "メトロノームモード",
                                  style: TextStyle(fontSize: 20, color: Theme.of(context).primaryColor),
                                ),
                                TextFormField(
                                  readOnly: true,
                                  controller: TextEditingController(text: pattern.beat.toString()),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(labelText: '拍子'),
                                  onTap: () {
                                    showModalBottomSheet<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          height: 100,
                                          child: NumberPicker.integer(
                                              initialValue: pattern.beat,
                                              minValue: 1,
                                              maxValue: 24,
                                              onChanged: (num) {
                                                setState(() {
                                                  pattern.beat = num;
                                                });
                                              }),
                                        );
                                      },
                                    );
                                  }, // onTap
                                ),
                                // NumberPicker.integer(initialValue: 50, minValue: 0, maxValue: 100, onChanged: (num) {}),

//                                MyTextFormField(),
                                TextFormField(
                                  readOnly: true,
                                  controller: TextEditingController(text: pattern.measureCountIn.toString()),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(labelText: 'カウントイン小節数'),
                                  onTap: () {
                                    showModalBottomSheet<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          height: 100,
                                          child: NumberPicker.integer(
                                              initialValue: pattern.measureCountIn,
                                              minValue: 1,
                                              maxValue: 24,
                                              onChanged: (num) {
                                                setState(() {
                                                  pattern.measureCountIn = num;
                                                });
                                              }),
                                        );
                                      },
                                    );
                                  }, // onTap
                                ),
                                TextFormField(
                                  readOnly: true,
                                  controller: TextEditingController(text: pattern.measureCount.toString()),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(labelText: '練習小節数'),
                                  onTap: () {
                                    showModalBottomSheet<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          height: 100,
                                          child: NumberPicker.integer(
                                              initialValue: pattern.measureCountIn,
                                              minValue: 1,
                                              maxValue: 8,
                                              onChanged: (num) {
                                                setState(() {
                                                  pattern.measureCountIn = num;
                                                });
                                              }),
                                        );
                                      },
                                    );
                                  }, // onTap
                                ),
                                TextFormField(
                                  readOnly: true,
                                  controller: TextEditingController(text: pattern.tempoGoal.toString()),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(labelText: '目標テンポ'),
                                  onTap: () {
                                    showModalBottomSheet<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          height: 100,
                                          child: NumberPicker.integer(
                                              initialValue: pattern.tempoGoal,
                                              minValue: 40,
                                              maxValue: 200,
                                              onChanged: (num) {
                                                setState(() {
                                                  pattern.tempoGoal = num;
                                                });
                                              }),
                                        );
                                      },
                                    );
                                  }, // onTap
                                ),
                                TextFormField(
                                  readOnly: true,
                                  controller: TextEditingController(text: pattern.tempoBase.toString()),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(labelText: '練習テンポ'),
                                  onTap: () {
                                    showModalBottomSheet<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          height: 100,
                                          child: NumberPicker.integer(
                                              initialValue: pattern.tempoBase,
                                              minValue: 40,
                                              maxValue: 200,
                                              onChanged: (num) {
                                                setState(() {
                                                  pattern.tempoBase = num;
                                                });
                                              }),
                                        );
                                      },
                                    );
                                  }, // onTap
                                ),
                                TextFormField(
                                  readOnly: true,
                                  controller: TextEditingController(text: pattern.tempoupCount.toString()),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(labelText: 'テンポアップ-回数'),
                                  onTap: () {
                                    showModalBottomSheet<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          height: 100,
                                          child: NumberPicker.integer(
                                              initialValue: pattern.tempoupCount,
                                              minValue: 1,
                                              maxValue: 10,
                                              onChanged: (num) {
                                                setState(() {
                                                  pattern.tempoupCount = num;
                                                });
                                              }),
                                        );
                                      },
                                    );
                                  }, // onTap
                                ),
                                TextFormField(
                                  readOnly: true,
                                  controller: TextEditingController(text: pattern.tempoupBpm.toString()),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(labelText: 'テンポアップ-テンポ'),
                                  onTap: () {
                                    showModalBottomSheet<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          height: 100,
                                          child: NumberPicker.integer(
                                              initialValue: pattern.tempoupBpm,
                                              minValue: 1,
                                              maxValue: 40,
                                              onChanged: (num) {
                                                setState(() {
                                                  pattern.tempoupBpm = num;
                                                });
                                              }),
                                        );
                                      },
                                    );
                                  }, // onTap
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                Text(
                                  "タイムモード",
                                  style: TextStyle(fontSize: 20, color: Theme.of(context).primaryColor),
                                ),
                                TextFormField(
                                  readOnly: true,
                                  onTap: () {
                                    showModalBottomSheet<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          height: 200,
//                                  color: Colors.amber,
                                          child: CupertinoTimerPicker(
                                            initialTimerDuration: pattern.recordTimeDuration,
                                            mode: CupertinoTimerPickerMode.hms,
                                            onTimerDurationChanged: (value) {
                                              setState(() {
                                                pattern.recordTimeDuration = value;
                                              });
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  controller: TextEditingController(text: pattern.recordTimeString),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(labelText: '録音時間'),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            child: TextFormField(
                              controller: TextEditingController(text: pattern.onePoint),
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              decoration: InputDecoration(labelText: 'ワンポイント'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                        border: Border(
                      top: BorderSide(
                        color: Colors.black12,
                        width: 0.5,
                      ),
                    )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RaisedButton(
                            color: Theme.of(context).primaryColor,
                            child: Text("キャンセル"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        RaisedButton(
                            color: Theme.of(context).primaryColor,
                            child: Text("OK"),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                // PatternEditor editor = PatternEditor(pattern, folder);
                                // editor.upsert();
                                pattern.upsert();

                                Navigator.of(context).pop();
                              }
                              print('OK');
                            }),
                      ],
                    ),
                  ),
                )
              ],
            )));
  }
}

class MyTextFormField extends StatelessWidget {
  // @override
  // State createState() {
  //   return super.createState();
  // }

  Widget build(BuildContext context) {
    return TextFormField(
      controller: TextEditingController(text: 'test1'),
    );
  }

// @override
// State<StatefulWidget> createState() {
//   throw UnimplementedError();
// }
}
