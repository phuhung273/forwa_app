

import 'package:intl/intl.dart';

int dayDifferenceFromNow(DateTime to){
  return DateTime.now().difference(to).inDays;
}

String getDateNow(){
  final now = DateTime.now();
  return DateFormat('yyyy-MM-dd').format(now);
}

DateTime string2DateTime(String str){
  return DateFormat('yyyy-MM-dd').parse(str);
}