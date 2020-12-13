import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///
///
///

class MyButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

//---------------------------------------------------------------------------//
class MyStatelessWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(onPressed: null, child: null);

    // // TODO: implement build
    // throw UnimplementedError();
  }
}

//---------------------------------------------------------------------------//
class MyStatefulWidget extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
// //    throw UnimplementedError();
//
//       MyStatefulWidget createState() => _MyStatefulWidgetState();
//   }

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return MyWidget();
  }
}

class MyWidget extends Widget {
  @override
  Element createElement() {
    // TODO: implement createElement
    throw UnimplementedError();
  }
}

class MyElement extends Element {
  MyElement(Widget widget) : super(widget);

  @override
  // TODO: implement debugDoingBuild
  bool get debugDoingBuild => throw UnimplementedError();

  @override
  void performRebuild() {
    // TODO: implement performRebuild
  }
}
