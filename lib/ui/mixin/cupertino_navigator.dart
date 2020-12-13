import 'package:flutter/cupertino.dart';

mixin CupertinoNavigator {
  void navigatorPush(BuildContext context, Widget page) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) {
          return page;
        },
      ),
    );
  }
}
