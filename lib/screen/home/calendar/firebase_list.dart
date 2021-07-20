import 'package:schedule_neuron/screen/home/calendar/calendar_event.dart';

class FirebaseList {
  List<CalendarEvent> eventsList = [];

  FirebaseList.fromList(List<dynamic> list)
      : eventsList = firestoreListToEventsList(list);

  List<Map<String, dynamic>> toFirestoreList() {
    List<Map<String, dynamic>> convertedEventsList = [];
    this.eventsList.forEach((event) {
      convertedEventsList.add(event.toMap());
    });
    return convertedEventsList;
  }

  static List<CalendarEvent> firestoreListToEventsList(
      List<dynamic> firestoreList) {
    List<CalendarEvent> list = [];
    firestoreList.forEach((element) {
      list.add(CalendarEvent.fromMap(element));
    });
    return list;
  }
}
