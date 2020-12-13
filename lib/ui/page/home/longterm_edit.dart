import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lelele_proto1/logic/data/longterm.dart';
import 'package:lelele_proto1/logic/define/lelele_constants.dart';

// class PageFutureEdit extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Page FutureEdit 0',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: FutureEditHomePage(title: 'FutureEdit Home 1'),
//     );
//   }
// }

///
/// 長期目標の編集
///
class LongtermEditHomePage extends StatefulWidget {
  LongtermEditHomePage({Key key, this.title, this.longterm}) : super(key: key);

  final String title;
  final Longterm longterm;

  @override
  _LongtermEditHomePageState createState() => _LongtermEditHomePageState(longterm);
}

class _LongtermEditHomePageState extends State<LongtermEditHomePage> {
  final _formKey = GlobalKey<FormState>();

  // 長期目標
  final Longterm longterm;

  _LongtermEditHomePageState(this.longterm);

  DateTime _selectedDate;
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(appBarHeight),
          child: AppBar(
            title: Text(widget.title),
          ),
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
                  focusNode: AlwaysDisabledFocusNode(),
//                  controller: TextEditingController(text: longterm.target ?? ''),
                  controller: _textEditingController,
                  onChanged: (text) {
                    longterm.target = text;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return '終了日を入力してください';
                    }
                    return null;
                  },
                  onTap: () {
                    _selectDate(context);
                  },
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

  _selectDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
      // builder: (BuildContext context, Widget child) {
      //   return Theme(
      //     data: ThemeData.light().copyWith(
      //       colorScheme: ColorScheme.light(
      //         primary: Colors.deepPurple,
      //         onPrimary: Colors.white,
      //         surface: Colors.blueGrey,
      //         onSurface: Colors.yellow,
      //       ),
      //       dialogBackgroundColor: Colors.blue[500],
      //     ),
      //     child: child,
      //   );
      // }
    );

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      _textEditingController
        ..text = DateFormat.yMMMd().format(_selectedDate)
        ..selection = TextSelection.fromPosition(
            TextPosition(offset: _textEditingController.text.length, affinity: TextAffinity.upstream));
    }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
