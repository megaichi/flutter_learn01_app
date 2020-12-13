import 'package:flutter/material.dart';
import 'package:lelele_proto1/logic/define/lelele_constants.dart';
import 'package:lelele_proto1/logic/define/lelele_enum.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class PageOtherSetting extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Page OtherSetting 0',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: OtherSettingHomePage(title: 'Settings'),
//     );
//   }
// }

class OtherSettingHomePage extends StatefulWidget {
  OtherSettingHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _OtherSettingHomePageState createState() => _OtherSettingHomePageState();
}

class _OtherSettingHomePageState extends State<OtherSettingHomePage> {
//--------------------------------------------------------------------------------------------------------------------//
// https://qiita.com/yukiyamadajp/items/16ec45a7d5de947a93e3
//  int _counter = 0;

  bool _switch1 = false;

  // void _incrementCounter(bool value) async {
  void _changeSwitch1(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
//      _counter = (prefs.getInt('counter') ?? 0) + 1;
      // _switch1 = (prefs.getInt('switch1') ?? false);
      _switch1 = value;
    });

//    await prefs.setInt('counter', _counter);
    await prefs.setBool('switch1', _switch1);
  }

  // Future<int> _getPrefCount() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return (prefs.getInt('counter') ?? 0);
  // }

  Future<bool> _getPrefSwitch1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getBool('switch1') ?? false);
  }

//--------------------------------------------------------------------------------------------------------------------//

  // Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // Future<bool> _switch2;

  @override
  void initState() {
    // _switch2 = _prefs.then((SharedPreferences prefs) {
    //   return (prefs.getBool('switch1') ?? false);
    // });

    _getAllSharedPreferenceValue().then((value) => null);

    _getPrefSwitch1().then((value) {
      setState(() {
        _switch1 = value;
      });
    });

    super.initState();
  }

  ///
  /// Shared Preference の値をすべて出力
  ///
  Future<void> _getAllSharedPreferenceValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs.getKeys();
    print("★★★ Shared Preferene ★★★");
    keys.forEach((element) => print("$element: ${prefs.get(element)}"));
    print("☆☆☆ Shared Preferene ☆☆☆");
  }

  ///
  /// SnackBar
  ///
  final GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();

  void _showSnackBar(String msg) {
    scaffoldState.currentState
        .showSnackBar(new SnackBar(content: new Text(msg), duration: Duration(milliseconds: 600)));
  }

  ///
  /// すべてのデータ削除
  ///
  _allDataReset() async {
    var value = await showDialog(
      context: context,
      builder: (BuildContext context) => new AlertDialog(
        title: new Text('Folder Delete'),
        content: new Text('すべてのデータを削除しますか？ この操作は取り消せません', softWrap: true),
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
        _showSnackBar('データを削除しました。(未実装)');
        break;
      case Answers.NO:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldState,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(appBarHeight),
          child: AppBar(
            centerTitle: true,
            title: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.settings),
                SizedBox(
                  width: 50,
                ),
                Text(widget.title),
              ],
            ),
          ),
        ),
        body: Container(
            margin: EdgeInsets.all(16.0),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                RaisedButton(
                  child: Text("Button 1"),
                  onPressed: () {},
                ),
                Text("setting")
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                // RaisedButton(
                //   child: Text("Switch"),
                //   onPressed: () {},
                // ),
                Switch(
                  value: _switch1 ?? false,
                  onChanged: (value) {
                    _changeSwitch1(value);
                  },
                )
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                RaisedButton(
                  color: Colors.red,
                  child: Text(
                    "全データ削除",
                    style: TextStyle(color: Colors.yellow),
                  ),
                  onPressed: () => _allDataReset,
                ),
              ])
            ])));
  }
}
