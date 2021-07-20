import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule_neuron/model/drop_down_item.dart';
import 'package:schedule_neuron/model/drop_down_list.dart';
import 'package:schedule_neuron/model/my_user.dart';
import 'package:schedule_neuron/screen/home/credits.dart';
import 'package:schedule_neuron/screen/home/sticky_notes/single_sticky_note.dart';
import 'package:schedule_neuron/service/auth.dart';
import 'package:schedule_neuron/service/database.dart';
import 'package:schedule_neuron/shared/clipper.dart';
import 'package:schedule_neuron/shared/hex_color.dart';
import 'package:schedule_neuron/shared/loading.dart';
import 'package:schedule_neuron/shared/constants.dart';

class StickyNotes extends StatefulWidget {
  const StickyNotes({Key? key}) : super(key: key);

  @override
  _StickyNotesState createState() => _StickyNotesState();
}

class _StickyNotesState extends State<StickyNotes> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService(); // log-out related variable
  List<String> textList = [''];
  List<SingleStickyNote> stickyNotes = [
    SingleStickyNote(text: 'Add a note!', category: 'Others')
  ];

  List<String> categoryText = [
    'Others',
    'Exercise',
    'Work',
    'Personal',
    'Interest',
    'Food',
  ];

  //design related varables
  final headerSize = 25.0;
  final headerColor = HexColor('#000000'); // black
  final topColor = HexColor('#F9BE7C'); // orange
  final btmColor = HexColor('#FFF9EB'); // light orange

  final List<HexColor> iconColorList = [
    HexColor('#EC7063'), // category - light red
    HexColor('#6BB2F3'), // exercise - light blue
    HexColor('#F3C06B'), // work - light brown
    HexColor('#F7DC6F'), // personal - light yellow
    HexColor('#D7BDE2'), // interest - light purple
    HexColor('#797D7F'), // food - light grey
  ];

  final List<IconData> iconList = [
    Icons.window,
    Icons.directions_run,
    Icons.business_center,
    Icons.shower,
    Icons.brush,
    Icons.fastfood,
  ];

  final List<double> iconSize = [25, 27, 25, 27, 27, 25];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);

    // listens to firestore stream and rebuilds widget if there are changes
    return StreamBuilder<DocumentSnapshot>(
        stream: DatabaseService(uid: user.uid).userNotes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // gets data from firestore stream and updates stickyNotes
            try {
              List<dynamic> firestoreList = snapshot.data!.get('notes');
              stickyNotes = [];
              for (Map<String, dynamic> element in firestoreList) {
                stickyNotes.add(SingleStickyNote(
                    text: element['text'], category: element['category']));
              }
            } catch (e) {
              stickyNotes = [
                SingleStickyNote(text: 'Add a note!', category: 'Others')
              ];
            }

            return Scaffold(
              backgroundColor: topColor,
              body: Stack(
                children: <Widget>[
                  buildBtmArcContainer(0, 0), // btm-left
                  buildTopArcContainer(0, 0), // btm-left
                  buildPageHeader(context, _auth, 75, 30), // top-left
                  buildNotes(180, 40, user), // top-left
                  buildCreateButton(
                      150, 240, context, snapshot.data, user), // top-left
                  buildClearButton(150, 310, user), // top-left
                  //displayIconDebug(190, 30), // top-left
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }

  // background color
  Widget buildTopArcContainer(double first, double second) {
    return Positioned(
      bottom: first,
      left: second,
      child: ClipPath(
        clipper: ClipperUpwards(),
        child: Container(
          height: 640,
          width: 412,
          decoration: BoxDecoration(
            color: topColor,
          ),
          child: Text(''),
        ),
      ),
    );
  }

  // background color
  Widget buildBtmArcContainer(double first, double second) {
    return Positioned(
      bottom: first,
      left: second,
      child: Container(
        height: 640,
        width: 412,
        decoration: BoxDecoration(
          color: btmColor,
        ),
        child: Text(''),
      ),
    );
  }

  // Page Title - 'Sticky Notes
  Widget buildPageHeader(
      BuildContext context, AuthService _auth, double first, double second) {
    return Positioned(
      top: first,
      left: second,
      child: Row(
        children: <Widget>[
          Text(
            'Sticky Notes',
            style: TextStyle(
              fontSize: headerSize,
              fontWeight: FontWeight.bold,
              color: headerColor,
            ),
          ),
          SizedBox(width: 150),
          menuBar(context, _auth),
        ],
      ),
    );
  }

  // menu bar at top right
  Widget menuBar(BuildContext context, AuthService _auth) {
    return PopupMenuButton<DropDownItem>(
      onSelected: (item) => onSelected(context, item, _auth),
      itemBuilder: (context) => [
        ...DropDownList.itemsFirst.map(buildItem).toList(),
        PopupMenuDivider(),
        ...DropDownList.itemsSecond.map(buildItem).toList(),
      ],
    );
  }

  // design for each drop down item at top right
  PopupMenuItem<DropDownItem> buildItem(DropDownItem item) {
    return PopupMenuItem<DropDownItem>(
      value: item,
      child: Row(
        children: <Widget>[
          Icon(item.icon, color: Colors.black, size: 20),
          SizedBox(width: 12),
          Text(item.text),
        ],
      ),
    );
  }

  // list of actions carried out when the user press on log out, theme and credit
  void onSelected(BuildContext context, DropDownItem item, AuthService _auth) {
    switch (item) {
      case DropDownList.itemsLogOut:
        _auth.signOut(); // user log-outs when pressed
        break;

      case DropDownList.itemsCredit:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Credits()));
        break;
    }
  }

  // log out button at top right (left here in case menuBar fails, DO NOT DELETE)
  /*Widget logOutButton(BuildContext context, AuthService _auth) {
    return ElevatedButton.icon(
      onPressed: () async {
        await _auth.signOut(); // user log-outs when pressed
      },
      icon: Icon(Icons.logout),
      label: Text('Logout'),
      style: ElevatedButton.styleFrom(
        primary: Colors.brown,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }*/

  // overall notes layout
  Widget buildNotes(double first, double second, MyUser user) {
    return Positioned(
      top: first,
      left: second,
      // overall black box
      child: SizedBox(
        height: 550,
        width: 330,
        child: Container(
          //color: Colors.black,
          height: 300,
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.0, // red box height
            children: stickyNotes.map((note) {
              return individualStickyNotes(note.category, note.text, user);
            }).toList(),
          ),
        ),
      ),
    );
  }

  // handles the individual white boxes of sticky notes
  Widget individualStickyNotes(String category, String text, MyUser user) {
    int number = 0;
    if (category == 'Exercise') {
      number = 1;
    } else if (category == 'Work') {
      number = 2;
    } else if (category == 'Personal') {
      number = 3;
    } else if (category == 'Interest') {
      number = 4;
    } else if (category == 'Food') {
      number = 5;
    } else {
      number = 0;
    }

    HexColor selectedColor = iconColorList[number];
    IconData selectedIcon = iconList[number];
    double selectedSize = iconSize[number];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        border: Border.all(
          color: Colors.transparent,
          width: 1.0,
        ),
      ),
      child: SizedBox(
        height: 200,
        width: 100,
        child: Stack(
          children: <Widget>[
            // 'category' at the top of user input
            Positioned(
              top: 18,
              left: 15,
              // category box height
              child: Row(
                children: <Widget>[
                  Container(
                    constraints: BoxConstraints(
                      minHeight: 25,
                      minWidth: 80,
                    ),
                    decoration: BoxDecoration(
                      color: selectedColor,
                      borderRadius: BorderRadius.all(Radius.circular(13.0)),
                    ),
                    alignment: Alignment.center,
                    child: Center(
                        child: Text(category, textAlign: TextAlign.left)),
                  ),
                  SizedBox(width: 15.0),
                  Icon(selectedIcon, size: selectedSize, color: selectedColor),
                ],
              ),
            ),
            // bulk of text by user input
            Positioned(
              top: 50,
              left: 15,
              // text box height
              child: Container(
                width: 120,
                constraints: BoxConstraints(
                  maxHeight: 80,
                  minWidth: 130,
                ),
                decoration: BoxDecoration(
                    //color: Colors.blue, // debug
                    ),
                alignment: Alignment.topCenter,
                // bulk text in blue box - need to add word count restriction
                child: Center(
                  child: Text(
                    text,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            // black dustin at btm right of every sticky note
            Positioned(
              top: 115,
              left: 110,
              child: IconButton(
                onPressed: () async {
                  await DatabaseService(uid: user.uid).deleteUserNotes(
                      SingleStickyNote(text: text, category: category));
                },
                icon: Icon(Icons.delete, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // pen button at top right to make new sticky notes
  Widget buildCreateButton(double first, double second, BuildContext context,
      DocumentSnapshot? snapshot, MyUser user) {
    return Positioned(
      top: first,
      left: second,
      child: FloatingActionButton(
        onPressed: () async {
          await _showAddDialog(context, snapshot, user);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.brown,
      ),
    );
  }

  // add dialog when the user presses the add button
  Future _showAddDialog(
      BuildContext context, DocumentSnapshot? snapshot, MyUser user) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          String _text = '';
          String _category = 'Others';
          return AlertDialog(
            title: const Text('Add a sticky note'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      initialValue: _text,
                      decoration: InputDecoration(
                        labelText: 'Note',
                        icon: Icon(Icons.sticky_note_2),
                      ),
                      validator: (val) =>
                          val!.isEmpty ? 'Please enter a note' : null,
                      onChanged: (val) => _text = val,
                    ),
                    SizedBox(height: 20.0),
                    DropdownButtonFormField(
                      value: _category,
                      decoration: textInputDecoration,
                      items: categoryText.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (val) => _category = val as String,
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Add'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await DatabaseService(uid: user.uid).updateUserNotes(
                      SingleStickyNote(text: _text, category: _category),
                      snapshot,
                    );
                    Navigator.of(context).pop();
                  }
                },
              ),
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  // dustin button at top right to clear all sticky notes
  Widget buildClearButton(double first, double second, MyUser user) {
    return Positioned(
      top: first,
      left: second,
      child: FloatingActionButton(
        onPressed: () async {
          await DatabaseService(uid: user.uid).deleteAllUserNotes();
        },
        child: Icon(Icons.delete),
        backgroundColor: Colors.brown,
      ),
    );
  }

  // debug purpose
  Widget displayIconDebug(double first, double second) {
    return Positioned(
      top: first,
      left: second,
      child: Row(
        children: <Widget>[
          Icon(iconList[0], color: iconColorList[0]),
          SizedBox(width: 5.0),
          Icon(iconList[1], color: iconColorList[1]),
          SizedBox(width: 5.0),
          Icon(iconList[2], color: iconColorList[2]),
          SizedBox(width: 5.0),
          Icon(iconList[3], color: iconColorList[3]),
          SizedBox(width: 5.0),
          Icon(iconList[4], color: iconColorList[4]),
          SizedBox(width: 5.0),
          Icon(iconList[5], color: iconColorList[5]),
        ],
      ),
    );
  }
}
