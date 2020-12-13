import 'package:flutter/material.dart';

// class PageFooBar extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Page FooBar 0',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: FooBarHomePage(title: 'FooBar Home 1'),
//     );
//   }
// }

class FooBarHomePage extends StatefulWidget {
  FooBarHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FooBarHomePageState createState() => _FooBarHomePageState();
}

class _FooBarHomePageState extends State<FooBarHomePage> {
  var _label = '';

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
                  child: Text("showModalBottomSheet"),
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.share),
                              title: Text('Share'),
                              onTap: () {
                                setState(() => _label = 'You selected Share');
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.edit),
                              title: Text('Edit'),
                              onTap: () {
                                setState(() => _label = 'You selected Edit');
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.delete),
                              title: Text('Delete'),
                              onTap: () {
                                setState(() => _label = 'You selected Delete');
                                Navigator.pop(context);
                              },
                            )
                          ],
                        );
                      },
                    );
                  },
                ),
                Text(_label)
              ])
            ])));
  }
}
