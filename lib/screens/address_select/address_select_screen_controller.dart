import 'package:forwa_app/datasource/repository/address_repo.dart';
import 'package:forwa_app/schema/address/address.dart';
import 'package:forwa_app/screens/base_controller/base_controller.dart';
import 'package:get/get.dart';

class AddressSelectScreenController extends BaseController {

  var _alreadyFetch = false;

  final id = 0.obs;
  int? _prefetchId;

  final AddressRepo _addressRepo = Get.find();

  final addresses = List<Address>.empty().obs;

  selectAddress(int index){
    id.value = addresses[index].id ?? 0;
    addresses.refresh();
  }

  addDefaultAddress(Address address){
    for (final element in addresses) {
      element.isDefault = false;
    }
    addresses.insert(0, address);
    selectAddress(0);
  }

  addAddress(Address address){
    addresses.add(address);
    selectAddress(addresses.length - 1);
  }

  Future<bool> fetchMyAddress() async {
    if(_alreadyFetch) return true;

    final response = await _addressRepo.getMyAddresses();
    if(!response.isSuccess || response.data == null){
      return false;
    }

    addresses.assignAll(response.data ?? []);

    if(addresses.isEmpty){
      _alreadyFetch = true;
      return true;
    }

    if(_prefetchId != null){
      id.value = _prefetchId!;
      _prefetchId = null;
    } else {
      try{
        final defaultAddress = addresses.firstWhere((element) => element.isDefault == true);
        id.value = defaultAddress.id ?? 0;
      } on StateError {
        id.value = addresses.first.id ?? 0;
      }
    }

    _alreadyFetch = true;
    return true;
  }

  set prefetchId(int value) {
    _prefetchId = value;
    id.value = value;
  }

}