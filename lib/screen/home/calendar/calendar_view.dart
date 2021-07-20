import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:schedule_neuron/screen/home/calendar/calendar_edit_page.dart';
import 'package:schedule_neuron/screen/home/calendar/calendar_event.dart';
import 'package:schedule_neuron/service/utils.dart';
import 'package:schedule_neuron/shared/hex_color.dart';

// to see details of each to-do (calendar) event made in detail
class CalendarView extends StatefulWidget {
  CalendarEvent event;

  CalendarView(this.event);

  @override
  State<StatefulWidget> createState() {
    return CalendarViewState();
  }
}

class CalendarViewState extends State<CalendarView> {
  // design related variables
  final HexColor backgroundColor = HexColor('#FFF9EB'); // light yellow
  final HexColor topContainerColor = HexColor('#F9BE7C'); // orange
  final HexColor leftContainerColor = HexColor('#309398'); // green
  final HexColor rightContainerColor = HexColor('#E46471'); // pinkish red
  final HexColor timerColor = HexColor('#FFFFFF'); // white
  final HexColor fromLogoColor = HexColor('#E46471'); // pinkish red
  final HexColor toLogoColor = HexColor('#A569BD'); // purple
  final HexColor placeLogoColor = HexColor('#F9BE7B'); // orange
  final HexColor detailsLogoColor = HexColor('#6487E4'); // blue

  @override
  Widget build(BuildContext context) {
    CalendarEvent event = widget.event;

    // time diff between now and start time
    final diffStart = Utils.timeDiff(event.getFromDateTime, DateTime.now());
    final dayStart = diffStart.inDays;
    final hourStart = (diffStart - Duration(hours: (dayStart * 24))).inHours;
    final minStart = (diffStart -
            Duration(minutes: (dayStart * 24 * 60)) -
            Duration(minutes: (hourStart * 60)))
        .inMinutes;

    String startDayText = (dayStart > 0) ? '$dayStart' : '0';
    String startHourText = (hourStart > 0) ? '$hourStart' : '0';
    String startMinText = (minStart > 0) ? '$minStart' : '0';

    // time diff between now and end time
    final diffEnd = Utils.timeDiff(event.getToDateTime, DateTime.now());
    final dayEnd = diffEnd.inDays;
    final hourEnd = (diffEnd - Duration(hours: (dayEnd * 24))).inHours;
    final minEnd = (diffEnd -
            Duration(minutes: (dayEnd * 24 * 60)) -
            Duration(minutes: (hourEnd * 60)))
        .inMinutes;

    String endDayText = (dayEnd > 0) ? '$dayEnd' : '0';
    String endHourText = (hourEnd > 0) ? '$hourEnd' : '0';
    String endMinText = (minEnd > 0) ? '$minEnd' : '0';

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: <Widget>[
          topContainer(0, 0), // top-right
          leftContainer(175, 40), // top-left
          rightContainer(175, 40), // top-right
          pageHeader(85, 45, event.getTitle), // top-left
          timeCounterHeader(145, 46), // top-left
          timeRemaining(195, 60, startDayText, startHourText,
              startMinText), // top-left: shows time left till event start
          timeRemaining(195, 220, endDayText, endHourText,
              endMinText), // top-left: time left till event end
          detailsHeader(390, 40), // top-left
          descriptionTitle(430, 105, 'From'), // top-left-text: from time
          descriptionTitle(490, 105, 'To'), // top-left-text: to time
          descriptionTitle(550, 105, 'Location'), // top-left-text: place
          descriptionTitle(610, 105, 'Details'), // top-left-text: description
          logo(430, 45, Icons.timer,
              fromLogoColor), // top-left-iconData: from time
          logo(490, 45, Icons.timer, toLogoColor), // top-left-iconData: to time
          logo(550, 45, Icons.location_city_sharp,
              placeLogoColor), // top-left-iconData: place
          logo(610, 45, Icons.event_note,
              detailsLogoColor), // top-left-iconData: description
          descriptionSubtitle(455, 105, 'START TIME'), // top-left
          descriptionSubtitle(515, 105, 'END TIME'), // top-left
          descriptionSubtitle(575, 105, 'EVENT VENUE'), // top-left
          userInput(440, 245,
              Utils.timeInAMPM(event.getFromDateTime)), // top-left // from time
          userInput(500, 245,
              Utils.timeInAMPM(event.getToDateTime)), // top-left // to time
          userInput(557, 247, event.getPlace), // top-left // location
          descriptionSubtitle(635, 105, 'THE DETAILS ARE AS BELOW'), // top-left
          detailsContainerNText(
              670, 50, event.getDetails), // top-left // location
          closeButton(
              745, 100, event), // top-left // to navigate back to calendar page
          editButton(745, 220,
              event), // top-right // to navigate back to calendar edit page
        ],
      ),
    );
  }

  Widget topContainer(double first, double second) {
    return Positioned(
      top: first,
      right: second,
      child: Container(
        width: 412.0,
        height: 360.0,
        decoration: BoxDecoration(
          color: topContainerColor,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40.0),
              bottomRight: Radius.circular(40.0)),
        ),
      ),
    );
  }

  Widget leftContainer(double first, double second) {
    return Positioned(
      top: first,
      left: second,
      child: Container(
        width: 155.0,
        height: 160.0,
        decoration: BoxDecoration(
          color: leftContainerColor,
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }

  Widget rightContainer(double first, double second) {
    return Positioned(
      top: first,
      right: second,
      child: Container(
        width: 155.0,
        height: 160.0,
        decoration: BoxDecoration(
          color: rightContainerColor,
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }

  Widget pageHeader(double first, double second, String title) {
    return Positioned(
      top: first,
      left: second,
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              //color: HexColor('#1F618D'),
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(width: 50),
        ],
      ),
    );
  }

  Widget timeCounterHeader(double first, double second) {
    return Positioned(
      top: first,
      left: second,
      child: Row(
        children: <Widget>[
          Text(
            'Time till Start',
            style: TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(width: 65),
          Text(
            'Time till End',
            style: TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget timeRemaining(
      double first, double second, String day, String hour, String min) {
    return Positioned(
      top: first,
      left: second,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          timer(day, 'day(s)'),
          SizedBox(height: 10),
          timer(hour, 'hr(s)'),
          SizedBox(height: 10),
          timer(min, 'min(s)'),
        ],
      ),
    );
  }

  // Day-Min-Sec Timer
  Widget timer(String timePeriod, String syntax) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        DottedBorder(
          color: Colors.black,
          strokeWidth: 2,
          child: Container(
            constraints: BoxConstraints(
              minHeight: 30,
              minWidth: 30,
            ),
            child: Center(
              child: Text(timePeriod,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  )),
            ),
          ),
        ),
        SizedBox(width: 15),
        Text(syntax, // day(s), hr(s), min(s)
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black,
            ))
      ],
    );
  }

  Widget detailsHeader(double first, double second) {
    return Positioned(
      top: first,
      left: second,
      child: Text(
        'Description',
        style: TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  // Text 'FROM', 'TO', 'LOCATION', 'DETAILS'
  Widget descriptionTitle(double first, double second, String text) {
    return Positioned(
      top: first,
      left: second,
      child: Text(
        text,
        style: TextStyle(
          color: HexColor('#212F3D'), // navy blue
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget logo(double first, double second, IconData icon, HexColor color) {
    return Positioned(
      top: first,
      left: second,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: Icon(icon, size: 33, color: Colors.white),
      ),
    );
  }

  Widget descriptionSubtitle(double first, double second, String text) {
    return Positioned(
      top: first,
      left: second,
      child: Opacity(
        opacity: 0.7,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget userInput(double first, double second, String text) {
    return Positioned(
      top: first,
      left: second,
      child: Text(
        _ifAbsent(text),
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget detailsContainerNText(double first, double second, String text) {
    return Positioned(
      top: first,
      left: second,
      child: Container(
        constraints: BoxConstraints(
          minHeight: 75,
          minWidth: 300,
          maxHeight: 75,
          maxWidth: 300,
        ),
        decoration: BoxDecoration(
            //color: Colors.red, // debug purpose
            ),
        child: Text(
          _ifAbsent(text),
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget closeButton(double first, double second, CalendarEvent event) {
    return Positioned(
      top: first,
      left: second,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pop(context, event);
        },
        icon: Icon(Icons.navigate_before),
        label: Text('Back'),
        style: ElevatedButton.styleFrom(
          primary: Colors.brown,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
        ),
      ),
    );
  }

  Widget editButton(double first, double second, CalendarEvent event) {
    return Positioned(
      top: first,
      left: second,
      child: ElevatedButton.icon(
        onPressed: () {
          setState(() {
            _changeData(context, event);
          });
        },
        icon: Icon(Icons.create),
        label: Text('Edit'),
        style: ElevatedButton.styleFrom(
          primary: Colors.brown,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
        ),
      ),
    );
  }

  // method: leads user to the calendar edit page
  List<Widget> editingActions(BuildContext context, CalendarEvent event) {
    return [
      ElevatedButton.icon(
        onPressed: () {
          setState(() {
            _changeData(context, event);
          });
        },
        icon: Icon(Icons.edit),
        label: Text('Edit'),
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
      ),
    ];
  }

  // method: when user press on the edit button, brings user to edit page
  void _changeData(BuildContext context, CalendarEvent event) async {
    final CalendarEvent newEvent = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CalendarEdit(event)),
    );

    if (newEvent != null) {
      setState(() {
        widget.event = CalendarEvent(
            newEvent.getTitle,
            newEvent.getFromDateTime,
            newEvent.getToDateTime,
            newEvent.getPlace,
            newEvent.getDetails);
      });
    }
  }

  // shows none for place and time if user input is null
  String _ifAbsent(String text) {
    if (text == '') {
      return 'None';
    } else {
      return text;
    }
  }
}
