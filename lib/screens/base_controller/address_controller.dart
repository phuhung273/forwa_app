import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddressController extends GetxController {
  var cities = List<String>.empty();
  var districtMap = {};
  var wardMap = {};

  @override
  void onReady() async {
    super.onReady();

    final String cityString = await rootBundle.loadString('assets/jsons/city.json');
    cities = List<String>.from(jsonDecode(cityString));

    final String districtString = await rootBundle.loadString('assets/jsons/district.json');
    districtMap = jsonDecode(districtString);

    final String wardString = await rootBundle.loadString('assets/jsons/ward.json');
    wardMap = jsonDecode(wardString);
  }
}