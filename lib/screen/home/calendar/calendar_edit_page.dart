import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule_neuron/model/my_user.dart';
import 'package:schedule_neuron/screen/home/calendar/calendar_event.dart';
import 'package:schedule_neuron/service/database.dart';
import 'package:schedule_neuron/service/utils.dart';
import 'package:schedule_neuron/shared/hex_color.dart';

class CalendarEdit extends StatefulWidget {
  //final DateTime selectedDay;
  final CalendarEvent? calendarEvent;

  CalendarEdit(this.calendarEvent);

  @override
  _CalendarEditState createState() => _CalendarEditState();
}

class _CalendarEditState extends State<CalendarEdit> {
  final _formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var placeController = TextEditingController();
  var detailsController = TextEditingController();
  late DateTime fromTime;
  late DateTime toTime;

  // design related variables
  final String headerColor = '#000000'; // black
  final String topColor = '#F9BE7C'; // bright orange
  final HexColor backgroundColor = HexColor('#FFF9EB'); // light yellow
  final HexColor iconBackgroundColor = HexColor('#48C9B0'); // clock: green
  final String catergorySelectedColor = '#E46471'; // catergory - dark pink
  final String catergoryNonSelectedColor = '#A6ACAF'; // catergory - grey
  final String selectedTextColor = '#FDFEFE'; // white
  final String nonSelectedTextColor = '#17202A'; // dark grey
  final headerSize = 25.0;
  final titleSize = 17.0;

  @override
  void initState() {
    super.initState();

    if (widget.calendarEvent == null) {
      fromTime = widget.calendarEvent!.getToDateTime;
      toTime = fromTime.add(Duration(hours: 2));
    } else {
      // when the user edits old calendar events
      final event = widget.calendarEvent;
      fromTime = event!.getFromDateTime;
      toTime = event.getToDateTime;
      titleController.text = event.getTitle;
      placeController.text = event.getPlace;
      detailsController.text = event.getDetails;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    placeController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      body: Stack(
        children: <Widget>[
          topBackground(0, 0), // top-right
          pageHeader(80, 40), // top-left
          titleHeader(130, 40), // top-left (Title)
          Padding(
            padding: const EdgeInsets.all(40),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 120), // 'Title' and title text field
                  titleInsertRow(),
                  SizedBox(height: 20),
                  dateHeader(),
                  dateFixedRow(),
                  SizedBox(height: 40),
                  timeHeader(),
                  timeInsertRow(),
                  SizedBox(height: 10),
                  detailsHeader(),
                  detailInsertRow(),
                  placeHeader(),
                  placeInsertRow(),
                  SizedBox(height: 15),
                  catergoryHeader(),
                  catergoryInsertRow(),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),

          createButton(720, 80, user), // top-left
          cancelButton(720, 220, context), // top-left
        ],
      ),
    );
  }

  // orange container at the top
  Widget topBackground(double first, double second) {
    return Positioned(
      top: first,
      right: second,
      child: Container(
        constraints: BoxConstraints(
          minHeight: 305,
          minWidth: 413,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(35.0),
              bottomRight: Radius.circular(35.0)),
          shape: BoxShape.rectangle,
          color: HexColor('#F9BE7C'),
        ),
      ),
    );
  }

  // text labelled 'Create New Event'
  Widget pageHeader(double first, double second) {
    return Positioned(
      top: first,
      left: second,
      child: Text(
        'Edit event',
        style: TextStyle(
          fontSize: headerSize,
          fontWeight: FontWeight.bold,
          color: HexColor(headerColor),
        ),
      ),
    );
  }

  // Text labelled 'Title'
  Widget titleHeader(double first, double second) {
    return Positioned(
      top: first,
      left: second,
      child: Opacity(
        opacity: 0.9,
        child: Text(
          'Title',
          style: TextStyle(
            fontSize: 20,
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // handles the title input of form
  Widget titleInsertRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          constraints: BoxConstraints(
            maxWidth: 300,
          ),
          child: TextFormField(
              cursorColor: Colors.black,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                  border: UnderlineInputBorder(), hintText: 'Add Title'),
              controller: titleController,
              // check if title is not empty
              validator: (title) {
                if (title == null || title.isEmpty) {
                  return 'Title Cannot Be Empty';
                } else {
                  return null;
                }
              }),
        ),
      ],
    );
  }

  // text 'Date'
  Widget dateHeader() {
    return Row(
      children: <Widget>[
        Opacity(
          opacity: 0.9,
          child: Text(
            'Date',
            style: TextStyle(
              fontSize: titleSize,
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: 100)
      ],
    );
  }

  // shows user the date selected
  Widget dateFixedRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Opacity(
          opacity: 0.7,
          child: Container(
            child: Text(Utils.toDate(fromTime), style: TextStyle(fontSize: 20)),
            constraints: BoxConstraints(
              minWidth: 260.0,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 0.7, color: Colors.black),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        Container(
            constraints: BoxConstraints(
              minHeight: 40,
              minWidth: 40,
            ),
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: iconBackgroundColor),
            child: Icon(Icons.calendar_today_outlined)),
      ],
    );
  }

  // text 'From' and 'To'
  Widget timeHeader() {
    return Row(
      children: <Widget>[
        Opacity(
          opacity: 0.7,
          child: Text(
            'From',
            style: TextStyle(
              fontSize: titleSize,
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: 125), // space between from and to
        Opacity(
          opacity: 0.7,
          child: Text(
            'To',
            style: TextStyle(
              fontSize: titleSize,
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // shows user the from and to time, and allow user selection
  Widget timeInsertRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
            child: buildDropDownField(
                text: Utils.toTime(fromTime),
                onClicked: () => pickFromDateTime())),
        Expanded(
          child: buildDropDownField(
              text: Utils.toTime(toTime), onClicked: () => pickToDateTime()),
        ),
      ],
    );
  }

  // handles the drop-down icon of both date and time
  Widget buildDropDownField(
      {required String text, required VoidCallback onClicked}) {
    return ListTile(
      title: Text(text),
      trailing: Container(
          constraints: BoxConstraints(
            minHeight: 40,
            minWidth: 40,
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: iconBackgroundColor,
          ),
          child: Icon(Icons.timer)),
      onTap: onClicked,
    );
  }

  // Text 'Description'
  Widget detailsHeader() {
    return Row(
      children: <Widget>[
        Opacity(
          opacity: 0.7,
          child: Text(
            'Description',
            style: TextStyle(
              fontSize: titleSize,
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // handles the detail input of form
  Widget detailInsertRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          constraints: BoxConstraints(
            maxWidth: 260,
          ),
          child: TextFormField(
            style: TextStyle(fontSize: 20),
            decoration: InputDecoration(
                border: UnderlineInputBorder(), hintText: 'Add Details'),
            controller: detailsController,
            maxLength: 100,
          ),
        ),
        SizedBox(width: 12),
        detailsIcon(),
      ],
    );
  }

  // handles the detail icon of form
  Widget detailsIcon() {
    return Opacity(
      opacity: 0.9,
      child: Container(
          constraints: BoxConstraints(
            minHeight: 40,
            minWidth: 40,
          ),
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: iconBackgroundColor),
          child: Icon(Icons.text_fields_sharp)),
    );
  }

  // text 'Place'
  Widget placeHeader() {
    return Row(
      children: <Widget>[
        Opacity(
          opacity: 0.7,
          child: Text(
            'Place',
            style: TextStyle(
              fontSize: titleSize,
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // handles the submission place input of form
  Widget placeInsertRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          constraints: BoxConstraints(
            maxWidth: 260,
          ),
          child: TextFormField(
            style: TextStyle(fontSize: 20),
            decoration: InputDecoration(
                border: UnderlineInputBorder(), hintText: 'Add Venue'),
            controller: placeController,
          ),
        ),
        SizedBox(width: 12),
        placeIcon(),
      ],
    );
  }

  // handles the place icon of form
  Widget placeIcon() {
    return Opacity(
      opacity: 0.9,
      child: Container(
          constraints: BoxConstraints(
            minHeight: 40,
            minWidth: 40,
          ),
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: iconBackgroundColor),
          child: Icon(Icons.location_city)),
    );
  }

  // Text 'Frequency'
  Widget catergoryHeader() {
    return Row(
      children: <Widget>[
        Opacity(
          opacity: 0.7,
          child: Text(
            'Notes',
            style: TextStyle(
              fontSize: titleSize,
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // allow user to select frequency of event
  Widget catergoryInsertRow() {
    return Container(
      constraints: BoxConstraints(
        minWidth: 320.0,
      ),
      child: Column(
        children: <Widget>[
          SizedBox(height: 4),
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            SizedBox(width: 18),
            createOneTimeContainer(
                'Title is a compulsory input', catergorySelectedColor, selectedTextColor),
            createWeeklyContainer(
                'Details and Venue are optional inputs', catergorySelectedColor, selectedTextColor),
          ]),
        ],
      ),
    );
  }

  // within catergory insert row - containing 'one-time'
  Widget createOneTimeContainer(
      String catergory, String backgroundColor, String textColor) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.transparent),
      ),
      onPressed: () {},
      child: Container(
        constraints: BoxConstraints(
          minWidth: 100,
          minHeight: 30,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(35.0)),
          shape: BoxShape.rectangle,
          color: HexColor(backgroundColor),
        ),
        child: Center(
            child: Text(
          catergory,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: HexColor(textColor),
          ),
        )),
      ),
    );
  }

  // within catergory insert row - containing 'weekly'
  Widget createWeeklyContainer(
      String catergory, String backgroundColor, String textColor) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.transparent),
      ),
      onPressed: () {},
      child: Container(
        constraints: BoxConstraints(
          minWidth: 100,
          minHeight: 30,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(35.0)),
          shape: BoxShape.rectangle,
          color: HexColor(backgroundColor),
        ),
        child: Center(
            child: Text(
          catergory,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: HexColor(textColor),
          ),
        )),
      ),
    );
  }

  // handles the save button and process the new data into calendar page
  // not used in this file, used in calendar_add_page.dart
  Future saveForm() async {
    final isValid =
        _formKey.currentState!.validate(); // atm check if title is not empty

    // check if user has input a title
    if (isValid) {
      final event = CalendarEvent(titleController.text, fromTime, toTime,
          placeController.text, detailsController.text);
      Navigator.pop(context, event);
    }
  }

  // related to user data input of time, do not edit
  Future pickFromDateTime() async {
    final date = await pickDateTime(fromTime);

    // to ensure that date is never null
    if (date == null) {
      return;
    }

    // ensure that user toTime is always after fromTime
    if (date.isAfter(toTime)) {
      toTime = DateTime(
          date.year, date.month, date.day, date.hour, date.minute, date.second);
    }

    setState(() {
      fromTime = date;
    });
  }

  // related to user data input of time, do not edit
  Future pickToDateTime() async {
    final date = await pickDateTime(toTime, firstDate: DateTime.now());

    // to ensure that date is never null
    if (date == null) {
      return;
    }

    setState(() {
      toTime = date;
    });
  }

  // related to user data input of time, do not edit
  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
    DateTime? firstDate,
  }) async {
    // allow user to pick a time
    final timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );

    if (timeOfDay == null) {
      return null;
    }

    final date = DateTime(initialDate.year, initialDate.month, initialDate.day);
    final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
    return date.add(time); // combine day and time of user input
  }

  // Create bottom at the bottom
  Widget createButton(double first, double second, MyUser user) {
    return Positioned(
      top: first,
      left: second,
      child: ElevatedButton.icon(
        onPressed: () async {
          final isValid = _formKey.currentState!
              .validate(); // atm check if title is not empty

          // check if user has input a title
          if (isValid) {
            final event = CalendarEvent(titleController.text, fromTime, toTime,
                placeController.text, detailsController.text);
            await DatabaseService(uid: user.uid).editUserEvent(
                Utils.toSelectedDay(fromTime), widget.calendarEvent, event);
            Navigator.pop(context, event);
          }
        },
        icon: Icon(Icons.create),
        label: Text('Save'),
        style: ElevatedButton.styleFrom(
          primary: Colors.brown,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
        ),
      ),
    );
  }

  // Cancel button at the bottom
  Widget cancelButton(double first, double second, BuildContext context) {
    return Positioned(
      top: first,
      left: second,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.delete),
        label: Text('Cancel'),
        style: ElevatedButton.styleFrom(
          primary: Colors.brown,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
        ),
      ),
    );
  }
}
