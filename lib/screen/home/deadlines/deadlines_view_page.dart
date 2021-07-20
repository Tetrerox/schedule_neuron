import 'package:flutter/material.dart';
import 'package:schedule_neuron/screen/home/deadlines/deadlines_edit_page.dart';
import 'package:schedule_neuron/screen/home/deadlines/deadlines_event.dart';
import 'package:schedule_neuron/service/utils.dart';
import 'package:schedule_neuron/shared/hex_color.dart';
import 'package:dotted_border/dotted_border.dart';

// to see details of each deadlines made in detail
class DeadlinesView extends StatefulWidget {
  DeadlinesEvent event;
  DeadlinesView(this.event);

  @override
  State<StatefulWidget> createState() {
    return DeadlinesViewState();
  }
}

class DeadlinesViewState extends State<DeadlinesView> {
  // design related variables
  final HexColor backgroundColor = HexColor('#F9BE7C'); // orange
  final HexColor btmContainerColor = HexColor('#FFF9EB'); //light yellow
  final HexColor timerInnerColor = HexColor('#E46471'); // red-pink
  final HexColor dateLogoColor = HexColor('#E46471'); // red-pink
  final HexColor timeLogoColor = HexColor('#A569BD'); // purple
  final HexColor placeLogoColor = HexColor('#F9BE7B'); // yellow
  final HexColor detailsLogoColor = HexColor('#6487E4'); // blue
  final HexColor dayMinSecColor = HexColor('#1A5276'); // dark blue

  @override
  Widget build(BuildContext context) {
    DeadlinesEvent event = widget.event;

    // output dates in respective strings
    final date =
        '${Utils.dateOfDay(event.getDueDateTime)} ${Utils.monthOfDayInWords(event.getDueDateTime)}, \n${Utils.dayOfWeekConvert(event.getDueDateTime)}';

    // obtaining time difference between two time
    final diff = Utils.timeDiff(event.getDueDateTime, DateTime.now());
    final day = diff.inDays;
    final hour = (diff - Duration(hours: (day * 24))).inHours;
    final min = (diff -
            Duration(minutes: (day * 24 * 60)) -
            Duration(minutes: (hour * 60)))
        .inMinutes;
    
    String dayInput = (day > 0) ? '$day' : '0';
    String hourInput = (hour > 0) ? '$hour' : '0';
    String minInput = (min > 0) ? '$min' : '0';

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: <Widget>[
          bottomContainer(0, 0), // btm-right
          pageHeader(75, 40, event.getTitle), //top-left
          timeRemaining(130, 50, dayInput, hourInput, minInput), // top-left // shows time left till due time
          detailsHeader(295, 40), // top-left
          logo(340, 45, Icons.timer,
              dateLogoColor), // top-left-iconData // from time
          logo(410, 45, Icons.timer,
              timeLogoColor), // top-left-iconData // to time
          logo(480, 45, Icons.location_city_sharp,
              placeLogoColor), // top-left-iconData // place
          logo(550, 45, Icons.event_note,
              detailsLogoColor), // top-left-iconData // description
          descriptionTitle(345, 105, 'Due Date'), // top-left-text // due date
          descriptionTitle(415, 105, 'Due Time'), // top-left-text // due date
          descriptionTitle(
              485, 105, 'Venue'), // top-left-text // submission area
          descriptionTitle(555, 105, 'Details'), // top-left-text // description
          descriptionSubtitle(
              370, 105, 'DATE OF DEADLINE'), // top-left // subtitle of due date
          descriptionSubtitle(
              440, 105, 'TIME OF DEADLINE'), // top-left // subtitle of due time
          descriptionSubtitle(
              510, 105, 'SUBMISSION AREA'), // top-left // subtitle of venue
          descriptionSubtitle(580, 105,
              'THE DETAILS ARE AS BELOW'), // top-left // subtitle of details
          userInput(345, 265, date),
          userInput(
              430,
              265,
              Utils.timeInAMPM(
                  event.getDueDateTime)), // top-left // due time by user input
          userInput(
              500,
              265,
              _ifAbsent(
                  event.getPlace)), // top-left // submission area by user input
          detailsContainerNText(610, 50,
              _ifAbsent(event.getDetails)), // top-left // details by user input
          closeButton(
              690, 100), // top-left // to navigate back to deadlines page
          editButton(
              690, 220), // top-right // to navigate back to deadlines edit page
        ],
      ),
    );
  }

  // light orange bottom container
  Widget bottomContainer(double first, double second) {
    return Positioned(
      bottom: first,
      right: second,
      left: second,
      child: Container(
        height: 510.0,
        width: 500.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)),
          color: HexColor('#FFF9EB'),
          boxShadow: [
            BoxShadow(
              blurRadius: 1.5,
              spreadRadius: 1.5,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }

  // title of event input by user
  Widget pageHeader(double first, double second, String title) {
    return Positioned(
      top: first,
      left: second,
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(width: 50),
        ],
      ),
    );
  }

  // show remaining time beside circle timer
  Widget timeRemaining(
      double first, double second, String day, String hr, String min) {
    return Positioned(
      top: first,
      left: second,
      child: Container(
        constraints: BoxConstraints(
          minHeight: 130,
          minWidth: 280,
        ),
        decoration: BoxDecoration(
            //color: Colors.red, // debug
            ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                timer(day, 'day(s)'),
                timer(hr, 'hr(s)'),
                timer(min, 'min(s)'),
              ],
            ),
            SizedBox(height: 5),
            Text('Remaining',
                style: TextStyle(
                  fontSize: 20,
                  color: dayMinSecColor,
                )),
          ],
        ),
      ),
    );
  }

  // Day-Min-Sec Timer
  Widget timer(String timePeriod, String syntax) {
    return Column(
      children: <Widget>[
        SizedBox(height: 5),
        DottedBorder(
          color: Colors.black,
          strokeWidth: 2,
          child: Container(
            constraints: BoxConstraints(
              minHeight: 70,
              minWidth: 80,
            ),
            child: Center(
              child: Text(timePeriod,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                    color: dayMinSecColor,
                  )),
            ),
          ),
        ),
        SizedBox(height: 15),
        Text(syntax, // day(s), hr(s), min(s)
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: dayMinSecColor,
            ))
      ],
    );
  }

  // Text 'Description'
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

  // 4 logo besides 'Due Date', 'Due Time', 'Venue' and 'Details'
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

  Widget descriptionTitle(double first, double second, String text) {
    return Positioned(
      top: first,
      left: second,
      child: Text(
        text,
        style: TextStyle(
          color: HexColor('#212F3D'),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
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
        text,
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
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget closeButton(double first, double second) {
    return Positioned(
      top: first,
      left: second,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pop(context);
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

  Widget editButton(double first, double second) {
    return Positioned(
      top: first,
      left: second,
      child: ElevatedButton.icon(
        onPressed: () {
          _changeData(context, widget.event);
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

  // method: when user press on the edit button, brings user to edit page
  void _changeData(BuildContext context, DeadlinesEvent event) async {
    final DeadlinesEvent newEvent = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DeadlinesEdit(deadlinesEvent: event)),
    );

    if (newEvent != null) {
      setState(() {
        widget.event = DeadlinesEvent(newEvent.getTitle,
            newEvent.getDueDateTime, newEvent.getPlace, newEvent.getDetails);
      });
    }
  }

  // method: handles view page data if user input is null
  String _ifAbsent(String text) {
    if (text == '') {
      return 'None';
    } else {
      return text;
    }
  }
}
