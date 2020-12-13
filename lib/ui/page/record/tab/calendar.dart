import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:lelele_proto1/assets/lelele_icon.dart';
import 'package:lelele_proto1/logic/util/lelele_util.dart';
import 'package:table_calendar/table_calendar.dart';

///
/// PageRecordCalendar
///
class PageRecordCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    log("PageRecordCalendar.build");

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Page RecordCalendar 0',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RecordCalendarPage(title: 'RecordCalendar'),
    );
  }
}

///
///
///
class RecordCalendarPage extends StatefulWidget {
  RecordCalendarPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RecordCalendarPageState createState() => _RecordCalendarPageState();
}

///
///
///
class _RecordCalendarPageState extends State<RecordCalendarPage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldstate = new GlobalKey<ScaffoldState>();

  //  var _calendarController = CalendarController();

  Map<DateTime, List> _events;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  // 選択した日
  DateTime _selectedDay;

//  void _showSnackBar(String msg) {
//    scaffoldstate.currentState
//        .showSnackBar(new SnackBar(content: new Text(msg), duration: Duration(milliseconds: 600)));
//  }

  ///
  ///
  ///
  @override
  void initState() {
    log('PageRecordCalendar.initState');
    super.initState();
    _calendarController = CalendarController();

//    final _selectedDay = DateTime.now();
    _selectedDay = DateTime.now();

    _events = {
//      _selectedDay.subtract(Duration(days: 30)): ['Event A0', 'Event B0', 'Event C0'],
//      _selectedDay.subtract(Duration(days: 27)): ['Event A1'],
//      _selectedDay.subtract(Duration(days: 20)): ['Event A2', 'Event B2', 'Event C2', 'Event D2'],
//      _selectedDay.subtract(Duration(days: 16)): ['Event A3', 'Event B3'],
//      _selectedDay.subtract(Duration(days: 10)): ['Event A4', 'Event B4', 'Event C4'],
//      _selectedDay.subtract(Duration(days: 4)): ['Event A5', 'Event B5', 'Event C5'],
      _selectedDay.subtract(Duration(days: 2)): ['基本ストローク', '基本ストローク'],
      _selectedDay: ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
      _selectedDay.add(Duration(days: 1)): [
        'クロマチック01',
        'クロマチック01',
        'クロマチック01',
        'クロマチック01',
        'クロマチック01',
        'クロマチック01',
        'クロマチック01',
        'クロマチック01',
        'クロマチック01',
        'クロマチック01',
        'クロマチック01'
      ],
//      _selectedDay.add(Duration(days: 3)): Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
//      _selectedDay.add(Duration(days: 7)): ['Event A10', 'Event B10', 'Event C10'],
//      _selectedDay.add(Duration(days: 11)): ['Event A11', 'Event B11'],
//      _selectedDay.add(Duration(days: 17)): ['Event A12', 'Event B12', 'Event C12', 'Event D12'],
//      _selectedDay.add(Duration(days: 22)): ['Event A13', 'Event B13'],
//      _selectedDay.add(Duration(days: 26)): ['Event A14', 'Event B14', 'Event C14'],
    };
//
    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      // with TickerProviderStateMixin が必要
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();

    _selectedDay = DateTime.now();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    log("_RecordCalendarPageState.build");

    // カレンダー用にシステムロケール設定
    // Intl.systemLocale を呼ぶだけでは自動的に設定されないため
    // https://api.flutter.dev/flutter/intl/Intl/systemLocale.html
    Future<String> locale = findSystemLocale();
    print("Intl.systemLocale: ${Intl.systemLocale}");

    return Scaffold(
      key: scaffoldstate,
//        appBar: AppBar(
//          toolbarHeight: kToolbarHeight * 0.8,
//          leading: Icon(Icons.more_horiz),
//          title: Text(widget.title),
//          actions: [
////            IconButton(
////              icon: Icon(Icons.favorite_border),
////              onPressed: () => setState(() {
////                _createNew();
////              }),
////            ),
//          ],
//        ),
      body: Container(
        padding: EdgeInsets.all(2.0),
        child: Column(
          children: [
            Container(
                margin: const EdgeInsets.all(2.0),
                width: MediaQuery.of(context).size.width * 0.92,
//            height: 600,
                child: TableCalendar(
                  // ToDo: カレンダーロケール設定
                  // https://jg-ravity.com/?p=828
                  locale: Intl.systemLocale,
//              locale: 'ja_JP',
                  calendarController: _calendarController,
                  events: _events,
                  headerStyle: HeaderStyle(
                    centerHeaderTitle: false,
                    formatButtonVisible: true, // 月、2週、週の表示切り替え
                  ),
                  calendarStyle: CalendarStyle(
                    selectedColor: Colors.deepOrange[400],
                    todayColor: Colors.deepOrange[200],
                    markersColor: Colors.brown[700],
                    outsideDaysVisible: false,
                  ),
                  builders: CalendarBuilders(
                    selectedDayBuilder: (context, date, _) {
                      return FadeTransition(
                        opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
                        child: Container(
                          margin: const EdgeInsets.all(4.0),
                          padding: const EdgeInsets.only(top: 5.0, left: 6.0),

// 選択日の色
//              color: Colors.deepOrange[300],
                          color: Colors.greenAccent,
                          width: 80,
                          height: 40,
                          child: Text(
                            '${date.day}',
                            style: TextStyle().copyWith(fontSize: 16.0),
                          ),
                        ),
                      );
                    },
                    todayDayBuilder: (context, date, _) {
                      return Container(
                        margin: const EdgeInsets.all(4.0),
                        padding: const EdgeInsets.only(top: 5.0, left: 6.0),
// 今日の色
                        color: Colors.amber[400],
                        width: 80,
                        height: 40,
                        child: Text(
                          '${date.day}',
                          style: TextStyle().copyWith(fontSize: 16.0),
                        ),
//             decoration: BoxDecoration(
// //              border: Border.all(color: Colors.blue),
//               borderRadius: BorderRadius.all(Radius.circular(6)),
//             ),
                      );
                    },
                    markersBuilder: (context, date, events, holidays) {
                      final children = <Widget>[];

                      if (events.isNotEmpty) {
                        children.add(
                          Positioned(
                            right: 1,
                            bottom: 1,
                            child: _buildEventsMarker(date, events),
                          ),
                        );
                      }

                      if (holidays.isNotEmpty) {
                        children.add(
                          Positioned(
                            right: -2,
                            top: -2,
                            child: _buildHolidaysMarker(),
                          ),
                        );
                      }

                      return children;
                    },
                  ),
                  onDaySelected: (date, events, holidays) {
                    _onDaySelected(date, events: events, holidays: holidays);
                    _animationController.forward(from: 0.0);
                  },
                )),
//            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(LeleleUtil.dateTimeToDateString(_selectedDay)),
                Text('練習時間: 12:34:56'),
                TextButton(
                  child: const Text('今日'),
//                  style: OutlinedButton.styleFrom(primary: Colors.black),
                  onPressed: () {
                    setState(() {
                      var today = DateTime.now();
                      _calendarController.setSelectedDay(today);
                      _selectedDay = today;
                      // ToDo: 今日 ボタンを押したときにレコードを表示したいがエラーになる
//                      _onDaySelected(_selectedDay, events: _events[today]);
                    });
                  },
                ),
              ],
            ),
            Expanded(child: _buildEventList()),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
// イベント数のシェイプ
//        shape: BoxShape.rectangle,
        shape: BoxShape.circle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date)
                ? Colors.brown[300]
                : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  Widget _buildEventList() {
    return Container(
//      color: Colors.yellow,
      child: ListView(
        padding: const EdgeInsets.all(2.0),
        children: _selectedEvents
            .map((event) =>
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.8),
                borderRadius: BorderRadius.circular(8.0),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
              child: ListTile(
                leading: Icon(LeleleIcon.guitar),
                title: Text(
                  event.toString(),
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 14),
                ),
                subtitle: Text('13:20:55'),
                trailing: IconButton(
                  icon: Icon(Icons.play_arrow),
                      onPressed: () {},
                    ),
                    onTap: () => print('$event tapped!'),
                  ),
                ))
            .toList(),
      ),
    );
  }

  void _onDaySelected(DateTime day, {List events, List holidays}) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedDay = day;
      _selectedEvents = events;
    });
  }
}
