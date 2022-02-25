import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/repository/address_repo.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/address/address.dart';
import 'package:forwa_app/screens/address_select/address_select_screen_controller.dart';
import 'package:forwa_app/screens/base_screens/edit_address/edit_address_controller.dart';
import 'package:forwa_app/screens/profile_address/profile_address_screen_controller.dart';
import 'package:get/get.dart';

class CreateProfileAddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateProfileAddressController());
  }
}

class CreateProfileAddressController extends EditAddressScreenController {

  final LocalStorage _localStorage = Get.find();

  final AddressRepo _addressRepo = Get.find();

  late ProfileAddressScreenController _profileAddressController;
  late AddressSelectScreenController _addressSelectController;

  String? _name;
  String? _previousRoute;

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
  Future save() async {
    if(_name == null || _previousRoute == null){
      return;
    }

    if(detailsResult == null){
      showErrorDialog(message: 'Vui lòng nhập và chọn địa chỉ');
      return;
    }

    showLoadingDialog();

    final location = detailsResult!.geometry!.location;

    final addressRequest = Address(
      text: detailsResult!.formattedAddress!,
      name: _name!,
      phone: phoneController.text,
      isDefault: isDefault.value,
      latitude: location!.lat.toString(),
      longitude: location.lng.toString(),
    );

    final response = await _addressRepo.storeAddress(addressRequest);
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
}