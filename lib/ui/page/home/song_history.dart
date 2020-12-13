import 'package:flutter/material.dart';

// class PageSongHistory extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Page SongHistory 0',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: SongHistoryHomePage(title: 'SongHistory Home 1'),
//     );
//   }
// }

class SongHistoryHomePage extends StatefulWidget {
  SongHistoryHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SongHistoryHomePageState createState() => _SongHistoryHomePageState();
}

class _SongHistoryHomePageState extends State<SongHistoryHomePage> {
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
                Text("課題曲")
              ])
            ])));
  }
}
