import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lelele_proto1/logic/define/lelele_constants.dart';
import 'package:lelele_proto1/lelelearn_app.dart';
import 'package:lelele_proto1/ui/page/other/other_help.dart';
import 'package:lelele_proto1/ui/page/other/other_setting.dart';
import 'package:lelele_proto1/ui/page/other/other_signin.dart';
import 'package:lelele_proto1/ui/page/other/other_test.dart';
import 'package:lelele_proto1/ui/widget/other_page_card.dart';
import 'package:package_info/package_info.dart';

///
/// PageOther
///
class PageOther extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    log("PageOther.build");

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Page Other 0',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: OtherPage(title: 'Other'),
    );
  }
}

///
/// その他画面トップ
///
class OtherPage extends StatefulWidget {
  OtherPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _OtherPageState createState() => _OtherPageState();
}

///
///
///
class _OtherPageState extends State<OtherPage> {
  final Color adminModeOnTitleColor = Colors.orange;
  Color _titleColor;

//  final Color adminModeOffTitleColor = Theme.of(context).primaryColor);

  final GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();

  void _showSnackBar(String msg) {
    scaffoldState.currentState
        .showSnackBar(new SnackBar(content: new Text(msg), duration: Duration(milliseconds: 600)));
  }

  // https://pub.dev/packages/package_info/example
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

//  void _showSnackBar(String msg) {
//    scaffoldstate.currentState
//        .showSnackBar(new SnackBar(content: new Text(msg), duration: Duration(milliseconds: 600)));
//  }

  ///
  ///
  ///
  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    log('PageOther.initState');
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  /// 管理者モード用カウント
  int _adminModeCount = 0;

  /// 管理者モード切替用 タイトルクリックチェック
  _appBarTapCount() {
    _adminModeCount++;
    print("adminModeCount: $_adminModeCount");
    if (_adminModeCount >= 10) {
      _adminModeCount = 0;

      if (LelelearnApp.adminMode) {
        LelelearnApp.adminMode = false;
        _showSnackBar('Admin Mode OFF');

        // ToDo: Adminモードのときは、タイトルの色を変えたいが、うまく動いていない。
        setState(() {
          _titleColor = adminModeOnTitleColor;
        });
      } else {
        LelelearnApp.adminMode = true;
        _showSnackBar('Admin Mode ON');
        setState(() {
          _titleColor = Theme.of(context).primaryTextTheme.headline1.color;
        });
      }
    }
  }

  _pageMove(Widget widget) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) {
          return widget;
        },
      ),
    );
  }

  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    log("_HomePageState.build");

    _titleColor = Theme.of(context).primaryTextTheme.headline1.color;

    return Scaffold(
        key: scaffoldState,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(appBarHeight),
          child: AppBar(
            leading: Icon(Icons.more_horiz),
            centerTitle: true,
            title: GestureDetector(
                onTap: () {
                  _appBarTapCount();
                },
                child: Text(widget.title, style: TextStyle(color: _titleColor))),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                OtherPageCard(
                    title: '設定',
                    icon: Icons.settings,
                    onTap: () {
                      _pageMove(OtherSettingHomePage(title: 'Setting'));
                    }),
                OtherPageCard(
                    title: 'サインイン',
                    icon: Icons.person,
                    onTap: () {
                      _pageMove(OtherSigninHomePage(title: 'Signin'));
                    }),
                OtherPageCard(
                    title: 'チュートリアル',
                    icon: Icons.record_voice_over,
                    onTap: () {
//                      _pageMove(OtherSettingHomePage(title: 'Setting'));
                    }),
                OtherPageCard(
                    title: 'ヘルプ',
                    icon: Icons.help_outline,
                    onTap: () {
                      _pageMove(OtherHelpHomePage(title: 'Help'));
                    }),
                OtherPageCard(
                    title: 'ランキング',
                    icon: Icons.assessment,
                    onTap: () {
//                      _pageMove(OtherHelpHomePage(title: 'Help'));
                    }),
                OtherPageCard(
                    title: 'クレジット',
                    icon: Icons.info_outline,
                    onTap: () {
                      // Memo: 他の方法もあり
                      // https://blog.takuchalle.dev/post/2020/02/13/show_license_page/
                      showLicensePage(
                        context: context,
                        applicationName: _packageInfo.appName, // アプリの名前
                        applicationVersion: _packageInfo.version, // バージョン
//                        applicationIcon: applicationIcon, // アプリのアイコン Widget
                        applicationLegalese: '2020 Team G-Three', // 権利情報
                      );
                    }),
                OtherPageCard(
                    title: 'テストページ',
                    icon: Icons.terrain,
                    onTap: () {
                      _pageMove(PageOtherCheck());
                    }),
              ],
            ),
          ),
        ));
  }
}

// class OtherPageCard extends StatelessWidget {
//   final VoidCallback onTap;
//   final String title;
//   final IconData icon;
//
//   OtherPageCard({Key key, this.title, this.icon, this.onTap}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       child: Card(
//         margin: const EdgeInsets.all(6.0),
//         child: InkWell(
//           child: Container(
//               margin: const EdgeInsets.all(10.0),
//               width: MediaQuery.of(context).size.width * 0.92,
//               height: 60,
//               child: Row(
//                 children: [
//                   Icon(icon),
//                   SizedBox(width: 8),
//                   Text(
//                     this.title,
//                     style: TextStyle(fontSize: 20),
//                   ),
//                 ],
//               )),
//           onTap: this.onTap,
//         ),
//       ),
//     );
//   }
// }
