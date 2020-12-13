import 'package:flutter/material.dart';

// class PageTargetHistory extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Page TargetHistory 0',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: TargetHistoryHomePage(title: 'TargetHistory Home 1'),
//     );
//   }
// }

///
/// 現在の目標の履歴ページ
///
class TargetHistoryHomePage extends StatefulWidget {
  TargetHistoryHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TargetHistoryHomePageState createState() => _TargetHistoryHomePageState();
}

class _TargetHistoryHomePageState extends State<TargetHistoryHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
            margin: EdgeInsets.all(16.0),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                RaisedButton(
                  child: Text("Button 1"),
                  onPressed: () {},
                ),
                Text("現在の目標履歴")
              ])
            ])));
  }
}
