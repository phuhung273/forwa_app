import 'dart:io';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/repository/product_repo.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/product/product.dart';
import 'package:forwa_app/schema/product/product_add.dart';
import 'package:forwa_app/screens/address_select/address_select_screen_controller.dart';
import 'package:forwa_app/screens/base_controller/base_controller.dart';
import 'package:forwa_app/screens/home/home_screen_controller.dart';
import 'package:get/get.dart';
import 'package:time_range/time_range.dart';
import 'package:uuid/uuid.dart';

class GiveScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GiveScreenController());
    Get.put(AddressSelectScreenController());
  }
}

final initialPickupTime = TimeRangeResult(
    const TimeOfDay(hour: 8, minute: 00),
    const TimeOfDay(hour: 16, minute: 00)
);

const DEFAULT_PRODUCT_ADD_QUANTITY = 5;

class GiveScreenController extends BaseController {

  final LocalStorage _localStorage = Get.find();

  final ProductRepo _productRepo = Get.find();

  final HomeScreenController _homeController = Get.find();

  final AddressSelectScreenController _addressSelectController = Get.find();

  final uuid = const Uuid();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? _dueDate;
  String? _pickupTime;
  int? _userId;

  final List<File> _imageData = [];

  set time(TimeRangeResult? range){
    if(range == null) return;
    _setPickupTime(range);
  }

  set dueDate(DateTime? date){
    if(date == null) return;
    _dueDate = DateFormat.yMMMd().format(date);
  }

  void _setPickupTime(TimeRangeResult range){
    _pickupTime = '${range.start.hour}:00 - ${range.end.hour}:00';
  }

  @override
  void onInit() {
    super.onInit();
    _setPickupTime(initialPickupTime);
    _userId = _localStorage.getUserID();
  }


  @override
  void onReady() async {
    super.onReady();
    if(_userId == null) Get.offAndToNamed(ROUTE_LOGIN);
  }

  void addImage(File file){
    _imageData.add(file);
  }

  void deleteImage(int index){
    _imageData.removeAt(index);
  }

  Future submit() async {

    if(_userId == null) Get.offAndToNamed(ROUTE_LOGIN);

    if(_imageData.isEmpty){
      showErrorDialog(message: errorCodeMap['PRODUCT_001']!);
      return;
    }

    final products = [
      ProductAdd(
        name: nameController.text,
        sku: uuid.v4(),
        description: descriptionController.text,
        quantity: DEFAULT_PRODUCT_ADD_QUANTITY,
        pickupTime: _pickupTime!,
        images: _imageData,
        dueDate: _dueDate,
        addressId: _addressSelectController.id.value
      )
    ];

    showLoadingDialog();
    final response = await _productRepo.addProduct(products);
    hideDialog();
    if(!response.isSuccess || response.data == null){
      final message = errorCodeMap[response.statusCode] ?? 'Lỗi không xác định';
      showErrorDialog(message: message);
      return;
    }

    await showSuccessDialog(message: 'Thêm sản phẩm thành công');
    _homeController.products.insertAll(0, response.data?.items as Iterable<Product>);
    Get.back();
  }
}