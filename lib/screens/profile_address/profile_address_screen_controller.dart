import 'package:forwa_app/datasource/repository/customer_repo.dart';
import 'package:forwa_app/schema/address/customer_address_response.dart';
import 'package:forwa_app/screens/base_controller/base_controller.dart';
import 'package:get/get.dart';

class ProfileAddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileAddressScreenController());
  }
}

class ProfileAddressScreenController extends BaseController {

  final CustomerRepo _customerRepo = Get.find();

  final addresses = List<CustomerAddressResponse>.empty().obs;

  @override
  Future onReady() async {
    super.onReady();

    showLoadingDialog();
    final response = await _customerRepo.myInfo();
    hideDialog();

    if(!response.isSuccess || response.data == null){
      // TODO: show error popup
      return;
    }

    addresses.assignAll(response.data!.addresses!);
  }
}