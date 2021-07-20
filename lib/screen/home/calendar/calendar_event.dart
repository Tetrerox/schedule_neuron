import 'package:intl/intl.dart';
import 'dart:core';
import 'package:equatable/equatable.dart';

// any details of the user to-do is done here
// mainly consists of attributes with its getters and setters
class CalendarEvent extends Equatable {
  final String title;
  final DateTime fromDate;
  final DateTime toDate;
  final String place;
  final String details;

  CalendarEvent(
      this.title, this.fromDate, this.toDate, this.place, this.details);

  @override
  List<Object> get props => [title, fromDate, toDate, place, details];

  // getter - get title of deadlines
  String get getTitle {
    return title;
  }

  // getter - get from date and time of deadlines
  DateTime get getFromDateTime {
    return fromDate;
  }

  // getter - get to date and time of deadlines
  DateTime get getToDateTime {
    return toDate;
  }

  // getter - get submission location of deadlines
  String get getPlace {
    return place;
  }

  // getter - get details of deadlines
  String get getDetails {
    return details;
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'fromDate': fromDate,
      'toDate': toDate,
      'place': place,
      'details': details,
    };
  }

  CalendarEvent.fromMap(Map<dynamic, dynamic> map)
      : title = map['title'],
        fromDate = map['fromDate'].toDate(),
        toDate = map['toDate'].toDate(),
        place = map['place'],
        details = map['details'];

  String toString() {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    return 'String is $title, ${dateFormat.format(fromDate)}, ${dateFormat.format(toDate)}, $place, $details';
  }
}
