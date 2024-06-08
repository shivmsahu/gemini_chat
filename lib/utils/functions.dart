import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  String formattedDate = DateFormat('dd MMM yyyy HH:mm').format(date);

  return formattedDate;
}
