// any details of the user deadlines is done here
// mainly consists of attributes with its getters and setters
import 'package:equatable/equatable.dart';

class DeadlinesEvent extends Equatable {
  String title;
  DateTime dueDate;
  String place;
  String details;

  DeadlinesEvent(this.title, this.dueDate, this.place, this.details);

  @override
  List<Object> get props => [title, dueDate, place, details];

  // getter - get title of deadlines
  String get getTitle {
    return title;
  }

  // getter - get due date and time of deadlines
  DateTime get getDueDateTime {
    return dueDate;
  }

  // getter - get submission location of deadlines
  String get getPlace {
    return place;
  }

  // getter - get details of deadlines
  String get getDetails {
    return details;
  }

  // return 0 if deadline has passed
  // return 1 if due within 1 week
  // return 2 if due after 1 week and within 1 month
  // return 3 if due after 1 month
  int getDurationToDueDate() {
    if (dueDate.isBefore(DateTime.now())) {
      return 0;
    } else if (dueDate.isAfter(DateTime.now()) && dueDate.isBefore(DateTime.now().add(Duration(days: 7)))) {
      return 1;
    } else if (dueDate.isAfter(DateTime.now()) && dueDate.isBefore(DateTime.now().add(Duration(days: 30)))) {
      return 2;
    }
    return 3;
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'dueDate': dueDate,
      'place': place,
      'details': details,
    };
  }

  DeadlinesEvent.fromMap(Map<dynamic, dynamic> map)
      : title = map['title'],
        dueDate = map['dueDate'].toDate(),
        place = map['place'],
        details = map['details'];

  String toString() {
    return '$title, $dueDate, $place, $details';
  }
}
