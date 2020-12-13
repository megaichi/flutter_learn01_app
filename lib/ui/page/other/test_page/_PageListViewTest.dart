import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lelele_proto1/ui/page/other/test_page/_foo_bar.dart';

// class PageListViewTest extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Page ListViewTest 0',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: ListViewTestHomePage(title: 'ListViewTest Home 1'),
//     );
//   }
// }

class ListViewTestHomePage extends StatefulWidget {
  ListViewTestHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ListViewTestHomePageState createState() => _ListViewTestHomePageState();
}

class _ListViewTestHomePageState extends State<ListViewTestHomePage> {
  int i = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
            margin: EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Container(
                  height: 80,
                  child: Card(
                    child: Text('aaaa'),
                  ),
                ),
                Container(
                  height: 80,
                  child: Card(
                    child: Text('aaaa'),
                  ),
                ),
                Container(
                  height: 80,
                  child: Card(
                    child: Text('aaaa'),
                  ),
                ),
                Container(
                  height: 80,
                  child: Card(
                    child: Text('aaaa'),
                  ),
                ),
                Container(
                  height: 80,
                  child: Card(
                    child: Text('aaaa'),
                  ),
                ),
                Container(
                  height: 80,
                  child: Card(
                    child: Text('aaaa'),
                  ),
                ),
                Container(
                  height: 80,
                  child: Card(
                    child: Text('aaaa'),
                  ),
                ),
                Container(
                  height: 80,
                  child: Card(
                    child: Text('aaaa'),
                  ),
                ),
                Container(
                  height: 80,
                  child: Card(
                    child: Text('aaaa'),
                  ),
                ),
                Container(
                  height: 80,
                  child: Card(
                    child: Text('aaaa'),
                  ),
                ),
                Container(
                  child: FlatButton(
                    child: Text("Button1"),
                    onPressed: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) {
                            return FooBarHomePage(title: 'Foo Bar');
                          },
                        ),
                      );
                    },
                  ),
                )
              ],
            )));
  }
}
