import 'package:intl/intl.dart';

class Utils {
  // obtain 'Sun, Jun 20, 2021' from 20th June 2021, Sunday
  static String toDate(DateTime dateTime) {
    final date = DateFormat.yMMMEd().format(dateTime);
    return '$date';
  }

  // obtain '11:59' from 1159
  static String toTime(DateTime dateTime) {
    //final time = DateFormat('hh:mm a').format(DateTime.now());
    final time = DateFormat.Hm().format(dateTime);
    print('$time');
    return '$time';
  }

  // obtain '11:59PM' from 2359
  static String timeInAMPM(DateTime dateTime) {
    return '${DateFormat('hh:mm a').format(dateTime)}';
  }

  // obtain '24' in 24th June 2021
  static String dateOfDay(DateTime dateTime) {
    final time = dateTime.day;
    return '$time';
  }

  // obtain 'Sunday' for 20th June 2021
  static String dayOfWeek(DateTime dateTime) {
    final dayOfWeek = DateFormat('EEEE').format(dateTime);
    return dayOfWeek;
  }

  // obtain 'SUN' for 20th June 2021, Sunday
  static String dayOfWeekConvert(DateTime dateTime) {
    final String dayOfWeek = DateFormat('EEEE').format(dateTime);
    if (dayOfWeek == 'Monday') {
      return 'MON';
    } else if (dayOfWeek == 'Tuesday') {
      return 'TUE';
    } else if (dayOfWeek == 'Wednesday') {
      return 'WED';
    } else if (dayOfWeek == 'Thursday') {
      return 'THU';
    } else if (dayOfWeek == 'Friday') {
      return 'FRI';
    } else if (dayOfWeek == 'Saturyday') {
      return 'SAT';
    } else {
      return 'SUN';
    }
  }

  // obtain '6' in 24th June 2021
  static String monthOfDay(DateTime dateTime) {
    final monthNum = dateTime.month;
    return '$monthNum';
  }

  // obtain 'June in 24th June 2021
  static String monthOfDayInWords(DateTime dateTime) {
    final monthNum = dateTime.month;
    if (monthNum == 1) {
      return 'JAN';
    } else if (monthNum == 2) {
      return 'FEB';
    } else if (monthNum == 3) {
      return 'MAR';
    } else if (monthNum == 4) {
      return 'APR';
    } else if (monthNum == 5) {
      return 'MAY';
    } else if (monthNum == 6) {
      return 'JUN';
    } else if (monthNum == 7) {
      return 'JUL';
    } else if (monthNum == 8) {
      return 'AUG';
    } else if (monthNum == 9) {
      return 'SEP';
    } else if (monthNum == 10) {
      return 'OCT';
    } else if (monthNum == 11) {
      return 'NOV';
    } else {
      return 'DEC';
    }
  }

  // obtain time difference time bewtween 2 dates
  static Duration timeDiff(DateTime start, DateTime end) {
    return start.difference(end);
  }

  // obtain '2021-06-23 00:00:00' from '2021-06-23 with any time'
  static DateTime toSelectedDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 00, 00, 00);
  }
}
