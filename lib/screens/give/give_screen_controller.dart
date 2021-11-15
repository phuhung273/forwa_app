import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/remote/product_service.dart';
import 'package:forwa_app/datasource/repository/product_repo.dart';
import 'package:forwa_app/helpers/product_helper.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/product/add_product_request.dart';
import 'package:forwa_app/schema/custom_attribute.dart';
import 'package:forwa_app/schema/extension_attributes.dart';
import 'package:forwa_app/schema/product/media_gallery_entry.dart';
import 'package:forwa_app/schema/product/media_gallery_entry_content.dart';
import 'package:forwa_app/schema/product/product.dart';
import 'package:forwa_app/schema/product/stock_item.dart';
import 'package:forwa_app/screens/base_controller/base_controller.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:time_range/time_range.dart';
import 'package:uuid/uuid.dart';

class GiveScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GiveScreenController());
  }
}

final initialPickupTime = TimeRangeResult(
    const TimeOfDay(hour: 8, minute: 00),
    const TimeOfDay(hour: 16, minute: 00)
);

class GiveScreenController extends BaseController {

  final LocalStorage _localStorage = Get.find();

  final ProductRepo _productRepo = Get.find();

  final uuid = const Uuid();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? _pickupTime;
  String? _storeCode;
  int? _websiteId;

  final List<MediaGalleryEntry> _imageData = [];

  set time(TimeRangeResult? range){
    if(range == null) return;
    _setPickupTime(range);
  }

  void _setPickupTime(TimeRangeResult range){
    _pickupTime = '${range.start.hour}:00 - ${range.end.hour}:00';
  }

  @override
  void onInit() {
    super.onInit();
    _setPickupTime(initialPickupTime);
    _storeCode = _localStorage.getStoreCode();
    _websiteId = _localStorage.getStoreWebsiteId();
  }


  @override
  void onReady() {
    super.onReady();
    if(_storeCode == null || _websiteId == null) Get.offAndToNamed(ROUTE_LOGIN);
  }

  void addImage(File file){
    // _imageData.add(base64Encode(file.readAsBytesSync()));
    final type = lookupMimeType(file.path)!;
    final name = '${uuid.v4()}${extension(file.path)}';
    final data = base64Encode(file.readAsBytesSync());

    _imageData.add(MediaGalleryEntry(
      content: MediaGalleryEntryContent(
        base64Data: data,
        type: type,
        name: name,
      )
    ));
  }

  void deleteImage(int index){
    _imageData.removeAt(index);
  }

  Future submit() async {
    if(_imageData.isEmpty){
      // TODO: set error message
      return;
    }

    if(_storeCode == null || _websiteId == null) Get.offAndToNamed(ROUTE_LOGIN);

    final customAttributes = [
      CustomAttribute(
        attributeCode: CustomAttribute.getCode(CustomAttributeCode.DESCRIPTION),
        value: descriptionController.text
      ),
      CustomAttribute(
        attributeCode: CustomAttribute.getCode(CustomAttributeCode.PICKUP_TIME),
        value: _pickupTime
      ),
    ];

    final extensionAttributes = ExtensionAttributes(
      websiteIds: [DEFAULT_WEBSITE_ID, _websiteId!],
      stockItem: StockItem(),
    );

    final request = AddProductRequest(
      product: Product(
        name: nameController.text,
        sku: genSku(_storeCode!),
        customAttributes: customAttributes,
        extensionAttributes: extensionAttributes,
        medias: _imageData,
      )
    );

    showLoadingDialog();
    final response = await _productRepo.addProduct(request);
    hideDialog();
    if(!response.isSuccess || response.data == null){
      return;
    }

    Get.back();
  }
}