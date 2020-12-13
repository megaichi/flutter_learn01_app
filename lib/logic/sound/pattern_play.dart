import 'package:lelele_proto1/logic/sound/pattern_play_listener.dart';
import 'package:lelele_proto1/logic/sound/metronome.dart';
import 'package:lelele_proto1/logic/sound/metronome_listener.dart';

///
/// Pattern Play Class
///
class PatternPlay implements MetronomeListener {
  //--------------------//
  // フィールド
  //--------------------//

  /// プレイモード
  PlayMode mode;

  /// カウントインの実行中の値
  int countInNow;

  /// 拍子の実行中の値
  int beatNow;

  /// 小節の実行中の値
  int measureNow;

  /// 練習の繰り返し中の値
  int repeatCountNow;

  /// 実行時間
  Duration duration;

  /// 定義されたパターン
  Pattern _pattern;

  /// パターンの現在の状態
//  Pattern patternCurrent;

  Metronome _metronome;

  ///
  /// パターンプレイリスナー
  /// UIに通知する
  PatternPlayListener _listener;

  //--------------------//
  // 初期化
  //--------------------//

  ///
  /// コンストラクタ パターンに応じて実行する
  ///
  PatternPlay(this._pattern, this._listener, {this.mode = PlayMode.Free}) {
    init();
  }

  init() {
    _metronome = Metronome(listener: this);
  }

  //--------------------//
  // 各イベントメソッド
  //--------------------//

  ///
  /// 練習の開始 UIから呼び出す
  ///
  start() {
    //_metronome.play();

    // UI側に伝える
    _listener.recorderStart()();
  }

  ///
  /// 練習のポーズ UIから呼び出す
  ///
  pause() {
    // メトロノーム、録音はは止める
  }

  ///
  /// ストップ 自動的に止まるのでプライベート
  ///
  stop() {
    // UI側に伝える
    _listener.recorderStop();
  }

  tick() {
    // UI側に伝える
    _listener.metronomeTick();
  }

  //--------------------//
  // Metronome Event
  //--------------------//

  @override
  metronomePlay() {
    // TODO: implement metronomePlay
    throw UnimplementedError();
  }

  @override
  metronomeStop() {
    // TODO: implement metronomeStop
    throw UnimplementedError();
  }

  @override
  metronomeTick() {
    tick();
  }
}

enum PlayMode {
  // 決まった時間を繰り返して練習するモード
  Free,

  // お手本局と一緒にやったり、ボーカルがピアノに合わせて練習するモード
  With,

  // メトロノームに合わせて練習するモード
  Metronome
}
