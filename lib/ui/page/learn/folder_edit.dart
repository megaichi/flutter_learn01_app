import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:lelele_proto1/assets/lelele_icon.dart';
import 'package:lelele_proto1/assets/lelele_icon_map.dart';
import 'package:lelele_proto1/logic/define/lelele_constants.dart';
import 'package:lelele_proto1/logic/data/folder.dart';
import 'package:lelele_proto1/ui/page/learn/_learn.dart';
import 'package:page_transition/page_transition.dart';

///
///
///
// class PageLearnFolderEdit extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Page LearnFolderCreate 0',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: LearnCreateFolderHomePage(title: 'Learn Folder Create'),
//     );
//   }
// }

//--------------------------------------------------------------------------------------------------------------------//

///
/// フォルダ編集ページ
///
class LearnFolderEditHomePage extends StatefulWidget {
  LearnFolderEditHomePage({Key key, this.title = 'Create Folder', this.folder}) : super(key: key);

  final String title;
  final Folder folder;

  @override
  _LearnFolderEditHomePageState createState() => _LearnFolderEditHomePageState(this.folder);
}

//--------------------------------------------------------------------------------------------------------------------//

///
///
///
class _LearnFolderEditHomePageState extends State<LearnFolderEditHomePage> {
  //-----------------//
  //  Class Param    //
  //-----------------//

  ///
  Folder folder;

  ///
  List<IconData> _selectedIcons = [];

  ///
  final _formKey = GlobalKey<FormState>();

  ///
  Color pickerColor = Color(0xff443a49);

//  Color currentColor = Color(0x000000);

  //-----------------//
  // LOGIC           //
  //-----------------//

  ///
  ///
  ///
  _LearnFolderEditHomePageState(this.folder);

  // https://medium.com/@ericgrandt/selectable-gridview-in-flutter-f5e00e3c7bf8
  final List<IconData> _instrumentIcons = [
//    Icons.music_note,
//     Icons.ac_unit,
//     Icons.dashboard,
//     Icons.backspace,
//     Icons.cached,
//     Icons.edit,
//     Icons.face,
//     Icons.favorite_border,
    LeleleIcon.music,
    LeleleIcon.guitar,
    LeleleIcon.piano,
    LeleleIcon.healing,
    LeleleIcon.redeem,
    LeleleIcon.speaker,
    LeleleIcon.spa,
    LeleleIcon.tag_faces,
  ];

  @override
  void initState() {
    if (folder == null) {
      folder = Folder(color: Colors.white.value, instrument: LeleleIcon.music.codePoint, favorite: false);
    }

    super.initState();
  }

  ///
  /// 色変更
  ///
//  void _changeColor(Color color) => setState(() => currentColor = color);
  void _changeColor(Color color) => setState(() => folder.color = color.value);

  ///
  /// 色選択
  ///
  _showColorPicker() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select a color'),
          content: SingleChildScrollView(
            child: BlockPicker(
//              pickerColor: currentColor,
                pickerColor: Color(folder.color),
                onColorChanged: (Color color) {
                  _changeColor(color);
                  Navigator.of(context).pop();
                }
                // ToDo: フォルダの色選択、指定するとエラーになるので対応する
                // availableColors: [
                //   Color(13362425),
                //   Color(13497846),
                //   Color(15727066),
                //   Color(16378847),
                //   Color(16373974),
                //   Color(14077418),
                // ],
                ),
          ),
        );
      },
    );
  }

  //-----------------//
  // LAYOUT          //
  //-----------------//

  @override
  Widget build(BuildContext context) {
    // 楽器アイコンの選択
    if (folder.instrument == null) {
      _selectedIcons.add((leleleInstrumentIconsMap[LeleleIcon.music.codePoint]));
      folder.instrument = LeleleIcon.music.codePoint;
    } else {
      _selectedIcons.add((leleleInstrumentIconsMap[folder.instrument]));
    }

    return Scaffold(
        // 実機でサイズがおかしくなる対応
        // https://qiita.com/fujit33/items/81494e22986083c212f4
        resizeToAvoidBottomPadding: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(appBarHeight),
          child: AppBar(
              leading: IconButton(
                icon: Icon(Icons.keyboard_arrow_down),
                // onPressed: () {},
                onPressed: () =>
                    Navigator.pop(context, PageTransition(type: PageTransitionType.bottomToTop, child: LearnPage())),
              ),
              title: Text(widget.title)),
        ),
        body: Container(
//            color: Colors.black12,
            margin: EdgeInsets.all(4.0),
            child: Form(
              key: _formKey,
              child: Column(children: [
                TextFormField(
//                  autofocus: true,
                  onChanged: (text) {
                    folder.name = text;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'フォルダ名を入力してください';
                    }
                    return null;
                  },
                  controller: TextEditingController(text: folder.name),
                  decoration: InputDecoration(labelText: 'フォルダ名'),
                ),
                Row(
                  children: [
                    Text(
                      "Icon:",
                      style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
                Expanded(
                  flex: 5,
                  child: GridView.count(
                    childAspectRatio: 2.0,
                    crossAxisCount: 4,
                    mainAxisSpacing: 10.0,
                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    children: _instrumentIcons.map((iconData) {
                      return GestureDetector(
                        onTap: () {
                          print("iconData: $iconData");
                          _selectedIcons.clear();
                          folder.instrument = iconData.codePoint;
                          setState(() {
                            _selectedIcons.add(iconData);
                          });
                        },
                        child: GridViewItem(iconData, _selectedIcons.contains(iconData), "name1"),
                      );
                    }).toList(),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "Color:",
                      style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
                Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: InkWell(
                        onTap: () {
                          _showColorPicker();
                        },
                        child: Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
//                            color: currentColor,
                            color: Color(folder.color),
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text("Color"),
                        ),
                      ),
                    )),
                Expanded(
                  flex: 3,
                  child: Container(),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                    top: BorderSide(
                      color: Colors.black12,
                      width: 1.0,
                    ),
                  )),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      child: Text("キャンセル"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      child: Text("O K"),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          // If the form is valid, display a Snackbar.
//                          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
                          folder.upsert();
                          Navigator.pop((context));
                        }
                      },
                    ),
                  ]),
                )
              ]),
            )));
  }
}

///
/// GridViewItem.
///
/// https://medium.com/@ericgrandt/selectable-gridview-in-flutter-f5e00e3c7bf8
///
class GridViewItem extends StatelessWidget {
  final IconData _iconData;
  final bool _isSelected;
  final String name;

  GridViewItem(this._iconData, this._isSelected, this.name);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Icon(
        _iconData,
        color: Colors.white,
      ),
      shape: CircleBorder(),
      fillColor: _isSelected ? Colors.blue : Colors.black,
      onPressed: null,
    );

    // return RawMaterialButton(
    //   child: Icon(
    //     _iconData,
    //     color: Colors.white,
    //   ),
    //   shape: CircleBorder(),
    //   fillColor: _isSelected ? Colors.blue : Colors.black,
    //   onPressed: null,
    // );
  }
}
