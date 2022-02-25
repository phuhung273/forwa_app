import 'package:flutter/cupertino.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/repository/address_repo.dart';
import 'package:forwa_app/di/google_place_service.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/address/address.dart';
import 'package:forwa_app/screens/address_select/address_select_screen_controller.dart';
import 'package:forwa_app/screens/base_controller/base_controller.dart';
import 'package:forwa_app/screens/profile_address/profile_address_screen_controller.dart';
import 'package:get/get.dart';
import 'package:google_place/google_place.dart';

class EditProfileAddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditProfileAddressController());
  }
}

class EditProfileAddressController extends BaseController {

  final LocalStorage _localStorage = Get.find();

  final AddressRepo _addressRepo = Get.find();

  final GooglePlaceService _googlePlaceService = Get.find();

  late ProfileAddressScreenController _profileAddressController;
  late AddressSelectScreenController _addressSelectController;

  final phoneController = TextEditingController();

  final addressController = TextEditingController();

  String? _name;
  String? _previousRoute;

  final suggestions = List<AutocompletePrediction>.empty().obs;
  DetailsResult? _detailsResult;

  final isDefault = false.obs;

  bool _callAutocomplete = true;

  @override
  void onInit() {
    super.onInit();

    _name = _localStorage.getCustomerName();
    _previousRoute = Get.parameters[previousRouteParam];

    switch(_previousRoute){
      case ROUTE_PROFILE_ADDRESS:
        _profileAddressController = Get.find();
        break;
      case ROUTE_GIVE:
      case ROUTE_SELECT_ADDRESS:
        _addressSelectController = Get.find();
        break;
      default:
        break;
    }
  }

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

    _detailsResult = details.result;
    _callAutocomplete = false;
    addressController.text = _detailsResult!.formattedAddress!;
    suggestions.clear();
    _callAutocomplete = true;
  }

  clearAddress(){
    _detailsResult = null;
    addressController.clear();
  }

  Future save() async {
    if(_name == null || _previousRoute == null){
      return;
    }

    if(_detailsResult == null || addressController.text.isEmpty){
      showErrorDialog(message: 'Vui lòng nhập và chọn địa chỉ');
      return;
    }

    showLoadingDialog();

    final location = _detailsResult!.geometry!.location;

    final addressRequest = Address(
      text: _detailsResult!.formattedAddress!,
      name: _name!,
      phone: phoneController.text,
      isDefault: isDefault.value,
      latitude: location!.lat.toString(),
      longitude: location.lng.toString(),
    );

    final response = await _addressRepo.saveAddress(addressRequest);
    hideDialog();

    if(!response.isSuccess || response.data == null){
      // TODO: show error popup
      return;
    }

    await showSuccessDialog(message: 'Thêm địa chỉ thành công');

    final address = response.data!;

    switch(_previousRoute){
      case ROUTE_PROFILE_ADDRESS:
        if(isDefault.value){
          _profileAddressController.addDefaultAddress(address);
        } else {
          _profileAddressController.addAddress(address);
        }
        break;

      case ROUTE_GIVE:
      case ROUTE_SELECT_ADDRESS:
        if(isDefault.value){
          _addressSelectController.addDefaultAddress(address);
        } else {
          _addressSelectController.addAddress(address);
        }
        break;
      default:
        break;
    }

    Get.back();
  }

  @override
  void onClose(){
    addressController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}