import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule_neuron/model/drop_down_item.dart';
import 'package:schedule_neuron/model/drop_down_list.dart';
import 'package:schedule_neuron/model/my_user.dart';
import 'package:schedule_neuron/screen/home/credits.dart';
import 'package:schedule_neuron/screen/home/deadlines/deadlines_add_page.dart';
import 'package:schedule_neuron/screen/home/deadlines/deadlines_event.dart';
import 'package:schedule_neuron/screen/home/deadlines/deadlines_view_page.dart';
import 'package:schedule_neuron/screen/home/deadlines/firebase_list_deadlines.dart';
import 'package:schedule_neuron/service/auth.dart';
import 'package:schedule_neuron/service/database.dart';
import 'package:schedule_neuron/service/utils.dart';
import 'package:schedule_neuron/shared/hex_color.dart';
import 'package:schedule_neuron/shared/loading.dart';

// class: manage deadlines list page where user sees all his deadlines
class Deadlines extends StatefulWidget {
  @override
  _DeadlinesState createState() => _DeadlinesState();
}

class _DeadlinesState extends State<Deadlines> {
  final AuthService _auth = AuthService(); // authenication purpose
  List<DeadlinesEvent> eventsList = [];

  // first event variables
  DeadlinesEvent firstEvent =
      DeadlinesEvent('Waiting for User Input', DateTime.now(), 'None', 'None');
  late String firstEventTitle = firstEvent.getTitle;
  late String firstEventPlace = firstEvent.getPlace;
  late String firstEventDetails = firstEvent.getDetails;

  // design related variables
  final HexColor backgroundColor = HexColor('#FFF9EB'); // light yellow
  final HexColor topColor = HexColor('#F9BE7C'); // orange
  final HexColor nearestDeadlinesContColor = HexColor('#FFFFFF'); // white

  final List<Color> tileColor = [
    Colors.green.shade50,
    Colors.blue.shade50,
    Colors.red.shade50,
    Colors.yellow.shade50,
    Colors.orange.shade50,
    Colors.teal.shade50
  ];

  // control color of the various icon
  final HexColor eventIcon = HexColor('#6E2C00');
  final HexColor timerIcon = HexColor('#444974');
  final HexColor locationIcon = HexColor('#E74C3C');
  final HexColor infoIcon = HexColor('#FFD756');
  final HexColor deleteIcon = HexColor('#7B7D7D');

  var count = 0; // tile color count for remaining deadlines

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);

    // listens to firestore stream and rebuilds widget if there are changes
    return StreamBuilder<DocumentSnapshot>(
        stream: DatabaseService(uid: user.uid).userDeadlines,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // builds list based on firestore data
            List<DeadlinesEvent> buildList() {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              List<DeadlinesEvent> returnList = [];
              try {
                List<dynamic> list = data['deadlines'];
                FirebaseListDeadlines firebaseListDeadlines =
                    FirebaseListDeadlines.fromList(list);
                returnList = firebaseListDeadlines.deadlinesList;
              } catch (e) {}
              return returnList;
            }

            // modify eventsList based on firestore data
            eventsList = buildList();

            // sort deadlines based on date
            eventsList.sort((firstDate, secondDate) =>
                firstDate.getDueDateTime.compareTo(secondDate.getDueDateTime));

            return MaterialApp(
              home: Scaffold(
                //appBar: appBarDesign(context, _auth),
                //body: DeadlinesList(),
                backgroundColor: backgroundColor,
                body: Stack(
                  children: <Widget>[
                    topContainer(0.0, 0.0), // top-right
                    pageHeader(context, _auth, 70, 40), // top-left
                    statisticsContainer(125, 23), // top-right
                    statisticsTitle(145, 45), // top-left
                    statisticsData(175, 48), // top-left
                    bellPicture(140.0, 45.0), //top-right
                    deadlinesTitle(325.0, 45.0), // top-left
                    deadlinesData(
                        30.0, 32.0, context, user, snapshot.data), //bottom-left
                    addButton(270.0, 240.0, user, snapshot.data), // top-left
                    clearButton(270.0, 310.0, user), // top-left
                  ],
                ),
              ),
            );
          } else {
            return Loading();
          }
        });
  }

  // orange container at the top
  Widget topContainer(double first, double second) {
    return Positioned(
      top: first,
      right: second,
      child: Container(
        width: 413.0,
        height: 300.0,
        decoration: BoxDecoration(
          color: topColor,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40.0),
              bottomRight: Radius.circular(40.0)),
        ),
      ),
    );
  }

  // Text 'List of Deadlines and log-out button
  Widget pageHeader(
      BuildContext context, AuthService _auth, double first, double second) {
    return Positioned(
      top: first,
      left: second,
      child: Row(
        children: <Widget>[
          Text(
            'List of Deadlines',
            style: TextStyle(
              fontSize: 25.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 100),
          menuBar(context, _auth)
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

  Widget statisticsContainer(double first, double second) {
    return Positioned(
      top: first,
      right: second,
      child: Opacity(
        opacity: 0.5, // scale from 0 to 1
        child: Container(
            width: 360.0,
            height: 130.0,
            decoration: BoxDecoration(
              color: nearestDeadlinesContColor,
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            child: Text('')),
      ),
    );
  }

  Widget statisticsTitle(double first, double second) {
    return Positioned(
      top: first,
      left: second,
      child: Text(
        'Deadlines Statistics',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget statisticsData(double first, double second) {
    int oneWeekDue = 0;
    int oneMonthDue = 0;
    int expired = 0;

    for (int i = 0; i < eventsList.length; i++) {
      if (eventsList[i].getDurationToDueDate() == 1) {
        oneWeekDue++;
        oneMonthDue++;
      } else if (eventsList[i].getDurationToDueDate() == 2) {
        oneMonthDue++;
      } else if (eventsList[i].getDurationToDueDate() == 0) {
        expired++;
      }
    }

    return Positioned(
      top: first,
      left: second,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Number of Deadlines: ${eventsList.length}',
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.black.withOpacity(1.0),
            ),
          ),
          Text(
            'Expired: $expired',
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.black.withOpacity(1.0),
            ),
          ),
          Text(
            'Due in 1 week: $oneWeekDue',
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.black.withOpacity(1.0),
            ),
          ),
          Text(
            'Due in 1 month: $oneMonthDue',
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.black.withOpacity(1.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget bellPicture(double first, double second) {
    return Positioned(
      top: first,
      right: second,
      child: Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/trend2.png'),
          ),
        ),
      ),
    );
  }

  Widget deadlinesTitle(double first, double second) {
    return Positioned(
      top: first,
      left: second,
      child: Text(
        'Other Deadlines',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget deadlinesData(double first, double second, BuildContext context,
      MyUser user, DocumentSnapshot? snapshot) {
    return Positioned(
      bottom: first,
      left: second,
      child: Container(
        height: 390,
        width: 355,
        //decoration: BoxDecoration(color: Colors.red), // debug purpose
        child: ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: eventsList.length,
            itemBuilder: (context, index) {
              return eventCard(
                  index, context, (tileColor.length), user, snapshot);
            }),
      ),
    );
  }

  Widget eventCard(int index, BuildContext context, int maxCount, MyUser user,
      DocumentSnapshot? snapshot) {
    DeadlinesEvent event = eventsList.elementAt(index);
    String title = event.getTitle;
    DateTime dueDate = event.getDueDateTime;
    String place = ifAbsent(event.getPlace) ? 'None' : event.getPlace;

    // for tile color
    if (count == maxCount - 1) {
      count = 0;
    } else {
      count++;
    }

    return Card(
      color: tileColor[count],
      child: Container(
        constraints: BoxConstraints(
          // adjust height of small rect boxes tgt with sizedbox height
          minHeight: 80,
        ),
        child: SizedBox(
          height: 80,
          child: Stack(children: <Widget>[
            Positioned(
              top: 5,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(height: 3),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.timer,
                        color: timerIcon,
                      ),
                      Text(
                          '${Utils.dateOfDay(dueDate)} ${Utils.monthOfDayInWords(dueDate)}, ${Utils.dayOfWeekConvert(dueDate)}, ${Utils.timeInAMPM(dueDate)}'),
                    ],
                  ),
                  SizedBox(height: 1),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: locationIcon,
                      ),
                      Text('$place'),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 13,
              right: 45,
              child: IconButton(
                  icon: Icon(
                    Icons.info,
                    color: infoIcon,
                  ),
                  onPressed: () async {
                    final DeadlinesEvent newEvent = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DeadlinesView(event)),
                    );

                    // change information on listTile for the deadlines
                    setState(() {
                      if (newEvent != null) {
                        eventsList[index] = newEvent;
                      }
                    });
                  }),
            ),
            Positioned(
              top: 13,
              right: 10,
              child: IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: deleteIcon,
                  ),
                  onPressed: () async {
                    await DatabaseService(uid: user.uid)
                        .deleteUserDeadlines(event, snapshot);
                  }),
            ),
          ]),
        ),
      ),
    );
  }

  Widget addButton(
      double first, double second, MyUser user, DocumentSnapshot? snapshot) {
    return Positioned(
      top: first,
      left: second,
      child: FloatingActionButton(
        backgroundColor: Colors.brown,
        onPressed: () {
          _addNewData(context, user, snapshot);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // add new data via async in the submission page
  void _addNewData(
      BuildContext context, MyUser user, DocumentSnapshot? snapshot) async {
    // change
    final DeadlinesEvent event = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DeadlinesAdd()),
    );

    // add event to a new listTile
    if (event != null) {
      await DatabaseService(uid: user.uid).updateUserDeadlines(event, snapshot);
    }
  }

  Widget clearButton(double first, double second, MyUser user) {
    return Positioned(
      top: first,
      left: second,
      child: FloatingActionButton(
        backgroundColor: Colors.brown,
        onPressed: () async {
          await DatabaseService(uid: user.uid).deleteAllUserDeadlines();
        },
        child: Icon(Icons.delete),
      ),
    );
  }

  // if place input is empty, screen prints 'None' instead
  bool ifAbsent(String text) {
    if (text == '') {
      return true;
    } else {
      return false;
    }
  }
}
