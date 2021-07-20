import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:schedule_neuron/model/drop_down_item.dart';
import 'package:schedule_neuron/model/drop_down_list.dart';
import 'package:schedule_neuron/model/my_user.dart';
import 'package:schedule_neuron/screen/home/calendar/calendar_add_page.dart';
import 'package:schedule_neuron/screen/home/calendar/calendar_event.dart';
import 'package:schedule_neuron/screen/home/calendar/calendar_view.dart';
import 'package:schedule_neuron/screen/home/calendar/firebase_list.dart';
import 'package:schedule_neuron/screen/home/credits.dart';
import 'package:schedule_neuron/screen/home/deadlines/firebase_list_deadlines.dart';
import 'package:schedule_neuron/service/auth.dart';
import 'package:schedule_neuron/service/database.dart';
import 'package:schedule_neuron/service/utils.dart';
import 'package:schedule_neuron/shared/hex_color.dart';
import 'package:schedule_neuron/shared/loading.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:core';

// handles the calendar page
class Calendar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CalendarState();
  }
}

class CalendarState extends State<Calendar> {
  final AuthService _auth = AuthService(); // log-out related variable
  CalendarFormat format = CalendarFormat.month; // determine view of calendar
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  late Map<DateTime, List<CalendarEvent>> selectedEvents;
  TextEditingController _textController = TextEditingController();

  // design related variables
  // color of event container
  final List<Color> eventTileColor = [
    Colors.green.shade50,
    Colors.blue.shade50,
    Colors.red.shade50,
    Colors.yellow.shade50,
    Colors.orange.shade50,
  ];
  var colorCount = 0; // to change color of event container
  final pageHeaderColor = HexColor('#000000'); // 'Calendar' Text (black)
  final pageBackgroundColor =
      HexColor('#FFF9EB'); // Scaffold Background Color (light yellow)
  final selectedDayColor =
      HexColor('#E46471'); // Color of day selected by user  (pinkish red)
  final todayColor = HexColor('#6487E4'); // Color of 'today (light blue)
  final toggleMonthWeekColor =
      HexColor('#F9BE7C'); // Color of calendar format toggle (orange)
  final HexColor eventIconColor =
      HexColor('#6E2C00'); // event icon at the front of event container
  final HexColor timerIconColor =
      HexColor('#444974'); // timer icon at the front of event container
  final HexColor locationIconColor =
      HexColor('#E74C3C'); // event icon at the front of event container
  final HexColor infoIconColor =
      HexColor('#FFD756'); // event icon at the front of event container
  final HexColor deleteIconColor =
      HexColor('#7B7D7D'); // event icon at the front of event container

  @override
  void initState() {
    super.initState();
    selectedEvents = {};
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

    // listens to firestore DEADLINE stream and rebuilds widget if there are changes
    return StreamBuilder<DocumentSnapshot>(
      stream: DatabaseService(uid: user.uid).userDeadlines,
      builder: (context, deadlineSnapshot) {
        if (deadlineSnapshot.hasData) {
          // listens to firestore EVENT stream and rebuilds widget if there are changes
          return StreamBuilder<DocumentSnapshot>(
              stream: DatabaseService(uid: user.uid).userEvents,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  //build map based on firebase data
                  Map<DateTime, List<CalendarEvent>> buildMap() {
                    // from events collection
                    Map eventData = snapshot.data!.data() as Map;
                    Map<DateTime, List<CalendarEvent>> map = {};
                    try {
                      for (String key in eventData.keys) {
                        List<dynamic> list = eventData[key];
                        FirebaseList firebaseList = FirebaseList.fromList(list);
                        // sort events list based on fromDate
                        firebaseList.eventsList.sort((firstDate, secondDate) =>
                            firstDate.getFromDateTime
                                .compareTo(secondDate.getFromDateTime));
                        map[dateFormat.parse(key)] = firebaseList.eventsList;
                      }
                    } catch (e) {}
                    // from deadlines collection
                    Map<String, dynamic> deadlineData =
                        deadlineSnapshot.data!.data() as Map<String, dynamic>;
                    List<CalendarEvent> returnList = [];
                    try {
                      List<dynamic> list = deadlineData['deadlines'];
                      FirebaseListDeadlines firebaseListDeadlines =
                          FirebaseListDeadlines.fromList(list);
                      returnList = firebaseListDeadlines.toCalendarEventsList();
                    } catch (e) {}
                    // loop through the deadlines list and add them to the correct map key
                    for (CalendarEvent event in returnList) {
                      List<CalendarEvent>? list =
                          map[Utils.toSelectedDay(event.fromDate)];
                      if (list != null) {
                        map[Utils.toSelectedDay(event.fromDate)]!.add(event);
                      } else {
                        map[Utils.toSelectedDay(event.fromDate)] = [event];
                      }
                    }
                    return map;
                  }

                  // modify selectedEvents based on firestore data
                  selectedEvents = buildMap();

                  // event builder method
                  List<CalendarEvent> _getEventsFromDay(DateTime date) {
                    // first 2 statements to get rid of the 'Z' character at the end
                    String string = dateFormat.format(date);
                    date = dateFormat.parse(string);
                    return selectedEvents[date] ?? [];
                  }

                  return Scaffold(
                    backgroundColor: pageBackgroundColor,
                    body: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(height: 60),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 30),
                            pageHeader(80, 30), // top-left
                            SizedBox(width: 170),
                            menuBar(context, _auth), // top-right
                          ],
                        ),
                        TableCalendar(
                          focusedDay: selectedDay,
                          firstDay: DateTime(
                              1990), // first day user is able to choose
                          lastDay:
                              DateTime(2050), // last day user is able to choose
                          startingDayOfWeek: StartingDayOfWeek
                              .monday, // shows monday as the first day of every week
                          daysOfWeekVisible: true,

                          // Calendar Format
                          calendarFormat: format,
                          onFormatChanged: (_format) {
                            setState(() {
                              format = _format;
                            });
                          },

                          // Day Changed (to enable different color of selected day when pressed)
                          selectedDayPredicate: (day) {
                            return isSameDay(selectedDay, day);
                          },

                          onDaySelected: (selectDay, focusDay) {
                            setState(() {
                              selectedDay = selectDay;
                              focusedDay = focusDay;
                            });
                          },

                          // To style the Calendar
                          calendarStyle: CalendarStyle(
                            isTodayHighlighted: true,

                            // customize design of selected day when selected by user
                            selectedDecoration: BoxDecoration(
                              color: selectedDayColor,
                              shape: BoxShape.circle,
                            ),
                            selectedTextStyle: TextStyle(
                              color: Colors.white,
                            ),

                            // customize design of 'today'
                            todayDecoration: BoxDecoration(
                              color: todayColor,
                              shape: BoxShape.circle,
                            ),
                          ),

                          // To style the Header
                          headerStyle: HeaderStyle(
                            titleCentered: true,
                            formatButtonShowsNext: false,
                            formatButtonDecoration: BoxDecoration(
                              color: toggleMonthWeekColor,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            formatButtonTextStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          eventLoader: _getEventsFromDay,
                        ),
                        SizedBox(
                          height: 280,
                          width: 390,
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                top: 0,
                                left: 40,
                                child: Container(
                                  constraints: BoxConstraints(
                                    minHeight: 270,
                                    maxHeight: 270,
                                    minWidth: 300,
                                    maxWidth: 300,
                                  ),
                                  decoration: BoxDecoration(
                                      //color: Colors.red, // debug purpose
                                      ),
                                  child: ListView.builder(
                                      padding: EdgeInsets.all(8),
                                      itemCount:
                                          _getEventsFromDay(selectedDay).length,
                                      itemBuilder: (context, index) {
                                        return eventCard(
                                            index,
                                            context,
                                            (eventTileColor.length),
                                            _getEventsFromDay(selectedDay),
                                            user,
                                            snapshot.data);
                                      }),
                                ),
                              ),
                              // adjust position of add button at the bottom
                              Positioned(
                                bottom: 70,
                                right: 10,
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(width: 310),
                                    FloatingActionButton(
                                      child: Icon(Icons.add),
                                      backgroundColor: Colors.brown,
                                      onPressed: () => _addEvent(
                                          selectedDay, user, snapshot.data),
                                    ),
                                  ],
                                ),
                              ),
                              // adjust position of clear button at the bottom
                              Positioned(
                                bottom: 0,
                                right: 10,
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(width: 310),
                                    FloatingActionButton(
                                      child: Icon(Icons.delete),
                                      backgroundColor: Colors.brown,
                                      onPressed: () async {
                                        await DatabaseService(uid: user.uid)
                                            .deleteAllUserEventsOnDay(
                                                selectedDay);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

  // Page Title - 'Calendar'
  Widget pageHeader(double first, double second) {
    return Text(
      'Calendar',
      style: TextStyle(
        color: pageHeaderColor,
        fontSize: 28,
        fontWeight: FontWeight.w800,
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

  // handles the change of events when user press the done button
  _addEvent(
      DateTime selectedDay, MyUser user, DocumentSnapshot? snapshot) async {
    var event = CalendarEvent(
        '', selectedDay, selectedDay, '', ''); // inital dummy event

    final CalendarEvent newEvent = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CalendarAdd(event)),
    );
    if (newEvent != null) {
      await DatabaseService(uid: user.uid)
          .updateUserEvents(selectedDay, newEvent, snapshot);
    }
  }

  // handles individual event label at the bottom, event - event icon, deadlines - TBD icon
  Widget eventCard(int index, BuildContext context, int maxCount,
      List<CalendarEvent> eventsList, MyUser user, DocumentSnapshot? snapshot) {
    if (colorCount == maxCount - 1) {
      colorCount = 0;
    } else {
      colorCount++;
    }

    return Card(
      color: eventTileColor[colorCount],
      child: Container(
        constraints: BoxConstraints(
          // adjust height of small rect boxes tgt with sizedbox height
          minHeight: 80,
        ),
        child: SizedBox(
          // adjust height of small rect boxes tgt with container minheight
          height: 80,
          child: Stack(children: <Widget>[
            Positioned(
              top: 20,
              left: 8,
              child: Icon(
                Icons.event,
                size: 35,
                color: eventIconColor,
              ),
            ),
            Positioned(
              top: 5,
              left: 52,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    eventsList.elementAt(index).getTitle,
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(height: 3),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.timer,
                        color: timerIconColor,
                      ),
                      // PM to be changed
                      Text(
                          '${Utils.timeInAMPM(eventsList.elementAt(index).getFromDateTime)}-${Utils.timeInAMPM(eventsList.elementAt(index).getToDateTime)}'),
                    ],
                  ),
                  SizedBox(height: 1),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: locationIconColor,
                      ),
                      Text(ifAbsent(eventsList.elementAt(index).getPlace)
                          ? 'None'
                          : '${eventsList.elementAt(index).getPlace}'),
                    ],
                  ),
                ],
              ),
            ),
            // handles info icon of each event
            Positioned(
              top: 13,
              right: 30,
              child: IconButton(
                  icon: Icon(
                    Icons.info,
                    color: infoIconColor,
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CalendarView(eventsList.elementAt(index))),
                    );
                  }),
            ),
            // handles delete icon of each event
            Positioned(
              top: 13,
              right: 0,
              child: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: deleteIconColor,
                ),
                onPressed: () async {
                  await DatabaseService(uid: user.uid).deleteUserEvents(
                      selectedDay, eventsList.elementAt(index), snapshot);
                },
              ),
            ),
          ]),
        ),
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
