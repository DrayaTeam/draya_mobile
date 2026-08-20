import "package:intl/intl.dart";

class AppDateHelper {
  static String getFormattedDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return "${dateTime.day.toString().padLeft(2, '0')}/"
        "${dateTime.month.toString().padLeft(2, '0')}/"
        "${dateTime.year}";
  }

  static String getFormattedTime(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    String time = DateFormat("hh:mm a").format(dateTime);
    return time;
  }

  static String getFormattedDate2(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat("dd MMM, yyyy").format(dateTime);
  }

  static DateTime? getDateTime(String? dateString) {
    DateTime? dateTime = DateTime.tryParse(dateString?? "");
    return dateTime;
  }
}
