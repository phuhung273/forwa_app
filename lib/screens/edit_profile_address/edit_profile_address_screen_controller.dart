import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/repository/address_repo.dart';
import 'package:forwa_app/schema/address/create_address_request.dart';
import 'package:forwa_app/schema/address/customer_address.dart';
import 'package:forwa_app/schema/product/custom_attribute.dart';
import 'package:forwa_app/screens/base_controller.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class EditProfileAddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditProfileAddressController());
  }
}

class EditProfileAddressController extends BaseController {

  final LocalStorage _localStorage = Get.find();

  final AddressRepo _addressRepo = Get.find();

  final streetController = TextEditingController();
  final wardController = TextEditingController();
  final districtController = TextEditingController();
  final cityController = TextEditingController();
  final phoneController = TextEditingController();

  String? firstName;
  String? lastName;
  int? customerId;

  @override
  void onInit() {
    super.onInit();

    final name = _localStorage.getCustomerName();
    customerId = _localStorage.getUserID();

    if(name == null){
      return;
    }
    final words = name.split(' ');
    firstName = words.first;
    lastName = words.length > 1 ? words.last : words.first;
  }

  Future save() async {
    if(customerId == null || firstName == null || lastName == null){
      // TODO: add error text
      return;
    }

    List<Location> locations = await locationFromAddress(streetController.text + wardController.text + districtController.text + cityController.text);
    for(final location in locations){
      print('${location.latitude} - ${location.longitude}');
    }
    final location = locations.first;
    final latAttribute = CustomAttribute(
      attributeCode: CustomAttribute.getCode(CustomAttributeCode.LATITUDE),
      value: location.latitude.toString(),
    );
    final longAttribute = CustomAttribute(
      attributeCode: CustomAttribute.getCode(CustomAttributeCode.LONGITUDE),
      value: location.longitude.toString(),
    );

    final address = CustomerAddress(
      customerId: customerId!,
      region: 'abcxyz',
      regionId: 999,
      countryId: 'VN',
      street: [streetController.text, wardController.text, districtController.text],
      postCode: '700000',
      city: cityController.text,
      firstName: firstName!,
      lastName: lastName!,
      telephone: phoneController.text,
      defaultBilling: true,
      defaultShipping: true,
      customAttributes: [latAttribute, longAttribute],
    );

    showLoadingDialog();
    final response = await _addressRepo.saveAddress(CreateAddressRequest(address: address));
    hideDialog();

    if(!response.isSuccess || response.data == null){
      // TODO: show error popup
      return;
    }

    // TODO: show success popup

    Get.back();
  }
}