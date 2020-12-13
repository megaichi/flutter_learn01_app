import 'package:flutter/material.dart';
import 'package:lelele_proto1/ui/page/record/tab/calendar.dart';
import 'package:lelele_proto1/ui/page/record/tab/record_list.dart';
import 'package:lelele_proto1/ui/page/record/tab/statistics.dart';

///
/// PageRecord
///
class PageRecord extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Record Home 0',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RecordPage(title: 'Record'),
    );
  }
}

///
///
///
class RecordPage extends StatefulWidget {
  RecordPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RecordPageState createState() => _RecordPageState();
}

///
///
///
class _RecordPageState extends State<RecordPage> {
  // https://flutter.ctrnost.com/basic/navigation/tabbar/
  final _tab = <Tab>[
    Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [Icon(Icons.list, size: 20), Text("List")],
      ),
    ),
    Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [Icon(Icons.calendar_today, size: 20), Text("Calendar")],
      ),
    ),
    Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [Icon(Icons.assessment, size: 20), Text("Statistics")],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tab.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: AppBar(
//          toolbarHeight: kToolbarHeight * 0.8,
            leading: Icon(Icons.music_video),
            centerTitle: true,
            title: Text(widget.title),
            bottom: TabBar(
              tabs: _tab,
            ),
          ),
        ),
        // ToDo: iPhone 5s だと幅のエラーになる。余裕があればなおす
        body: TabBarView(children: <Widget>[
          PageRecordList(),
          PageRecordCalendar(),
          PageRecordStatictics(),

//          TabPage(title: 'Car', icon: Icons.directions_car),
//          TabPage(title: 'Bicycle', icon: Icons.directions_bike),
//          TabPage(title: 'Boat', icon: Icons.directions_boat),
        ]),
      ),
    );
  }
}
