import 'package:forwa_app/datasource/repository/address_repo.dart';
import 'package:forwa_app/schema/address/address.dart';
import 'package:forwa_app/screens/base_controller/base_controller.dart';
import 'package:get/get.dart';

class ProfileAddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileAddressScreenController());
  }
}

class ProfileAddressScreenController extends BaseController {

  final AddressRepo _addressRepo = Get.find();

  final addresses = List<Address>.empty().obs;

  @override
  Future onReady() async {
    super.onReady();

    showLoadingDialog();
    final response = await _addressRepo.getMyAddresses();
    hideDialog();

    if(!response.isSuccess || response.data == null){
      // TODO: show error popup
      return;
    }

    addresses.assignAll(response.data!);
  }

  addDefaultAddress(Address address){
    for (final element in addresses) {
      element.isDefault = false;
    }
    addresses.insert(0, address);
  }

  addAddress(Address address){
    addresses.add(address);
  }
}