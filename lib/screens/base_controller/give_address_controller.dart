import 'package:forwa_app/schema/address/address.dart';
import 'package:get/get.dart';

class GiveAddressController extends GetxController {

  final street = ''.obs;
  final ward = ''.obs;
  final district = ''.obs;
  final city = ''.obs;
  final phone = ''.obs;
  final name = ''.obs;

  set address(Address address){
    street.value = address.street!;
    ward.value = address.ward!;
    district.value = address.district!;
    city.value = address.city!;
    phone.value = address.phone!;
    name.value = address.name;
  }
}