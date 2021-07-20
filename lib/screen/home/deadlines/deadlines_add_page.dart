import 'package:flutter/material.dart';
import 'package:schedule_neuron/screen/home/deadlines/deadlines_event.dart';
import 'package:schedule_neuron/service/utils.dart';
import 'package:schedule_neuron/shared/hex_color.dart';

// deadline edit page
class DeadlinesAdd extends StatefulWidget {
  final DeadlinesEvent? deadlinesEvent;

  // constructor
  const DeadlinesAdd({
    Key? key,
    this.deadlinesEvent,
  }) : super(key: key);

  @override
  _DeadlinesAddState createState() => _DeadlinesAddState();
}

class _DeadlinesAddState extends State<DeadlinesAdd> {
  final _formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var placeController = TextEditingController();
  var detailsController = TextEditingController();
  late DateTime dueDate;

  // design related variables
  final HexColor backgroundColor = HexColor('#FFF9EB'); // light yellow
  final HexColor topColor = HexColor('#F9BE7C'); // orange
  final HexColor headerColor = HexColor('000000'); // black
  final HexColor calendarBackgroundColor = HexColor('#48C9B0'); // green
  final HexColor notesBackgroundColor = HexColor('#E46471'); // pink
  final HexColor notesTextColor = HexColor('#FDFEFE'); // white
  final headerSize = 25.0;
  final titleSize = 17.0;

  @override
  void initState() {
    // when the user add new deadlines
    if (widget.deadlinesEvent == null) {
      dueDate = DateTime.now();
    } else {
      // when the user edits old deadlines
      final event = widget.deadlinesEvent;
      dueDate = event!.getDueDateTime;
      titleController.text = event.getTitle;
      placeController.text = event.getPlace;
      detailsController.text = event.getDetails;
    }

    super.initState();
  }

  // get rid of old data whenever this page is saved
  @override
  void dispose() {
    titleController.dispose();
    placeController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      // to make the column scrollable
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Stack(
            children: <Widget>[
              topContainer(0, 0), // top-right
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 80),
                  pageHeader(),
                  SizedBox(height: 20),
                  titleHeader(),
                  SizedBox(height: 10),
                  titleInsertRow(),
                  SizedBox(height: 22),
                  dateHeader(),
                  dateInsertRow(),
                  SizedBox(height: 36),
                  placeHeader(),
                  placeInsertRow(),
                  SizedBox(height: 20),
                  detailsHeader(),
                  detailsInsertRow(),
                  SizedBox(height: 0),
                  notesHeader(),
                  SizedBox(height: 20),
                  notesRow(),
                  SizedBox(height: 25),
                  createNCancelButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // orange container at the top
  Widget topContainer(double first, double second) {
    return Positioned(
      top: first,
      right: second,
      child: Container(
        constraints: BoxConstraints(
          minHeight: 330,
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

  // Text 'Create New Deadlines'
  Widget pageHeader() {
    return Row(
      children: <Widget>[
        SizedBox(width: 25),
        Text(
          'Create New Deadline',
          style: TextStyle(
            fontSize: headerSize,
            fontWeight: FontWeight.bold,
            color: headerColor,
          ),
        ),
      ],
    );
  }

  // Text 'Title'
  Widget titleHeader() {
    return Opacity(
      opacity: 0.9,
      child: Row(
        children: <Widget>[
          SizedBox(width: 30),
          Text(
            'Title',
            style: TextStyle(
              fontSize: 20,
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // handles the title input of form
  Widget titleInsertRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 35),
        Container(
          width: 320,
          child: TextFormField(
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                  border: UnderlineInputBorder(), hintText: 'Add title'),
              controller: titleController,
              // check if title is not empty
              validator: (title) {
                if (title == null || title.isEmpty) {
                  return 'Title cannot be empty';
                } else {
                  return null;
                }
              }),
        ),
      ],
    );
  }

  // Text 'Date' and 'Time'
  Widget dateHeader() {
    return Row(
      children: <Widget>[
        SizedBox(width: 40),
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
        SizedBox(width: 167),
        Opacity(
          opacity: 0.9,
          child: Text(
            'Time',
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

  // handles the due date input of form
  Widget dateInsertRow() {
    return Row(
      children: <Widget>[
        SizedBox(width: 25),
        // handles the date in due date
        Expanded(
          flex: 1, // design purpose
          child: buildDropDownFieldDate(
            text: Utils.toDate(dueDate),
            onClicked: () {
              pickDueDate(pickDate: true);
            },
          ),
        ),
        SizedBox(width: 25),
        // handles the time in due date
        Expanded(
          child: buildDropDownFieldTime(
            text: Utils.toTime(dueDate),
            onClicked: () {
              pickDueDate(pickDate: false);
            },
          ),
        ),
      ],
    );
  }

  // handles the drop-down icon of date
  Widget buildDropDownFieldDate(
      {required String text, required VoidCallback onClicked}) {
    return ListTile(
      title: Text(text),
      onTap: onClicked,
      trailing: Container(
          constraints: BoxConstraints(
            minHeight: 40,
            minWidth: 40,
          ),
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: calendarBackgroundColor),
          child: Icon(Icons.timer)),
    );
  }

  // handles the drop-down icon of time
  Widget buildDropDownFieldTime(
      {required String text, required VoidCallback onClicked}) {
    return ListTile(
      title: Text(text),
      trailing: Container(
          constraints: BoxConstraints(
            minHeight: 40,
            minWidth: 40,
          ),
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: calendarBackgroundColor),
          child: Icon(Icons.timer)),
      onTap: onClicked,
    );
  }

  // Text 'Submission Location'
  Widget placeHeader() {
    return Row(
      children: <Widget>[
        SizedBox(width: 30),
        Opacity(
          opacity: 0.7,
          child: Text(
            'Submission Location',
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 30),
        Container(
          width: 270,
          child: TextFormField(
            style: TextStyle(fontSize: 20),
            decoration: InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'Add Submission Location'),
            controller: placeController,
          ),
        ),
        SizedBox(width: 18),
        Column(
          children: <Widget>[
            SizedBox(height: 10),
            Container(
                constraints: BoxConstraints(
                  minHeight: 40,
                  minWidth: 40,
                ),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: calendarBackgroundColor),
                child: Icon(Icons.location_city)),
          ],
        ),
      ],
    );
  }

  // Text 'Description'
  Widget detailsHeader() {
    return Row(
      children: <Widget>[
        SizedBox(width: 30),
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

  // handles the details input of form
  Widget detailsInsertRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 30),
        Container(
          width: 270,
          child: TextFormField(
            style: TextStyle(fontSize: 20),
            decoration: InputDecoration(
                border: UnderlineInputBorder(), hintText: 'Add Details'),
            controller: detailsController,
            maxLength: 120,
          ),
        ),
        SizedBox(width: 20),
        Column(
          children: <Widget>[
            SizedBox(height: 10),
            Container(
                constraints: BoxConstraints(
                  minHeight: 40,
                  minWidth: 40,
                ),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: calendarBackgroundColor),
                child: Icon(Icons.text_fields_sharp)),
          ],
        ),
      ],
    );
  }

  // Text 'Notes to User'
  Widget notesHeader() {
    return Row(
      children: <Widget>[
        SizedBox(width: 30),
        Opacity(
          opacity: 0.7,
          child: Text(
            'Notes to Users',
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

  // handles the 2 text for user at the bottom
  Widget notesRow() {
    return Container(
      constraints: BoxConstraints(
        minWidth: 320.0,
      ),
      child: Column(
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            SizedBox(width: 30),
            createIndividualContainer(
                'Expired deadlines show 0 for day, hour and min',
                notesBackgroundColor,
                notesTextColor),
          ]),
          SizedBox(height: 5),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            SizedBox(width: 30),
            createIndividualContainer(
                'Inserting location and description is optional',
                notesBackgroundColor,
                notesTextColor),
          ]),
          SizedBox(height: 5),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            SizedBox(width: 30),
            createIndividualContainer(
                'Can only be deleted from the Deadlines page',
                notesBackgroundColor,
                notesTextColor),
          ]),
        ],
      ),
    );
  }

  // 6 individual catergory container
  Widget createIndividualContainer(
      String catergory, HexColor backgroundColor, HexColor textColor) {
    return Container(
      constraints: BoxConstraints(
        minWidth: 320,
        minHeight: 30,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(35.0)),
        shape: BoxShape.rectangle,
        color: backgroundColor,
      ),
      child: Center(
          child: Text(
        catergory,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      )),
    );
  }

  // row for create and cancel button
  Widget createNCancelButton() {
    return Row(
      children: <Widget>[
        SizedBox(width: 80),
        ElevatedButton.icon(
          onPressed: saveForm,
          icon: Icon(Icons.create),
          label: Text('Create'),
          style: ElevatedButton.styleFrom(
            primary: Colors.brown,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
          ),
        ),
        SizedBox(width: 40),
        ElevatedButton.icon(
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
      ],
    );
  }

  // related to user input in form (DO NOT EDIT)
  // handles the save button
  Future saveForm() async {
    final isValid =
        _formKey.currentState!.validate(); // atm check if title is not empty

    // check if user has input a title
    if (isValid) {
      final event = DeadlinesEvent(titleController.text, dueDate,
          placeController.text, detailsController.text);
      Navigator.pop(context, event);
    }
  }

  // allow user to input date and time
  Future pickDueDate({required bool pickDate}) async {
    final date = await pickDateTime(dueDate, pickDate: pickDate);
    if (date == null) {
      return;
    }

    // set the due date when user press 'ok'
    setState(() {
      dueDate = date;
    });
  }

  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
    required bool pickDate,
    DateTime? firstDate,
  }) async {
    // choosing a day (date)
    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime.now(), // first date user can select
        lastDate: DateTime(2101), // last date user can select
      );

      // ensure date is valid
      if (date == null) {
        return null;
      }

      // add a default time in case the user does not input one
      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);
      return date.add(time);

      // choosing a time
    } else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      // ensure time is valid
      if (timeOfDay == null) {
        return null;
      }

      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
      return date.add(time); // combine date and time selected
    }
  }
}
