import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'dart:io' as io;
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:path_provider/path_provider.dart';

///
/// サウンドレコーダークラス
///
class SoundRecorder {
  AudioFormat audioFormat = AudioFormat.WAV;

//  Widget _widget;

  final LocalFileSystem localFileSystem = LocalFileSystem();

  /// FlutterAudioRecorder
  FlutterAudioRecorder _recorder;

  /// FlutterAudioRecorder Recording
//  Recording _current;
  Recording current;

  /// FlutterAudioRecorder RecordingStatus
//  RecordingStatus _currentStatus = RecordingStatus.Unset;
  RecordingStatus currentStatus = RecordingStatus.Unset;

  /// BuildContext
  BuildContext _context;

  /// Constructor
  SoundRecorder(this._context, this.audioFormat);

  init() async {
    // try {
    if (await FlutterAudioRecorder.hasPermissions) {
      String customPath = '/flutter_audio_recorder_';
      io.Directory appDocDirectory;
      if (io.Platform.isIOS) {
        appDocDirectory = await getApplicationDocumentsDirectory();
      } else {
        appDocDirectory = await getExternalStorageDirectory();
      }

      // can add extension like ".mp4" ".wav" ".m4a" ".aac"
      customPath = appDocDirectory.path + customPath + DateTime.now().millisecondsSinceEpoch.toString();

      // .wav <---> AudioFormat.WAV
      // .mp4 .m4a .aac <---> AudioFormat.AAC
      // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
//        _recorder = FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);
      _recorder = FlutterAudioRecorder(customPath, audioFormat: this.audioFormat);

      await _recorder.initialized;
      // after initialization
      current = await _recorder.current(channel: 0);
      print(current);
      // should be "Initialized", if all working fine
//        setState(() {
//          _current = current;
//          _currentStatus = current.status;
//          print(_currentStatus);
      currentStatus = current.status;
      print("Recorder.currentStatus: $currentStatus");

//        });
    } else {
      Scaffold.of(_context).showSnackBar(new SnackBar(content: new Text("You must accept permissions")));
    }
    // } catch (e) {
    //   print(e);
    // }
  }

  ///
  ///
  ///
  start() async {
    // try {
    await _recorder.start();
    var recording = await _recorder.current(channel: 0);
//      setState(() {
//        _current = recording;
    current = recording;
//      });

    const tick = const Duration(milliseconds: 50);
    new Timer.periodic(tick, (Timer t) async {
//        if (_currentStatus == RecordingStatus.Stopped) {
      if (currentStatus == RecordingStatus.Stopped) {
        t.cancel();
      }

//        var current = await _recorder.current(channel: 0);
      current = await _recorder.current(channel: 0);
      // print(current.status);
//        setState(() {
//           _current = current;
//           _currentStatus = _current.status;
      currentStatus = current.status;

//        });
    });
    // } catch (e) {
    //   print(e);
    // }
  }

  ///
  ///
  ///
  resume() async {
    await _recorder.resume();
//    setState(() {});
  }

  ///
  ///
  ///
  recorderPause() async {
    await _recorder.pause();
//    setState(() {});
  }

  ///
  ///
  ///
  stop() async {
//    var result = await _recorder.stop();
    current = await _recorder.stop();
    // print("Stop recording: ${result.path}");
    // print("Stop recording: ${result.duration}");
    print("Stop recording: ${current.path}");
    print("Stop recording: ${current.duration}");

//    File file = _widget.localFileSystem.file(result.path);
//    File file = localFileSystem.file(result.path);
    File file = localFileSystem.file(current.path);
    print("File length: ${await file.length()}");
//    setState(() {
//    _current = result;
//    _currentStatus = _current.status;
    currentStatus = current.status;
//    });
  }
}
