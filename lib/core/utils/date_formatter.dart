import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime) {
  return DateFormat('E, d MMM H:mm').format(dateTime);
}

String getDayNameFromTimestamp(int timestamp) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toLocal();
  return DateFormat('EEEE').format(date);
}

String formatTimestampToHour(int timestamp) {
  final dateTime =
      DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toLocal();
  if (dateTime.minute == 0) {
    return DateFormat.jm().format(dateTime);
  }
  return DateFormat('h:mm a').format(dateTime);
}
