import 'dart:async';
import 'dart:developer';
import 'dart:io' as io;

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:intl/intl.dart';
import 'package:lelele_proto1/assets/lelele_icon_map.dart';
import 'package:lelele_proto1/logic/define/lelele_constants.dart';
import 'package:lelele_proto1/lelelearn_app.dart';
import 'package:lelele_proto1/logic/data/learn.dart';
import 'package:lelele_proto1/logic/data/pattern.dart';
import 'package:lelele_proto1/logic/util/lelele_util.dart';
import 'package:lelele_proto1/logic/sound/metronome.dart';
import 'package:lelele_proto1/logic/sound/metronome_listener.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

///
/// 練習画面ページ.
///
class PageLearnPatternPlay extends StatelessWidget {
  final Pattern pattern;

  PageLearnPatternPlay({Key key, this.pattern}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log("PageLearn.build");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Page Home 0',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LearnPatternPlay(title: 'Learn Home 1', pattern: pattern),
    );
  }
}

///
///
///
class LearnPatternPlay extends StatefulWidget {
//  LearnPage({Key key, this.title, this.pattern}) : super(key: key)

  final String title;
  final Pattern pattern;
  final LocalFileSystem localFileSystem;

  LearnPatternPlay({this.title, this.pattern, localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  _LearnPatternPlayState createState() => _LearnPatternPlayState(pattern);
}

///
///
///
class _LearnPatternPlayState extends State<LearnPatternPlay> implements MetronomeListener {
  // Recorder
  FlutterAudioRecorder _audioRecorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;

//  Recorder recorder2;

  Metronome _metronome;

  Pattern _pattern;

  String _tempoText;

  int _measureNow = 0;

  AudioPlayer _audioPlayer = AudioPlayer();

  _LearnPatternPlayState(this._pattern) {
    _metronome = Metronome(listener: this);
  }

  ///
  ///
  ///
  @override
  void initState() {
    log('PageHome.initState');
//    _metronome.measureCount = 4;
    _recorderInit();

    setTempoText();

    _audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        _showSnackBar('再生終了');
      });
    });

    super.initState();
  }

  /// テンポテキストを設定
  void setTempoText() {
    String tempoPercent = (_pattern.tempoBase / _pattern.tempoGoal * 100).toStringAsFixed(1);
    _tempoText = "テンポ(T): ${_pattern.tempoBase} (〜${_pattern.goalTempo}) / ${_pattern.tempoGoal} ($tempoPercent%)";
  }

  ///
  final GlobalKey<ScaffoldState> scaffoldstate = new GlobalKey<ScaffoldState>();

  void _showSnackBar(String msg) {
    scaffoldstate.currentState
        .showSnackBar(new SnackBar(content: new Text(msg), duration: Duration(milliseconds: 600)));
  }

  TransformationController controller = TransformationController();
  String velocity = "VELOCITY";

  // ToDo: learn_pattern_edit.dartにも同じ処理があるので統一する
  // こちらの実装が最新、ファイルパスがnull, ファイルがない場合にPlaceholderを表示する
  ///
  /// スコアのイメージを取得する
  ///
  Widget _getScoreImage() {
    Widget widget = Placeholder();

    // ToDo: 謎のエラーが頻発するので一旦コメントアウト learn_pattern_edit.dartも
    // bool fileExists = false;
    //
    // if (_pattern.scoreFilePath != null) {
    //   Future<bool> futureFileExists = io.File(_pattern.scoreFilePath).exists();
    //   futureFileExists.then((value) => fileExists = value == null ? false : fileExists);
    // }
    //
    // if (_pattern.scoreFilePath != null && fileExists) {
    //   try {
    //     widget = InteractiveViewer(
    //       child: Image.asset(_pattern.scoreFilePath),
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

  /// 経過時間 Duration
  Duration elapsedTimeDuration = Duration();

  String elapsedTimeText = "00:00:00";

  @override
  Widget build(BuildContext context) {
    log("_LearnPageState.build");
//    recorder2 = Recorder(context, AudioFormat.WAV);

    return Scaffold(
        key: scaffoldstate,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(appBarHeight),
          child: AppBar(
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  // ToDo: AdMob 再表示
//                  LelelearnApp.admobBanner.show();
                  Navigator.of(context).pop();
                },
              ),
              centerTitle: true,
              title: Text(widget.title),
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.info_outline,
//                    color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {}),
              ]),
        ),
        body: Container(
            padding: EdgeInsets.all(8.0),
//            color: Colors.black12,
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              ToggleSwitch(
                minWidth: MediaQuery.of(context).size.width * 0.9,
                minHeight: 24,
                initialLabelIndex: 0,
                labels: ['Free', 'With', 'Metronome'],
                onToggle: (index) {
                  print('switched to: $index');
                },
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("予想練習時間: ${_pattern.practiceTime}", style: TextStyle(fontSize: 14)),
                Text("経過時間: $elapsedTimeText", style: TextStyle(fontSize: 14)),
              ]),
              Container(
//                margin: const EdgeInsets.all(2.0),
//                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      leleleInstrumentIconsMap[_pattern.folder.instrument],
                      size: 20,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _pattern.soundFileName,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 18,
                      ),
//                  style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.2),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.play_arrow,
                      color: Colors.blue,
                      size: 24,
                    ),
                    onPressed: () {
                      _showSnackBar("Play Model");
                    },
                  ),
                ]),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("CountIn(CI): 0 / 1", style: TextStyle(fontSize: 14)),
                Text("小節(M): $_measureNow / ${_pattern.measureCount}", style: TextStyle(fontSize: 14)),
              ]),
              Container(
                width: MediaQuery.of(context).size.width * 0.96,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white30,
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(5),
                ),
//                    child: Center(child: Text("メトローノーム")),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: _createMetronomeDot()),
              ),
              Expanded(
                  child: new SingleChildScrollView(
                      child: Column(children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Tooltip(
                        message: "練習テンポ / 目標テンポ",

// xxxxxxxx
//                          child: Text("テンポ(T): " + pattern.tempoBase.toString() + "(〜116) / 120 (90%)",
                        child: Text(_tempoText, style: TextStyle(fontSize: 14))),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(0.0),
                          width: 30.0,
                          child: IconButton(
                            icon: Icon(
                              Icons.remove_circle_outline,
                              color: Colors.blue.shade400,
//                          size: 30,
                            ),
                            onPressed: () {
                              setState(() {
                                _pattern.tempoBase--;
                                setTempoText();
                              });
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(0.0),
                          width: 30.0,
                          child: IconButton(
                            icon: Icon(
                              Icons.control_point,
                              color: Colors.blue.shade400,
//                          size: 30,
                            ),
                            onPressed: () {
                              setState(() {
                                _pattern.tempoBase++;
                                setTempoText();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text("テンポアップ(TU): TB=${_pattern.tempoupBpm}/TC=${_pattern.tempoupCount}",
                      style: TextStyle(fontSize: 14)),
                  Switch(
                    activeColor: Colors.blue,
                    value: _pattern.tempoupFlg,
                    onChanged: (bool newValue) {
                      setState(() {
                        _pattern.tempoupFlg = newValue;
                        setTempoText();
                      });
                    },
                  )
                ]),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 0.75,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(5),
                    ),
//                      child: Center(child: Text("譜面表示")),
//                  child: Center(child: Image.asset("assets/images/altanate_guitar.gif")),
                    child: Center(child: _getScoreImage()
                        //   child: PhotoView(
                        // imageProvider: AssetImage("assets/images/altanate_guitar.gif"),
                        // child: InteractiveViewer(
                        //   child: Image.asset(_pattern.scoreFilePath),
                        //   transformationController: controller,
                        //   boundaryMargin: EdgeInsets.all(5.0),
                        //   onInteractionEnd: (ScaleEndDetails endDetails) {
                        //     print(endDetails);
                        //     print(endDetails.velocity);
                        //     controller.value = Matrix4.identity();
                        //     setState(() {
                        //       velocity = endDetails.velocity.toString();
                        //     });
                        //   },
                        // ),
                        )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("合計練習回数: 0", style: TextStyle(fontSize: 14)),
                    Text("合計練習時間: 00:00:00", style: TextStyle(fontSize: 14)),
                  ],
                ),
              ]))),
              // TextField(
              //   controller: _controller,
              //   decoration: new InputDecoration(
              //     hintText: 'Enter a custom path',
              //   ),
              // ),
              Container(
                margin: const EdgeInsets.all(2.0),
//                height: 40 + adMobAnchorOffset,
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//                Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
//                      "${_metronome.measureCount}/${_metronome.measureCount}",
                      "${_pattern.repeatCountNow}/${_pattern.repeatCount}",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.fiber_manual_record,
                      color: Colors.red,
                    ),
                    onPressed: () {},
                  ),
                  ButtonTheme(
                      minWidth: 160.0,
//                      height: 40.0,
                      height: 40.0,
                      child: RaisedButton(
                        child: Text("Let's Learn"),
                        color: Colors.deepOrangeAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        onPressed: () {
                          _learnStart();
                        },
                      )),
                  Container(
                      child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.pause),
                        onPressed: () {
                          // _recStop;
                          _metronome.stop();
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.play_arrow,
//                          color: Colors.blue,
//                              size: 36,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  )),
                ]),
              ),
            ])));
  }

  /// メトロノームの点を表すコンテナ
  List<Container> _metronomeDotList = List<Container>();

  // メトロノームのドットのカラー
  List<Color> _metronomeDotColorList = List<Color>();

  ///
  /// メトロノームの点を返す.
  /// initState で実行するとMediaQueryの取得でエラーになる
  ///
  List<Container> _createMetronomeDot() {
    print("pattern: $_pattern");

    _metronomeDotList.clear();

    int count = _pattern.beat == null ? 4 : _pattern.beat;

    // 点の幅を計算する
    double width = (MediaQuery.of(context).size.width - MediaQuery.of(context).size.width * 0.3) / count;

    // コンテナをリストに追加する
    for (int i = 0; i < count; i++) {
      _metronomeDotColorList.add(Colors.black12);
      _metronomeDotList.add(Container(
//        width: MediaQuery.of(context).size.width * 0.15,
        width: width,
        margin: const EdgeInsets.all(2.0),
        padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
//          color: Colors.black12,
          color: _metronomeDotColorList[i],
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(5),
        ),
      ));
    }

    return _metronomeDotList;

//    return metronomeDot;
  }

  DateTime recordStartTs;
  DateTime recordEndTs;

  int repeatCurrent = 0;

  void _learnStart() {
//    _showSnackBar("練習開始！");
    LeleleUtil.autoHideDialog(context, Duration(milliseconds: 1500), "練習開始！");
    // _recStart();

    recordStartTs = DateTime.now();

//    Future<String> recordingPath = getRedcordingPath();
//    _recorderInit(recordingPath);
    _recorderStart();

    _metronome.measureCount = _pattern.measureCount;
    _metronome.beat.molecule = _pattern.beat;
    _metronome.play();
  }

//   Future<String> getRedcordingPath() async {
//     String customPath = '/lelele_';
//
//     io.Directory appDocDirectory;
//     if (io.Platform.isIOS) {
//       appDocDirectory = await getApplicationDocumentsDirectory();
//     } else {
//       appDocDirectory = await getExternalStorageDirectory();
//     }
//
//     var formatter = new DateFormat('yyyyMMdd_HHmmss');
//     var formatted = formatter.format(recordStartTs); // DateからString
//
// //    print("★☆★☆★☆ formatted: $formatted");
//
//     customPath = appDocDirectory.path + customPath + formatted;
//
//     print("appDocDirectory: $appDocDirectory");
//     print("customPath: $customPath");
//
//     return customPath;
//   }

  /////////////////////////
  // Audio Recorder Method

  String _audioRecorderFilePath = '/lelele_';
  String _audioRecorderFileName = '';

  _recorderInit() async {
    print("_recorderInit");
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
//        String customPath = '/flutter_audio_recorder_';

        io.Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        recordStartTs = DateTime.now();

        var formatter = new DateFormat('yyyyMMdd_HHmmss');
//        var formatted = formatter.format(DateTime.now()); // DateからString
        _audioRecorderFileName = formatter.format(recordStartTs); // DateからString

        print("★☆★☆★☆ formatted: $_audioRecorderFileName");

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
//        customPath = appDocDirectory.path + customPath + DateTime.now().millisecondsSinceEpoch.toString();
        _audioRecorderFilePath = appDocDirectory.path + _audioRecorderFilePath + _audioRecorderFileName;

        print("appDocDirectory: $appDocDirectory");
        print("_audioRecorderFilePath: $_audioRecorderFilePath");

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
//        _recorder = FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);
        _audioRecorder = FlutterAudioRecorder(_audioRecorderFilePath, audioFormat: AudioFormat.AAC);

        await _audioRecorder.initialized;
        // after initialization
        var current = await _audioRecorder.current(channel: 0);
        print(current);
        // should be "Initialized", if all working fine
        setState(() {
          _current = current;
          _currentStatus = current.status;
          print(_currentStatus);
        });
      } else {
        Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  ///
  ///
  ///
  _recorderStart() async {
    print("_recorderStart");

    try {
      await _audioRecorder.start();
      var recording = await _audioRecorder.current(channel: 0);
      setState(() {
        _current = recording;
      });

      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _audioRecorder.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current.status;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  _recorderResume() async {
    print("_recorderResume");
    await _audioRecorder.resume();
    setState(() {});
  }

  _recorderPause() async {
    print("_recorderPause");
    await _audioRecorder.pause();
    setState(() {});
  }

  var _recorderResult;

  _recorderStop() async {
    print("_recorderStop");
    recordEndTs = DateTime.now();

//    var result = await _recorder.stop();
    if (_audioRecorder != null) {
      _recorderResult = await _audioRecorder.stop();
    }

    // print("Stop recording: Path=${result.path}. Duration=${result.duration}");
    // File file = widget.localFileSystem.file(result.path);
    print("Stop recording: Path=${_recorderResult.path}. Duration=${_recorderResult.duration}");
    File file = widget.localFileSystem.file(_recorderResult.path);

    print("File length: ${await file.length()}");
    setState(() {
//      _current = result;
      _current = _recorderResult;
      _currentStatus = _current.status;
    });

//    print("RECORDER STOP");

//    _fireStoreLearnRecordAdd();

    // ToDo: 練習記録を保存する 2回目がエラーになる
    //
    Learn learn = Learn(filePath: _audioRecorderFilePath, fileName: _audioRecorderFileName + ".m4a");
    learn.add();

    _recordPlayback(_recorderResult.path);

    _recorderInit();
  }

  _recordPlayback(String filePath) async {
    print("filePath: $filePath");
    _showSnackBar('再生を開始します');

    int result = await _audioPlayer.play(filePath, isLocal: true);
    if (result == 1) {
      print("result: $result");
    }
    print("result: $result");
  }

  //==================
  // METRONOME LOGIC
  //==================

  @override
  metronomePlay() async {
//    throw UnimplementedError();
    print("METRONOME PLAY");
  }

  @override
  metronomeStop() async {
//    throw UnimplementedError();
    print("METRONOME STOP");

    _recorderStop();

    await new Future.delayed(new Duration(seconds: 1));

    /// ドットの色を戻す
    setState(() {
      _measureNow = _metronome.measureNow;

      // ドットをグレイに戻す
      for (int index = 0; index < _metronomeDotList.length; index++) {
        _metronomeDotColorList[index] = Colors.black12;
      }
    });
  }

  @override
  metronomeTick() {
//    throw UnimplementedError();

    setState(() {
      _measureNow = _metronome.measureNow;

      for (int index = 0; index < _metronomeDotList.length; index++) {
        if (index == _metronome.beatNow - 1) {
          _metronomeDotColorList[index] = Colors.deepOrangeAccent;
        } else {
          _metronomeDotColorList[index] = Colors.black12;
        }
      }
    });

    print("METRONOME TICK");
  }

//////////////////////////

  ///
  /// Firestore のパターンフォルダを作成する
  ///
  @deprecated
  _fireStoreLearnRecordAdd() {
    Map<String, dynamic> data = <String, dynamic>{'name': "_folderName", 'color': Colors.lime.value, 'instrument': 100};

    Future<DocumentReference> ref = FirebaseFirestore.instance
        .collection(FS_COLLECTION_USERS)
        .doc(LelelearnApp.firebaseUser.uid)
        .collection('items')
        .doc('learn')
        .collection('folders')
        .add(data);

    print("_fireStorePatternFolderCreate ref: $ref");
  }
}
