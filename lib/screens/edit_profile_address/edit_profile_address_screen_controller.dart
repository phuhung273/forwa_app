import 'package:flutter/cupertino.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/repository/address_repo.dart';
import 'package:forwa_app/di/google_place_service.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/address/address.dart';
import 'package:forwa_app/screens/address_select/address_select_screen_controller.dart';
import 'package:forwa_app/screens/base_controller/address_controller.dart';
import 'package:forwa_app/screens/base_controller/base_controller.dart';
import 'package:forwa_app/screens/profile_address/profile_address_screen_controller.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_place/google_place.dart';

class EditProfileAddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditProfileAddressController());
  }
}

const minQueryLength = 3;

class EditProfileAddressController extends BaseController {

  final LocalStorage _localStorage = Get.find();

  final AddressRepo _addressRepo = Get.find();

  final GooglePlaceService _googlePlaceService = Get.find();

  late ProfileAddressScreenController _profileAddressController;
  late AddressSelectScreenController _addressSelectController;

  final streetController = TextEditingController();
  final wardController = TextEditingController();
  final districtController = TextEditingController();
  final cityController = TextEditingController();
  final phoneController = TextEditingController();

  final addressController = TextEditingController();

  String? _name;
  String? _previousRoute;

  final AddressController _addressController = Get.find();

  List<String> get cities => _addressController.cities;
  final districts = List<String>.empty().obs;
  final wards = List<String>.empty().obs;
  final suggestions = List<AutocompletePrediction>.empty().obs;
  DetailsResult? _detailsResult;

  set city(value) {
    cityController.text = value;
    _filterDistrictByCity(value);
  }

  set district(value) {
    districtController.text = value;
    _filterWardByDistrict(value);
  }

  set ward(value) => wardController.text = value;

  final isDefault = false.obs;

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
      if(address.length > minQueryLength){
        final results = await _googlePlaceService.getSuggestions(address);
        if(results == null || results.isEmpty) return;

        suggestions.assignAll(results);
      }
    });
  }

  void _filterDistrictByCity(String value){
    final filteredDistricts = List<String>.from(_addressController.districtMap[value]);
    districts.assignAll(filteredDistricts);
  }

  void _filterWardByDistrict(String value){
    final filteredWards = List<String>.from(_addressController.wardMap[value]);
    wards.assignAll(filteredWards);
  }

  selectSuggestions(AutocompletePrediction suggestion) async {
    final details = await _googlePlaceService.selectSuggestion(suggestion);

    if(details == null) return;

    _detailsResult = details.result;
  }

  Future save() async {
    // if(_name == null || _previousRoute == null){
    //   // TODO: add error text
    //   return;
    // }
    // showLoadingDialog();
    //
    // List<Location> locations = await locationFromAddress(streetController.text + wardController.text + districtController.text + cityController.text);
    // final location = locations.first;
    // List<Location> wardLocations = await locationFromAddress(wardController.text + districtController.text + cityController.text);
    // final wardLocation = wardLocations.first;
    //
    // final addressRequest = Address(
    //   street: streetController.text,
    //   ward: wardController.text,
    //   district: districtController.text,
    //   city: cityController.text,
    //   name: _name!,
    //   isDefault: isDefault.value,
    //   latitude: location.latitude.toString(),
    //   longitude: location.longitude.toString(),
    //   wardLatitude: wardLocation.latitude.toString(),
    //   wardLongitude: wardLocation.longitude.toString(),
    // );
    //
    // final response = await _addressRepo.saveAddress(addressRequest);
    // hideDialog();
    //
    // if(!response.isSuccess || response.data == null){
    //   // TODO: show error popup
    //   return;
    // }
    //
    // await showSuccessDialog(message: 'Thêm địa chỉ thành công');
    //
    // final address = response.data!;
    //
    // switch(_previousRoute){
    //   case ROUTE_PROFILE_ADDRESS:
    //     if(isDefault.value){
    //       _profileAddressController.addDefaultAddress(address);
    //     } else {
    //       _profileAddressController.addAddress(address);
    //     }
    //     break;
    //
    //   case ROUTE_GIVE:
    //   case ROUTE_SELECT_ADDRESS:
    //     if(isDefault.value){
    //       _addressSelectController.addDefaultAddress(address);
    //     } else {
    //       _addressSelectController.addAddress(address);
    //     }
    //     break;
    //   default:
    //     break;
    // }
    //
    // Get.back();
  }

  @override
  void onClose(){
    addressController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}