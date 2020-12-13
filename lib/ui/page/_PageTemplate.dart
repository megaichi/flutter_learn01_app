import 'package:flutter/material.dart';

class PageTemplate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Page Template 0',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TemplateHomePage(title: 'Template Home 1'),
    );
  }
}

class TemplateHomePage extends StatefulWidget {
  TemplateHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TemplateHomePageState createState() => _TemplateHomePageState();
}

class _TemplateHomePageState extends State<TemplateHomePage> {
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
                Text("この画面が表示される機能は、未検証です")
              ])
            ])));
  }
}
