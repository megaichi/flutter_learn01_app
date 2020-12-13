import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lelele_proto1/logic/define/lelele_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

// class PageOtherHelp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Page OtherHelp 0',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: OtherHelpHomePage(title: 'LeLeLearn Help'),
//     );
//   }
// }

class OtherHelpHomePage extends StatefulWidget {
  OtherHelpHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _OtherHelpHomePageState createState() => _OtherHelpHomePageState();
}

///
///
///
class _OtherHelpHomePageState extends State<OtherHelpHomePage> {
  final GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();

  void _showSnackBar(String msg) {
    scaffoldState.currentState
        .showSnackBar(new SnackBar(content: new Text(msg), duration: Duration(milliseconds: 600)));
  }

  @override
  void initState() {
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: AppBar(
          title: Row(
            children: [
              Icon(Icons.help_outline),
              SizedBox(width: 50),
              Text(widget.title),
            ],
          ),
          centerTitle: true,
        ),
      ),
      body: WebView(
        initialUrl: 'https://flutter.dev',
      ),
    );
  }
}
