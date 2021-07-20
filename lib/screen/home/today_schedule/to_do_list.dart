import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:schedule_neuron/model/drop_down_item.dart';
import 'package:schedule_neuron/model/drop_down_list.dart';
import 'package:schedule_neuron/model/my_user.dart';
import 'package:schedule_neuron/screen/home/calendar/calendar_event.dart';
import 'package:schedule_neuron/screen/home/calendar/firebase_list.dart';
import 'package:schedule_neuron/screen/home/credits.dart';
import 'package:schedule_neuron/screen/home/deadlines/firebase_list_deadlines.dart';
import 'package:schedule_neuron/service/auth.dart';
import 'package:schedule_neuron/service/database.dart';
import 'package:schedule_neuron/service/utils.dart';
import 'package:schedule_neuron/shared/hex_color.dart';
import 'package:schedule_neuron/shared/loading.dart';

// manages the schedule of user for the day (page)
class ToDoList extends StatelessWidget {
  final AuthService _auth = AuthService(); // app-bar method
  CalendarEvent debugEvent = CalendarEvent(
      "Orbital", DateTime.now(), DateTime.now(), "Zoom", "ABC"); // debug event
  List<CalendarEvent> scheduleList = [];
  int numOfEvents = 0;
  int numOfDeadlines = 0;

  // obtaining the 7 days in a week
  final threeDaysAgo = DateTime.now().subtract(Duration(hours: 72));
  final twoDaysAgo = DateTime.now().subtract(Duration(hours: 48));
  final yesterday = DateTime.now().subtract(Duration(hours: 24));
  final today = DateTime.now();
  final tomorrow = DateTime.now().add(Duration(hours: 24));
  final twoDaysLater = DateTime.now().add(Duration(hours: 48));
  final threeDaysLater = DateTime.now().add(Duration(hours: 72));

  // design related variables
  final HexColor backgroundColor = HexColor('#FFF9EB'); // light yellow
  final HexColor headerColor = HexColor('000000'); // black
  final HexColor dateBoxTopColor =
      HexColor('#F9BE7C'); // 7 days in a row - orange
  final HexColor dateBoxBtmColor =
      HexColor('#FDFEFE'); // Day, Month and Day BG- white color
  final HexColor dateDayTextColor =
      HexColor('#17202A'); // Day, Month and Day- dark blue
  final HexColor fromTimeColor =
      HexColor('#A6ACAF'); // From timing at bottom - grey
  final HexColor toTimeColor =
      HexColor('#95A5A6'); // To timing at bottom - grey-green
  final HexColor placeColor =
      HexColor('#99A3A4'); // place at the bottom - dark grey
  final HexColor boxTextColor =
      HexColor('#1C2833'); // DateTime.now() color in white BG - dark green
  final HexColor statisticsContainerColor = HexColor(
      '#76D7C4'); // color of background of first event in top container

  final List<String> detailBoxColorList = [
    '#EC7063',
    '#6BB2F3',
    '#F3C06B',
    '#F7DC6F',
    '#D7BDE2',
  ];
  var count = 0;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

    // debug purpose
    //scheduleList.add(debugEvent);

    // listens to firestore DEADLINE stream and rebuilds widget if there are changes
    return StreamBuilder<DocumentSnapshot>(
      stream: DatabaseService(uid: user.uid).userDeadlines,
      builder: (context, deadlineSnapshot) {
        if (deadlineSnapshot.hasData) {
          // listens to firestore stream and rebuilds widget if there are changes
          return StreamBuilder<DocumentSnapshot>(
              stream: DatabaseService(uid: user.uid).userEvents,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // build map based on firebase data
                  List<CalendarEvent> buildList() {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    DateTime todaysDate = Utils.toSelectedDay(DateTime.now());
                    List<CalendarEvent> returnList = [];
                    String string = dateFormat.format(todaysDate);
                    try {
                      List<dynamic> list = data[string];
                      FirebaseList firebaseList = FirebaseList.fromList(list);
                      returnList = firebaseList.eventsList;
                    } catch (e) {}
                    numOfEvents = returnList.length;
                    // from deadlines collection
                    Map<String, dynamic> deadlineData =
                        deadlineSnapshot.data!.data() as Map<String, dynamic>;
                    List<CalendarEvent> tempList = [];
                    try {
                      List<dynamic> list = deadlineData['deadlines'];
                      FirebaseListDeadlines firebaseListDeadlines =
                          FirebaseListDeadlines.fromList(list);
                      tempList = firebaseListDeadlines.toCalendarEventsList();
                    } catch (e) {}
                    // loop through the deadlines list
                    for (CalendarEvent event in tempList) {
                      if (Utils.toSelectedDay(event.fromDate) == todaysDate) {
                        returnList.add(event);
                      }
                    }
                    numOfDeadlines = returnList.length - numOfEvents;
                    return returnList;
                  }

                  // modify scheduleList based on firestore data
                  scheduleList = buildList();

                  // sort events based on fromDateTime
                  scheduleList.sort((firstDate, secondDate) => firstDate
                      .getFromDateTime
                      .compareTo(secondDate.getFromDateTime));

                  return MaterialApp(
                    home: Scaffold(
                      backgroundColor: backgroundColor,
                      body: Stack(
                        children: <Widget>[
                          pageHeader(75, 40), // top-left
                          topContainer(150, 50), // top-left
                          detailsContainer(420, 50, context), // top-left
                          eventHeaderRow(370, 50), // top-left
                          menuBar(context, _auth, 65, 20) // top-right
                        ],
                      ),
                    ),
                  );
                } else {
                  return Loading();
                }
              });
        } else {
          return Loading();
        }
      },
    );
  }

  Widget pageHeader(double first, double second) {
    return Positioned(
      top: first,
      left: second,
      child: Row(
        children: <Widget>[
          Text(
            'Today Schedule',
            style: TextStyle(
              color: headerColor,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(width: 70),
        ],
      ),
    );
  }

  // menu bar at top right
  Widget menuBar(
      BuildContext context, AuthService _auth, double first, double second) {
    return Positioned(
      top: first,
      right: second,
      child: PopupMenuButton<DropDownItem>(
        onSelected: (item) => onSelected(context, item, _auth),
        itemBuilder: (context) => [
          ...DropDownList.itemsFirst.map(buildItem).toList(),
          PopupMenuDivider(),
          ...DropDownList.itemsSecond.map(buildItem).toList(),
        ],
      ),
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

  Widget topContainer(double first, double second) {
    return Positioned(
      top: first,
      left: second,
      child: Container(
        constraints: BoxConstraints(
          minHeight: 190,
          minWidth: 300,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              dateBoxTopColor,
              dateBoxBtmColor,
            ],
            stops: [0.38, 0.38],
          ),
        ),
        alignment: Alignment.topCenter,
        child: Stack(
          children: <Widget>[
            // white background behind today
            Positioned(
              top: 10,
              left: 113,
              child: Opacity(
                opacity: 0.7,
                child: Container(
                  height: 65,
                  width: 40,
                  child: Text(''),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0)),
                  ),
                ),
              ),
            ),
            // the 7 days of the week
            Column(
              children: <Widget>[
                SizedBox(height: 15.0), // area above the date
                Row(
                  children: <Widget>[
                    dayColumn(
                        '${Utils.dateOfDay(threeDaysAgo)}',
                        '${Utils.dayOfWeekConvert(threeDaysAgo)}',
                        false), // bool for isToday
                    SizedBox(width: 10.0),
                    dayColumn(
                        '${Utils.dateOfDay(twoDaysAgo)}',
                        '${Utils.dayOfWeekConvert(twoDaysAgo)}',
                        false), // bool for isToday
                    SizedBox(width: 10.0),
                    dayColumn(
                        '${Utils.dateOfDay(yesterday)}',
                        '${Utils.dayOfWeekConvert(yesterday)}',
                        false), // bool for isToday
                    SizedBox(width: 10.0),
                    dayColumn(
                        '${Utils.dateOfDay(today)}',
                        '${Utils.dayOfWeekConvert(today)}',
                        true), // bool for isToday
                    SizedBox(width: 10.0),
                    dayColumn(
                        '${Utils.dateOfDay(tomorrow)}',
                        '${Utils.dayOfWeekConvert(tomorrow)}',
                        false), // bool for isToday
                    SizedBox(width: 10.0),
                    dayColumn(
                        '${Utils.dateOfDay(twoDaysLater)}',
                        '${Utils.dayOfWeekConvert(twoDaysLater)}',
                        false), // bool for isToday
                    SizedBox(width: 10.0),
                    dayColumn(
                        '${Utils.dateOfDay(threeDaysLater)}',
                        '${Utils.dayOfWeekConvert(twoDaysLater)}',
                        false), // bool for isToday
                  ],
                ),
                SizedBox(height: 25.0), // area between the 2 colors
                todayDetails(),
              ],
            ),
            // green bar at the bottom of today
            Positioned(
                top: 65,
                left: 113,
                child: Container(
                  height: 7,
                  width: 41,
                  color: Colors.green,
                  child: Text(''),
                )),
          ],
        ),
      ),
    );
  }

  // text of the 7 day show in the orange column
  Widget dayColumn(String date, String day, bool isToday) {
    return Column(
      children: <Widget>[
        Text(
          date,
          style: TextStyle(
            fontSize: 17,
            color: dateDayTextColor,
            fontWeight: isToday ? FontWeight.bold : null,
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          day,
          style: TextStyle(
            fontSize: 14,
            color: dateDayTextColor,
            fontWeight: isToday ? FontWeight.bold : null,
          ),
        ),
      ],
    );
  }

  // handles the entire white container
  Widget todayDetails() {
    return Container(
      height: 100,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              dayDetails(),
              SizedBox(width: 20),
              statisticsContainer(),
            ],
          ),
        ],
      ),
    );
  }

  // day, date and month in big text in white container
  Widget dayDetails() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10),
        Text(
          Utils.dateOfDay(today),
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: boxTextColor,
          ),
        ),
        SizedBox(height: 0),
        Text(
          Utils.dayOfWeekConvert(today),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: boxTextColor,
          ),
        ),
      ],
    );
  }

  // statistics in green container
  Widget statisticsContainer() {
    return Column(
      children: <Widget>[
        Container(
          constraints: BoxConstraints(
            minHeight: 100,
            minWidth: 200,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            shape: BoxShape.rectangle,
            color: statisticsContainerColor,
          ),
          child: Row(children: <Widget>[
            SizedBox(width: 8),
            Container(
                constraints: BoxConstraints(
                  minHeight: 70,
                  minWidth: 180,
                ),
                //decoration: BoxDecoration(color: Colors.red), // debug purpose
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10),
                        Icon(Icons.calendar_today),
                        SizedBox(width: 10),
                        Text(
                          'Total Events: ${scheduleList.length}',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10),
                        Icon(Icons.light),
                        SizedBox(width: 10),
                        Text(
                          'Events: $numOfEvents',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10),
                        Icon(Icons.access_alarm),
                        SizedBox(width: 10),
                        Text(
                          'Deadlines:  $numOfDeadlines',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ],
                )),
          ]),
        ),
      ],
    );
  }

  // other events row
  Widget eventHeaderRow(double first, double second) {
    return Positioned(
      top: first,
      left: second,
      child: Text(
        'Other Events',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // eventName-fromTime-toTime-Place
  Widget detailsHeaderRow(double first, double second) {
    return Positioned(
      top: first,
      left: second,
      child: Row(
        children: <Widget>[
          Text(
            'Event Name',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          SizedBox(width: 50),
          Text(
            'From',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          SizedBox(width: 25),
          Text(
            'To',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          SizedBox(width: 25),
          Text(
            'Venue',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget detailsContainer(double first, double second, BuildContext context) {
    return Positioned(
      top: first,
      left: second,
      child: Container(
        constraints: BoxConstraints(
          minHeight: 295,
          minWidth: 310,
        ),
        //decoration: BoxDecoration(color: Colors.red), // debug
        child: SizedBox(
          height: 80,
          width: 80,
          child: ListView.builder(
            itemCount: scheduleList.length,
            padding: EdgeInsets.all(3),
            itemBuilder: (BuildContext context, int index) {
              if (count == detailBoxColorList.length - 1) {
                count = 0;
              } else {
                count++;
              }
              return Container(
                constraints: BoxConstraints(
                  minHeight: 70,
                ),
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 13),
                    SizedBox(
                      // to prevet error from putting a stack inside
                      height: 25,
                      width: 25,
                      child: Stack(
                        children: <Widget>[
                          Opacity(
                            opacity: 0.7,
                            child: Container(
                              constraints: BoxConstraints(
                                minHeight: 25,
                                minWidth: 25,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  shape: BoxShape.rectangle,
                                  color: HexColor('#FDFEFE'),
                                  border: Border.all(
                                    color: HexColor(detailBoxColorList[count]),
                                    width: 1.0,
                                  )),
                              child: Text(''),
                            ),
                          ),
                          Positioned(
                            top: 4.8,
                            left: 4.8,
                            child: Container(
                              constraints: BoxConstraints(
                                minHeight: 15,
                                minWidth: 15,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3.0)),
                                  shape: BoxShape.rectangle,
                                  color: HexColor(detailBoxColorList[count])),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    middleContent(index),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget middleContent(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '${scheduleList.elementAt(index).getTitle}',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        bottomRowDisplay(index),
      ],
    );
  }

  Widget bottomRowDisplay(int index) {
    return Row(
      children: <Widget>[
        Container(
          constraints: BoxConstraints(
            minHeight: 20,
            minWidth: 70,
          ),
          decoration: BoxDecoration(
            color: fromTimeColor,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            shape: BoxShape.rectangle,
          ),
          child: Center(
              child: Text(
                  '${Utils.timeInAMPM(scheduleList.elementAt(index).getFromDateTime)}',
                  style: TextStyle(color: Colors.black))),
        ),
        SizedBox(width: 10),
        Container(
          constraints: BoxConstraints(
            minHeight: 20,
            minWidth: 70,
          ),
          decoration: BoxDecoration(
            color: toTimeColor,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            shape: BoxShape.rectangle,
          ),
          child: Center(
              child: Text(
                  '${Utils.timeInAMPM(scheduleList.elementAt(index).getToDateTime)}',
                  style: TextStyle(color: Colors.black))),
        ),
        SizedBox(width: 10),
        Container(
          constraints: BoxConstraints(
            minHeight: 20,
            minWidth: 80,
          ),
          decoration: BoxDecoration(
            color: placeColor,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            shape: BoxShape.rectangle,
          ),
          child: Center(
              child: Text('${ifAbsent(scheduleList.elementAt(index).getPlace)}',
                  style: TextStyle(color: Colors.black))),
        ),
      ],
    );
  }

  // if place input is empty, screen prints 'None' instead
  String ifAbsent(String text) {
    if (text == '') {
      return 'None';
    } else {
      return text;
    }
  }
}
