import 'package:flutter/material.dart';
import 'package:forwa_app/di/google_place_service.dart';
import 'package:forwa_app/screens/base_controller/base_controller.dart';
import 'package:get/get.dart';
import 'package:google_place/google_place.dart';

abstract class AddressFormScreenController extends BaseController {

  final GooglePlaceService _googlePlaceService = Get.find();

  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  final suggestions = List<AutocompletePrediction>.empty().obs;
  DetailsResult? detailsResult;

  final isDefault = false.obs;

  bool _callAutocomplete = true;

  @override
  void onReady(){
    super.onReady();

    addressController.addListener(() async {
      final address = addressController.text;
      if(address.isNotEmpty && _callAutocomplete){
        final results = await _googlePlaceService.getSuggestions(address);
        if(results == null || results.isEmpty) return;

        suggestions.assignAll(results);
      }
    });
  }

  selectSuggestions(AutocompletePrediction suggestion) async {
    final details = await _googlePlaceService.selectSuggestion(suggestion);

    if(details == null) return;

    detailsResult = details.result;
    _callAutocomplete = false;
    addressController.text = detailsResult!.formattedAddress!;
    suggestions.clear();
    _callAutocomplete = true;
  }

  clearAddress(){
    detailsResult = null;
    addressController.clear();
  }

  @override
  void onClose(){
    addressController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  save();
}