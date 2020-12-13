import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lelele_proto1/logic/data/folder.dart';
import 'package:lelele_proto1/ui/page/learn/folder_edit.dart';
import 'package:lelele_proto1/ui/page/learn/tab/basics_folder_list.dart';
import 'package:lelele_proto1/ui/page/learn/tab/my_folder_list.dart';
import 'package:lelele_proto1/ui/page/learn/tab/share_folder_list.dart';
import 'package:lelele_proto1/ui/page/learn/tab/store_folder_list.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

///
/// Learnボトムメニューのタブページ
///
class PageLearnTab extends StatelessWidget {
  final fbQuery = FirebaseQuery(orderBy: "name");

  @override
  Widget build(BuildContext context) {
    log("PageLearn.build");
    return ChangeNotifierProvider<FirebaseQuery>.value(
      value: fbQuery,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Page Home 0',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LearnPage(
          title: 'Learn',
          fbQuery: fbQuery,
        ),
      ),
    );
  }
}

///
///
///
class LearnPage extends StatefulWidget {
  LearnPage({Key key, this.title, this.fbQuery}) : super(key: key);

  final String title;
  final FirebaseQuery fbQuery;

  @override
  _LearnPageState createState() => _LearnPageState(fbQuery: fbQuery);
}

///
///
///
class _LearnPageState extends State<LearnPage> {
  final GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();

  final FirebaseQuery fbQuery;

  _LearnPageState({this.fbQuery});

  // https://flutter.ctrnost.com/basic/navigation/tabbar/
  final _tab = <Tab>[
    Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.folder_open, size: 20),
          Text(
            "MyFolder",
            // style: TextStyle(fontSize: 10),
          )
        ],
      ),
    ),
    Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.beenhere, size: 20),
          Text(
            "Basics",
            // style: TextStyle(fontSize: 12),
          )
        ],
      ),
    ),
    Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [Icon(Icons.share, size: 20), Text("Shared")],
      ),
    ),
    Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [Icon(Icons.store, size: 20), Text("Store")],
      ),
    ),
  ];

  bool _favorite = false;
  IconData _favoriteIcon = Icons.favorite_border;

  String _selectedValue = 'name';
  var _usStates = ["name", "color", "instrument"];
  var popupMenuItem = [
    PopupMenuItem(
      child: Text("Name"),
      value: "name",
    ),
    PopupMenuItem(
      child: Text("Color"),
      value: "color",
    ),
    PopupMenuItem(
      child: Text("Instrument"),
      value: "instrument",
    ),
  ];

//  LearnTabMyFolderPage myFolderTab = LearnTabMyFolderPage(title: "Learn");
//  PageLearnMyFolderList myFolderTab = PageLearnMyFolderList();

  bool addFolderIconEnabled = true;

  void _setFavorite() {
    setState(() {
      _favoriteIcon = _favoriteIcon == Icons.favorite_border ? Icons.favorite : Icons.favorite_border;
      _favorite = _favorite == true ? false : true;
      fbQuery.favorite = _favorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tab.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: AppBar(
//          toolbarHeight: kToolbarHeight * 0.8,
//          leading: Icon(Icons.edit),
            leading: IconButton(
              icon: Icon(_favoriteIcon),
              onPressed: () => _setFavorite(),
            ),
            centerTitle: true,
            title: Text(widget.title),
            actions: <Widget>[
              PopupMenuButton<String>(
                icon: Icon(Icons.sort),
                initialValue: _selectedValue,
                onSelected: (String selected) {
                  setState(() {
                    _selectedValue = selected;
                    fbQuery.orderBy = selected;
                  });
                },
                itemBuilder: (BuildContext context) {
                  return _usStates.map((String selected) {
                    return PopupMenuItem(
                      child: Text(
                        selected,
                        style: TextStyle(
                          fontSize: 14,
//                      color: Theme.of(context).primaryColor,
                        ),
                      ),
                      value: selected,
                    );
                  }).toList();
                },
              ),

              // IconButton(
              //   icon: Icon(Icons.favorite_border),
              //   onPressed: () {
              //     if (isFavorite) {
              //     } else {}
              //   },
              // ),
//          IconButton(icon: Icon(Icons.add), onPressed: _patternForlderCreateDialog),
              IconButton(icon: Icon(Icons.add), onPressed: _folderEdit),
            ],
            bottom: TabBar(
              isScrollable: true,
              tabs: _tab,
            ),
          ),
        ),
        body: TabBarView(children: <Widget>[
          PageLearnMyFolderList(favorite: _favorite),
          LearnTabBasicsFolderList(),
          LearnTabShareFolderList(),
          LearnTabStoreFolderList(),

//          TabPage(title: 'Car', icon: Icons.directions_car),
//          TabPage(title: 'Bicycle', icon: Icons.directions_bike),
//          TabPage(title: 'Boat', icon: Icons.directions_boat),
        ]),
      ),
    );
  }

  _folderEdit({Folder folder}) {
//    Navigator.push(context, CupertinoPageRoute(builder: (context) => PageLearnFolderCreate()));
//    Navigator.push(context, MaterialPageRoute(builder: (context) => PageLearnFolderCreate()));

    folder = folder == null ? Folder(color: Colors.white.value) : folder;

    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.bottomToTop,
            child: LearnFolderEditHomePage(
              folder: folder,
            )));
  }

  @override
  bool get wantKeepAlive => true;
}

class FirebaseQuery extends ChangeNotifier {
  bool favorite;
  String orderBy;

  FirebaseQuery({this.favorite, this.orderBy});
}
