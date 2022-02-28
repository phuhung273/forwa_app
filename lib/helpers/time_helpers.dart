

import 'package:flutter/material.dart';
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

String timeOfDayToString(TimeOfDay time){
  String minute = time.minute < 10 ? '0${time.minute}' : time.minute.toString();
  return '${time.hourOfPeriod}:$minute ${time.period.name.toUpperCase()}';
}

TimeOfDay stringToTimeOfDay(String time){
  final format = DateFormat('h:mm a'); //"6:00 AM"
  return TimeOfDay.fromDateTime(format.parse(time));
}