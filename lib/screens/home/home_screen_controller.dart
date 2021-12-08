import 'package:forwa_app/datasource/local/hidden_product_db.dart';
import 'package:forwa_app/datasource/repository/product_repo.dart';
import 'package:forwa_app/datasource/repository/product_report_repo.dart';
import 'package:forwa_app/di/location_service.dart';
import 'package:forwa_app/mixins/product_reportable.dart';
import 'package:forwa_app/schema/product/product.dart';
import 'package:forwa_app/schema/report/product_report.dart';
import 'package:forwa_app/screens/base_controller/refreshable_controller.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class HomeScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeScreenController());
  }
}

class HomeScreenController extends RefreshableController with ProductReportable{

  final ProductRepo _productRepo = Get.find();

  final ProductReportRepo _productReportRepo = Get.find();

  final LocationService _locationService = Get.find();

  final HiddenProductDB _hiddenProductDB = Get.find();

  final products = List<Product>.empty().obs;

  var _hiddenProductIds = List<int>.empty();

  final Distance distance = Get.find();

  LocationData? here;

  @override
  Future onReady() async {
    super.onReady();

    _locationService.here().then((value) => here = value);

    _getHiddenProductIds();
  }

  @override
  Future main() async {
    _getHiddenProductIds();

    final response = await _productRepo.getProducts();

    if(!response.isSuccess || response.data == null){
      return;
    }

    final filteredProducts = response.data!.items..removeWhere((element) => _hiddenProductIds.contains(element.id));
    products.assignAll(filteredProducts);
  }

  @override
  Future report(data) async {
    final report = ProductReport.fromJson(data);

    showLoadingDialog();

    final response = await _productReportRepo.create(report);

    hideDialog();
    if(!response.isSuccess || response.data == null){
      return;
    }

    products.removeWhere((element) => element.id == data['product_id']);
    // TODO: also save in local storage to not show again
    _hiddenProductDB.insert(data['product_id']);
  }

  void _getHiddenProductIds(){
    _hiddenProductDB.getAll().then((value) => _hiddenProductIds = value);
  }

}