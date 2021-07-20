import 'package:flutter/material.dart';
import 'package:schedule_neuron/screen/home/calendar/calendar.dart';
import 'package:schedule_neuron/screen/home/deadlines/deadlines_list.dart';
import 'package:schedule_neuron/screen/home/sticky_notes/sticky_notes.dart';
import 'package:schedule_neuron/screen/home/today_schedule/to_do_list.dart';
import 'package:schedule_neuron/shared/hex_color.dart';

// to navigate to the 4 portions of ScheduleNeuron
class Navigation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NavigationState();
  }
}

class NavigationState extends State<Navigation> {
  // design-related variables
  HexColor _selectedColor = HexColor('#CB4335'); // red (color when user clicks on the icon)
  HexColor _defaultColor = HexColor('#424949'); // grey (color when user does not click on icon)
  HexColor _backgroundColor = HexColor('#FCF3CF'); // color of navigation bar background

  // keep track of tab for btm navigation
  int _currentIndex = 0;
  final List<Widget> _children = [
    // list of widget for btm navigation
    StickyNotes(), // index = 0
    Calendar(), // index = 1
    ToDoList(), // index = 2
    Deadlines() // index = 3
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.brown[50],
        body: Center(
          child: _children.elementAt(_currentIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: _backgroundColor,
            selectedItemColor: _selectedColor,
            unselectedItemColor: _defaultColor,
            currentIndex: _currentIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed, // 4 items or more
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.note_alt_outlined), label: 'Notes'),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendar'),
              BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Today'),
              BottomNavigationBarItem(icon: Icon(Icons.hourglass_bottom), label: 'Deadlines'),
            ]),
      ),
    );
  }

  // index changed accordingly to what is tapped
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
