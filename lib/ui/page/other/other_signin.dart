import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:lelele_proto1/logic/define/lelele_constants.dart';
import 'package:lelele_proto1/ui/page/other/register_page.dart';
import 'package:lelele_proto1/ui/page/other/signin_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

/*
  Note:
  firebase_auth
https://pub.dev/packages/firebase_auth/example
のサンプルを流用、
register_page.dart
signin_page.dart
がないといわれるからGitHubから持ってくる。
さらに
flutter_signin_button: ^1.1.0
google_sign_in: ^4.5.6
追加
動いたけど、認証エラー以下のページを参考にSHA-256をFirebaseに追加
https://stackoverflow.com/questions/54557479/flutter-and-google-sign-in-plugin-platformexceptionsign-in-failed-com-google
https://developers.google.com/android/guides/client-auth

> keytool -list -v -alias androiddebugkey -keystore %USERPROFILE%\.android\debug.keystore
パスワードは、android
※ keytoolは、パスがとおってないので、Javaのbinディレクトリで実行
Win10：C:\Program Files (x86)\Java\jre1.8.0_191\bin

表示された、SHA1とSHA256を追加する ※以下ステップ2
https://console.firebase.google.com/project/lelele-proto1/settings/general/android:team.gthree.lelele_proto1

ステップ1：SHA1およびSHA256キーを生成します。
ステップ2：SHA1とSHA256の両方をfirebaseに追加します。 （あなたのアプリの設定で）
  → Firebase → Lelele Proto1 → プロジェクトの概要 → プロジェクトの設定 → Android アプリ → SHA証明書 フィンガープリント
ステップ3：google-services.jsonをAndroid/appプロジェクトフォルダー内。
ステップ4：端末でコマンドflutter cleanを実行します。
ステップ5：Flutterアプリを実行します。

☆☆☆☆☆☆☆☆

名前が付けられないのでメモしておく必要あり

2020/11/27快活クラブ
SHA1
  FC:A5:F7:33:A1:D0:A8:4C:27:DC:A9:7C:74:EC:FD:39:7D:01:4F:07
SHA256
  DF:27:AC:E2:E6:C4:75:E1:4D:99:59:C0:52:CF:D3:03:71:AB:EE:C8:7A:48:93:5C:DA:37:FD:12:1A:2D:93:8B

☆☆☆☆☆☆☆☆

*/

/*
  https://qiita.com/unsoluble_sugar/items/95b16c01b456be19f9ac
  iOSでは、以下の設定が必要

  GoogleService-Info.plist

  key>REVERSED_CLIENT_ID</key>
	<string>com.googleusercontent.apps.446784247440-lbpe31elssv55reijqttk65ihdtg4f9u</string>

  ↓↓↓↓↓

	Info.plist

		<array>
		<dict>
			<key>CFBundleIdentifier</key>
			<string></string>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>com.googleusercontent.apps.446784247440-lbpe31elssv55reijqttk65ihdtg4f9u</string>
		            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
			</array>
		</dict>
	  </array>

  ↓↓↓↓↓

  XCode
    Info
      URL Types
        URL Schemes


 */

// class PageOtherSignin extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Page OtherSignin 0',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: OtherSigninHomePage(title: 'LeLeLearn Help'),
//     );
//   }
// }

class OtherSigninHomePage extends StatefulWidget {
  OtherSigninHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _OtherSigninHomePageState createState() => _OtherSigninHomePageState();
}

///
///
///
class _OtherSigninHomePageState extends State<OtherSigninHomePage> {
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

  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
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
              Icon(Icons.person),
              SizedBox(width: 50),
              Text(widget.title),
            ],
          ),
          centerTitle: true,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: SignInButtonBuilder(
              icon: Icons.person_add,
              backgroundColor: Colors.indigo,
              text: 'Registration',
              onPressed: () => _pushPage(context, RegisterPage()),
            ),
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
          ),
          Container(
            child: SignInButtonBuilder(
              icon: Icons.verified_user,
              backgroundColor: Colors.orange,
              text: 'Sign In',
              onPressed: () => _pushPage(context, SignInPage()),
            ),
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
          ),
        ],
      ),
    );
  }
}
