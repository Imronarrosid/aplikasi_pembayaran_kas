import 'package:intl/intl.dart';

String dateFormater(DateTime date){
  var formatter = DateFormat('EEEE, d MMMM yyyy - hh:mm','id_ID');
  return formatter.format(date);
}