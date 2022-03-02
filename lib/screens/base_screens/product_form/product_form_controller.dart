import 'dart:io';

import 'package:flutter/material.dart';
import 'package:forwa_app/datasource/repository/product_repo.dart';
import 'package:forwa_app/screens/address_select/address_select_screen_controller.dart';
import 'package:forwa_app/screens/base_controller/base_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../helpers/time_helpers.dart';

abstract class ProductFormScreenController extends BaseController {

  final ProductRepo productRepo = Get.find();

  final AddressSelectScreenController addressSelectController = Get.find();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final dueDate = ''.obs;
  final from = ''.obs;
  final to = ''.obs;

  final List<File> imageFiles = [];

  setDueDate(DateTime? date){
    if(date == null) return;
    dueDate.value = DateFormat.yMMMd().format(date);
  }

  @override
  void onInit(){
    super.onInit();

    from.value = timeOfDayToString(const TimeOfDay(hour: 8, minute: 0));
    to.value = timeOfDayToString(const TimeOfDay(hour: 16, minute: 0));
  }

  @override
  void onClose(){
    nameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void addImage(File file){
    imageFiles.add(file);
  }

  void deleteFileImage(int index){
    imageFiles.removeAt(index);
  }

  submit();
}