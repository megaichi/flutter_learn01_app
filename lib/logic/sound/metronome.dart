import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lelele_proto1/logic/sound/metronome_listener.dart';

// ToDo: 音声パラメータの外部化

///
/// Metronome Class.
///
class Metronome {
  //-----------------------------------
  //  Static
  //-----------------------------------

  /// Sound Play
  static AudioCache _player = AudioCache(prefix: 'assets/audio/');

  // Todo: カウントイン用メトロノーム音、要変更

  // https://freesound.org/

  /// カウントイン用 1拍目の音
  String countinUpbeatSound;

  /// カウントイン用 1拍目以外の音
  String countinDownbeatSound;

  /// 1拍目用の音
  String downbeatSound;

  /// 1拍目以外の音
  String upbeatSound;

  //-----------------------------------
  //  Public Member
  //-----------------------------------

  /// カウントインあり
  bool isCountIn = false;

  /// カウントイン小節数
  int countInCount = 1;

  /// カウントインの現在位置
  int countInNow = 1;

  /// 再生する小節数
  int measureCount = 4;

  /// 小節の現在位置
  int measureNow = 1;

  /// 拍子
  Beat beat = Beat();

  /// 拍子の現在位置
  int beatNow = 1;

  /// 繰り返し
  bool repeat = false;

  // -----------
  // Getter Setter あり
  // -----------

  /// テンポ (Bit Per Minute)
  double _bpm;

  double get bpm => _bpm;
  set bpm(double b) {
    _bpm = b;

    int interval = 60000.0 ~/ this._bpm;
    print("interval: $interval");
    _duration = Duration(milliseconds: interval);
  }

  /// Timer
  Timer _timer;

  /// Beat Duration
  Duration _duration;

  MetronomeListener listener;

  ///
  /// Constructor
  ///
  Metronome({this.listener,
    this.countinDownbeatSound = 'ciu_319917_theriavirra_drumsticks-lutner-woodtip-7b-hickory-no5.m4a',
    this.countinUpbeatSound = 'cid_54406_korgms2000b_metronome-click.m4a',
    this.upbeatSound = '250551_druminfected_metronomeup.m4a',
    this.downbeatSound = '250552_druminfected_metronome.m4a'}
  ) {
    debugPrint("Metronome: $beat");

    this.bpm = 120;
    _player.loadAll([downbeatSound, upbeatSound]);
  }

  //-----------------------------------
  //  Public Method
  //-----------------------------------

  ///
  ///
  ///
  void play() {
    print("Metronome.play Beat=$beat");
    print("BPM=$bpm");
    listener.metronomePlay();
    beatNow = 1;
    measureNow = 1;

    _timer = Timer.periodic(
      _duration,
      _onTimer,
    );
  }

  ///
  ///
  ///
  void stop() {
    print("Metronome.stop");
    listener.metronomeStop();

    if (_timer.isActive) {
      _timer.cancel();
    }
  }

  //-----------------------------------
  //  Private Method
  //-----------------------------------

  ///
  /// タイマー
  ///
  _onTimer(Timer timer) {
    print("Beat: $beat, measureNow/measureCount: $measureNow/$measureCount, beatNow: $beatNow");
    print("measureCount/measureNow : $measureNow/$measureCount");
    listener.metronomeTick();

    // 繰り返しがfalseなら、設定した小節数分再生したら停止
    if (!repeat && measureCount == measureNow && beat.molecule == beatNow) {
      stop();
      print("Metronome: Auto Stop");
    }

    // 1泊目は強拍の音
    if (beatNow == 1) {
      _player.play(downbeatSound);
    } else {
      _player.play(upbeatSound);
    }

    // 拍子位置が、拍子の分子と同じになったら1に戻して小節数を増やす
    // 4/4 なら 4/? の measure 1 beat 1,2,3,4... measure2 beat 1,2,3,4...
    if (beatNow == beat.molecule) {
      beatNow = 1;
      measureNow++;
    } else {
      beatNow++;
    }
  }
}

//
// ビートクラス テンポの拍子を表す
// 2/4の2 → 分子: molecule
// 2/4の4 → 分母: denominator
//
class Beat {
  /// 拍子の分母
  int denominator;

  /// 拍子の分子
  int molecule;

  Beat({this.molecule = 4, this.denominator = 4});

  ///
  /// toStringオーバーライド
  ///
  @override
  String toString() {
    return super.toString() + "$molecule/$denominator";
  }
}
