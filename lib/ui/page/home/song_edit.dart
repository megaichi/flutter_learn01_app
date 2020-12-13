import 'package:flutter/material.dart';

// class PageSongEdit extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Page SongEdit 0',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: SongEditHomePage(title: 'SongEdit Home 1'),
//     );
//   }
// }

///
/// 現在の目標の編集
///
class SongEditHomePage extends StatefulWidget {
  SongEditHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SongEditHomePageState createState() => _SongEditHomePageState();
}

class _SongEditHomePageState extends State<SongEditHomePage> {
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
                Text("目標編集")
              ])
            ])));
  }
}
