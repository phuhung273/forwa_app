
import 'dart:convert';

import 'package:dio/dio.dart';

class BaseRepo{

  dynamic getErrorData(Response res){
    return res.data is String ? jsonDecode(res.data) : res.data;
  }
}