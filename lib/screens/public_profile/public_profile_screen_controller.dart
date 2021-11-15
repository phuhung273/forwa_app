import 'package:forwa_app/datasource/repository/customer_repo.dart';
import 'package:forwa_app/schema/review/review.dart';
import 'package:forwa_app/screens/base_controller/base_controller.dart';
import 'package:get/get.dart';

class PublicProfileScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PublicProfileScreenController());
  }
}

const customerIdParam = 'customer_id';

class PublicProfileScreenController extends BaseController {

  final CustomerRepo _customerRepo = Get.find();

  int? _customerId;
  final name = ''.obs;
  final rating = 0.0.obs;
  final status = ''.obs;
  final reviews = List<Review>.empty().obs;

  @override
  void onInit() {
    super.onInit();

    _customerId = int.tryParse(Get.parameters[customerIdParam]!);
  }

  @override
  Future onReady() async {
    super.onReady();

    if(_customerId == null){
      return;
    }

    showLoadingDialog();
    final response = await _customerRepo.customerInfo(_customerId!);
    hideDialog();

    if(!response.isSuccess || response.data == null){
      return;
    }
    final customer = response.data!;

    name.value = '${customer.firstName} ${customer.lastName}';
    reviews.assignAll(customer.reviews ?? []);
    rating.value = customer.rating ?? 0.0;
  }
}