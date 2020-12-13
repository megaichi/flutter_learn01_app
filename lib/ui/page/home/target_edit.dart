import 'package:flutter/material.dart';
import 'package:lelele_proto1/logic/data/longterm.dart';

// class PageTargetEdit extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Page TargetEdit 0',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: TargetEditHomePage(title: 'TargetEdit Home 1'),
//     );
//   }
// }

///
/// 現在の目標の編集
///
class TargetEditHomePage extends StatefulWidget {
  TargetEditHomePage({Key key, this.title, this.longterm}) : super(key: key);

  final String title;
  final Longterm longterm;

  @override
  _TargetEditHomePageState createState() => _TargetEditHomePageState(longterm: longterm);
}

class _TargetEditHomePageState extends State<TargetEditHomePage> {
  _TargetEditHomePageState({this.longterm});

  ///
  final _formKey = GlobalKey<FormState>();
  final Longterm longterm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
            margin: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(children: [
                TextFormField(
                  onChanged: (text) {
                    longterm.target = text;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return '長期目標を入力してください';
                    }
                    return null;
                  },
                  controller: TextEditingController(text: longterm.target ?? ''),
                  decoration: InputDecoration(labelText: '長期目標'),
                ),
                // ToDo: 長期目標フォーム
                TextFormField(
//                  autofocus: true,
                  onChanged: (text) {
                    longterm.target = text;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return '開始日を入力してください';
                    }
                    return null;
                  },
                  controller: TextEditingController(text: longterm.target ?? ''),
                  decoration: InputDecoration(labelText: '開始日'),
                ),
                TextFormField(
                  onChanged: (text) {
                    longterm.target = text;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return '終了日を入力してください';
                    }
                    return null;
                  },
                  controller: TextEditingController(text: longterm.target ?? ''),
                  decoration: InputDecoration(labelText: '終了日'),
                ),
                TextFormField(
                  onChanged: (text) {
                    longterm.target = text;
                  },
                  controller: TextEditingController(text: longterm.target ?? ''),
                  decoration: InputDecoration(labelText: 'メモ'),
                ),
              ]),
            )));
  }
}
