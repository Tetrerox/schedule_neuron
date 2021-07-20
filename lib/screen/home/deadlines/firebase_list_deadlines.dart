import 'package:schedule_neuron/screen/home/calendar/calendar_event.dart';
import 'package:schedule_neuron/screen/home/deadlines/deadlines_event.dart';

class FirebaseListDeadlines {
  List<DeadlinesEvent> deadlinesList = [];

  FirebaseListDeadlines.fromList(List<dynamic> list)
      : deadlinesList = firestoreListToDeadlinesList(list);

  List<Map<String, dynamic>> toFirestoreList() {
    List<Map<String, dynamic>> convertedDeadlinesList = [];
    this.deadlinesList.forEach((event) {
      convertedDeadlinesList.add(event.toMap());
    });
    return convertedDeadlinesList;
  }

  static List<DeadlinesEvent> firestoreListToDeadlinesList(
      List<dynamic> firestoreList) {
    List<DeadlinesEvent> list = [];
    firestoreList.forEach((element) {
      list.add(DeadlinesEvent.fromMap(element));
    });
    return list;
  }

  List<CalendarEvent> toCalendarEventsList() {
    List<CalendarEvent> list = [];
    for (DeadlinesEvent deadline in deadlinesList) {
      list.add(CalendarEvent(deadline.title, deadline.dueDate, deadline.dueDate,
          deadline.place, deadline.details));
    }
    return list;
  }
}
