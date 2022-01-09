import 'package:forwa_app/datasource/local/hidden_product_db.dart';
import 'package:forwa_app/datasource/local/hidden_user_db.dart';
import 'package:forwa_app/datasource/repository/product_repo.dart';
import 'package:forwa_app/datasource/repository/product_report_repo.dart';
import 'package:forwa_app/datasource/repository/user_report_repo.dart';
import 'package:forwa_app/di/location_service.dart';
import 'package:forwa_app/mixins/lazy_load.dart';
import 'package:forwa_app/mixins/reportable.dart';
import 'package:forwa_app/schema/product/lazy_product_request.dart';
import 'package:forwa_app/schema/product/product.dart';
import 'package:forwa_app/schema/product/product_list_request.dart';
import 'package:forwa_app/schema/report/product_report.dart';
import 'package:forwa_app/schema/report/user_report.dart';
import 'package:forwa_app/screens/base_controller/refreshable_controller.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class HomeScreenController extends RefreshableController
    with Reportable, LazyLoad{

  final ProductRepo _productRepo = Get.find();

  final ProductReportRepo _productReportRepo = Get.find();

  final UserReportRepo _userReportRepo = Get.find();

  final LocationService _locationService = Get.find();

  final HiddenProductDB _hiddenProductDB = Get.find();

  final HiddenUserDB _hiddenUserDB = Get.find();

  final products = List<Product>.empty().obs;

  var _hiddenProductIds = List<int>.empty();
  var _hiddenUserIds = List<int>.empty();

  final Distance distance = Get.find();

  LocationData? here;

  DateTime now = DateTime.now();

  late int _lowProductId;
  late int _highProductId;

  @override
  int get listLength => products.length;

  @override
  Future onReady() async {
    super.onReady();

    _locationService.here().then((value) => here = value);

    // await _getHiddenProductIds();

    initLazyLoad();
  }

  @override
  Future main() async {
    now = DateTime.now();
    await _getHiddenProductIds();
    here = await _locationService.here();

    if(here == null || here?.latitude == null || here?.longitude == null){
      return;
    }

    final request = ProductListRequest(
      hiddenUserIds: _hiddenUserIds,
      latitude: here!.latitude!,
      longitude: here!.longitude!,
    );

    final response = await _productRepo.getProducts(request);

    if(!response.isSuccess || response.data == null){
      return;
    }

    final filteredProducts = response.data!.items..removeWhere((element) => _hiddenProductIds.contains(element.id));
    products.assignAll(filteredProducts);
    _calculateEdgeId();
    resetLazyLoad();
  }

  @override
  Future reportProduct(data) async {
    final report = ProductReport.fromJson(data);

    showLoadingDialog();

    final response = await _productReportRepo.create(report);

    hideDialog();
    if(!response.isSuccess || response.data == null){
      return;
    }

    _hiddenProductDB.insert(report.productId);
    products.removeWhere((element) => element.id == report.productId);
  }

  @override
  Future reportUser(data) async {
    final report = UserReport.fromJson(data);

    showLoadingDialog();

    final response = await _userReportRepo.create(report);

    hideDialog();
    if(!response.isSuccess || response.data == null){
      return;
    }

    _hiddenUserDB.insert(report.toUserId).then((record){
      _hiddenUserIds.add(report.toUserId);
    });
    products.removeWhere((element) => element.user?.id == report.toUserId);
  }

  Future _getHiddenProductIds() async {
    _hiddenProductDB.getAll().then((value) => _hiddenProductIds = value);
    _hiddenUserIds = await _hiddenUserDB.getAll();
  }

  @override
  Future onLazyLoad() async {
    now = DateTime.now();
    await _getHiddenProductIds();
    here = await _locationService.here();

    if(here == null || here?.latitude == null || here?.longitude == null){
      return;
    }

    final request = LazyProductRequest(
      hiddenUserIds: _hiddenUserIds,
      latitude: here!.latitude!,
      longitude: here!.longitude!,
      lowProductId: _lowProductId,
      highProductId: _highProductId
    );

    final response = await _productRepo.lazyLoadProduct(request);

    if(!response.isSuccess || response.data == null){
      return;
    }

    final filteredProducts = response.data!..removeWhere((element) => _hiddenProductIds.contains(element.id));
    if(filteredProducts.isEmpty){
      stopLazyLoad();
      return;
    }

    products.addAll(filteredProducts);
    _calculateEdgeId();
  }

  void _calculateEdgeId(){
    _lowProductId = products.first.id!;
    _highProductId = _lowProductId;
    for (var product in products) {
      if(product.id! > _highProductId){
        _highProductId = product.id!;
      }
      if(product.id! < _lowProductId){
        _lowProductId = product.id!;
      }
    }
  }

}