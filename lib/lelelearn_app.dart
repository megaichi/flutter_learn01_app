import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lelele_proto1/ui/page/home/_home.dart';
import 'package:lelele_proto1/ui/page/learn/_learn.dart';
import 'package:lelele_proto1/ui/page/other/_other.dart';
import 'package:lelele_proto1/ui/page/record/_record.dart';
import 'package:shared_preferences/shared_preferences.dart';

///
/// LeLeLearn APP
///
class LelelearnApp extends StatelessWidget {
  /// Firebase ユーザー どこからでも参照できるように static
  static User firebaseUser;

  /// 管理者モード Otherページのタイトル10回クリックで有効
  static bool adminMode = false;

  // https://pub.dev/packages/firebase_analytics
  FirebaseAnalytics analytics = FirebaseAnalytics();

// 広告ターゲット
  MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['flutterio', 'beautiful apps'],
    contentUrl: 'https://flutter.io',
//    birthday: DateTime.now(),
    childDirected: false,
//    designedForFamilies: false,
//    gender: MobileAdGender.male, // or female, unknownz1
    testDevices: <String>[], // Android emulators are considered test devices
  );

  static BannerAd admobBanner = BannerAd(
    // テスト用のIDを使用
    // リリース時にはIDを置き換える必要あり
    adUnitId: BannerAd.testAdUnitId,
    size: AdSize.smartBanner,
//    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      // 広告の読み込みが完了
      print("BannerAd event is $event");
    },
  );

  LelelearnApp() {
    log("LelelearnApp.constructor");
  }

  // fixme: le_auth に移動
  _login() async {
    // https://firebase.flutter.dev/docs/auth/usage
    FirebaseAuth.instance.authStateChanges().listen((User user) async {
      if (user == null) {
        // ログイン状態でなければ匿名ユーザとして処理する。
        // Memo: Firebase の設定で匿名を有効にする必要がある。
        UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
        firebaseUser = userCredential.user;
        print('User is currently signed out! $userCredential.user');
      } else {
        firebaseUser = user;
        print('User is signed in! $user');
      }
    });

    String _email = "paul.soundprj+user1@gmail.com";
    String _password = "scarlet8818";

    try {
      firebaseUser = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password)).user;
      print('Singed in: ${firebaseUser.uid}');
    } catch (e) {
      // ToDo: エラー処理、ネットワークにつながっていないとき
      print('Error: $e');
    }

    _createFireStoreUser();
  }

  _createFireStoreUser() async {
    // var fsUser = FirebaseFirestore.instance.collection('users').where("id", isEqualTo: firebaseUser.uid).snapshots();
    // print("fsUser: $fsUser");

    var document = await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .get()
        .then((DocumentSnapshot document) {
      if (!document.exists) {
        Map<String, dynamic> data = <String, dynamic>{'name': firebaseUser.displayName};
        FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).set(data);
      }
      print("user: $document");
    });
  }

  //
  // This widget is the root of your application.
  //
  @override
  Widget build(BuildContext context) {
    _login();

    return MaterialApp(
      // 多言語化対応
      //https://qiita.com/tetsukick/items/962505028d14006af370
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'LeLeLeran Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LelelearnHomePage(title: 'LeLeLeran Proto 1'),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
    );
  }
}

///
///
///
class LelelearnHomePage extends StatefulWidget {
  LelelearnHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LelelearnHomePageState createState() => _LelelearnHomePageState();
}

///
///
///
class _LelelearnHomePageState extends State<LelelearnHomePage> with AutomaticKeepAliveClientMixin {
//  int _counter = 0;
//
//  void _incrementCounter() {
//    setState(() {
//      _counter++;
//    });
//  }

  SharedPreferences _prefs;

  //
  // Firebase User ID
  String firebaseUid = '';

  Future<void> _getSharedPreferenceInstance() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<String> _getFirebaseUid() async {
    String result;

    try {
      result = _prefs.getString('firebaseUid') ?? '';
    } on NoSuchMethodError {
      print('uid Get Error');
    }

    return result;
  }

  @override
  void initState() {
    // // https://firebase.flutter.dev/docs/auth/usage
    // FirebaseAuth.instance.authStateChanges().listen((User user) async {
    //   if (user == null) {
    //     UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
    //
    //     print('User is currently signed out! $userCredential.user');
    //   } else {
    //     print('User is signed in! $user');
    //   }
    // });

    _getSharedPreferenceInstance();

    _getFirebaseUid().then((firebaseUid) {
      if (firebaseUid == null) {
        // ToDo: ログインして、SharedPreferenceに保存する
//        LelelearnApp.firebaseUser = fbuid;
      } else {
        print(firebaseUid);
      }
    });

    // ここで初期化する必要がある。 initState()
    // https://webbibouroku.com/Blog/Article/flutter-firebase-admob
    String appId = 'ca-app-pub-4392261084012287~9009411190';
    String admob01 = BannerAd.testAdUnitId;
    FirebaseAdMob.instance.initialize(appId: appId);
//  FirebaseAdMob.instance.initialize(appId: appId);

    // ToDo: AdMob表示
    // LelelearnApp.admobBanner
    //   ..load()
    //   ..show(
    //     // ボトムからのオフセットで表示位置を決定
    //     anchorOffset: adMobAnchorOffset,
    //     anchorType: AnchorType.bottom,
    //   );

    super.initState();
  }

  int _selectedIndex = 0;

  static List<Widget> _pageList = [
//    CustomPage(pannelColor: Colors.cyan, title: 'Home'),
//    CustomPage(pannelColor: Colors.green, title: 'Settings'),
    PageHome(),
    PageLearnTab(),
    PageRecord(),
    PageOther()
//    CustomPage(pannelColor: Colors.pink, title: 'Other')
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /// SnackBar表示用
  final GlobalKey<ScaffoldState> scaffoldstate = new GlobalKey<ScaffoldState>();

  void _showSnackBar(String msg) {
    scaffoldstate.currentState
        .showSnackBar(new SnackBar(content: new Text(msg), duration: Duration(milliseconds: 600)));
  }

//  void _createNew() {
//    _showSnackBar("Create New");
//  }

  int counter = 25;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: scaffoldstate,
//      appBar: AppBar(
//        title: Text(widget.title),
//        actions: [
//          IconButton(
//            icon: Icon(Icons.favorite_border),
//            onPressed: () => setState(() {
//              _createNew();
//            }),
//          ),
//          IconButton(
//            icon: Icon(Icons.add),
//            onPressed: () => setState(() {
//              _createNew();
//            }),
//          ),
//        ],
//      ),
//      body: _pageList[_selectedIndex],

      // ボトムナビゲーションバーを移動しても画面の状態が保持されるようにする
      // https://medium.com/@codinghive.dev/keep-state-of-widgets-with-bottom-navigation-bar-in-flutter-bb732214bd11
      body: IndexedStack(
        index: _selectedIndex,
        children: _pageList,
      ),

      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`
            canvasColor: Theme.of(context).primaryColor,
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
            primaryColor: Theme.of(context).primaryColorDark,
            textTheme: Theme.of(context).textTheme.copyWith(
                caption: new TextStyle(
                    color:
                        Theme.of(context).bottomAppBarColor))), // sets the inactive color of the `BottomNavigationBar`

        // ToDo: BottomNavigationBar を SizedBoxで囲ってある。練習の際は、BottomNavigationBarを隠す実装を行う
        // https://stackoverflow.com/questions/53758698/flutter-dart-customize-bottom-navigation-bar-height
        child: SizedBox(
          height: 58,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.edit),
                label: 'Learn',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.music_video),
                label: 'Record',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.more_horiz),
                label: 'Other',
              ),
              // 通知を表示する
              // https://stackoverflow.com/questions/45155104/displaying-notification-badge-on-bottomnavigationbars-icon
              // https://medium.com/@ayushbherwani/notification-badge-in-flutter-c776a6194936
              // BottomNavigationBarItem(
              //   label: 'Other',
              //   icon: Stack(
              //     children: [
              //       Icon(Icons.more_horiz),
              //       counter != 0 ? Positioned(
              //         right: 0,
              //         child: Container(
              //           padding: EdgeInsets.all(1),
              //           decoration: BoxDecoration(
              //             color: Colors.red,
              //             borderRadius: BorderRadius.circular(6),
              //           ),
              //           constraints: BoxConstraints(
              //             minWidth: 14,
              //             minHeight: 14,
              //           ),
              //           child: Text(
              //             '$counter',
              //             style: TextStyle(
              //               color: Colors.white,
              //               fontSize: 9,
              //             ),
              //             textAlign: TextAlign.center,
              //           ),
              //         ),
              //       ) :  Container()
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
