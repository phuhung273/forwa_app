import 'package:flutter/material.dart';
import 'package:forwa_app/datasource/local/hidden_product_db.dart';
import 'package:forwa_app/datasource/local/hidden_user_db.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/repository/product_repo.dart';
import 'package:forwa_app/datasource/repository/product_report_repo.dart';
import 'package:forwa_app/datasource/repository/user_report_repo.dart';
import 'package:forwa_app/di/analytics/analytic_service.dart';
import 'package:forwa_app/di/location_service.dart';
import 'package:forwa_app/mixins/lazy_load.dart';
import 'package:forwa_app/mixins/reportable.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/product/lazy_product_request.dart';
import 'package:forwa_app/schema/product/product.dart';
import 'package:forwa_app/schema/product/product_list_request.dart';
import 'package:forwa_app/schema/report/product_report.dart';
import 'package:forwa_app/schema/report/user_report.dart';
import 'package:forwa_app/screens/base_controller/navigation_controller.dart';
import 'package:forwa_app/screens/base_controller/product_controller.dart';
import 'package:forwa_app/screens/base_controller/refreshable_controller.dart';
import 'package:forwa_app/screens/main/main_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class HomeScreenController extends RefreshableController
    with WidgetsBindingObserver, Reportable, LazyLoad {

  final ProductRepo _productRepo = Get.find();
  final ProductReportRepo _productReportRepo = Get.find();
  final UserReportRepo _userReportRepo = Get.find();
  final LocationService _locationService = Get.find();
  final HiddenProductDB _hiddenProductDB = Get.find();
  final HiddenUserDB _hiddenUserDB = Get.find();
  final LocalStorage _localStorage = Get.find();
  final NavigationController _navigationController = Get.find();
  final AnalyticService _analyticService = Get.find();
  final ProductController _productController = Get.find();

  final products = List<Product>.empty().obs;

  var _hiddenProductIds = List<int>.empty();
  var _hiddenUserIds = List<int>.empty();

  final Distance distance = Get.find();

  Position? here;

  DateTime now = DateTime.now();

  late int _lowId;
  late int _highId;

  @override
  int get listLength => products.length;

  String? _uniqueDeviceId;
  String? _deviceName;
  String? _firebaseToken;

  int get pageIndex => HOME_SCREEN_INDEX;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addObserver(this);

    _navigationController.tabStream.listen((event) async {
      if(event == pageIndex){
        _analyticService.setCurrentScreen(ROUTE_HOME);
      }
    });

    _productController.editProductStream.listen(_updateProduct);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if(state == AppLifecycleState.paused){
      // print('Im dead');
    }

    final lastState = WidgetsBinding.instance?.lifecycleState;
    if(lastState == AppLifecycleState.resumed){
      // print('Im alive');
      if(_willBackendSaveLocation()){
        _tellBackendSaveLocation();
        await main();
      }
    }
  }

  @override
  Future onReady() async {
    super.onReady();
    _locationService.here().then((value) => here = value);
    _analyticService.setCurrentScreen(ROUTE_HOME);

    // await _getHiddenProductIds();

    initLazyLoad();
  }

  @override
  Future main() async {
    now = DateTime.now();

    _decideToSaveLocation();

    await _getHiddenProductIds();

    here = await _locationService.here();

    if(here == null){
      await showLocationWarningDialog();
    }

    final request = ProductListRequest(
      hiddenUserIds: _hiddenUserIds,
      latitude: here?.latitude,
      longitude: here?.longitude,
      uniqueDeviceId: _uniqueDeviceId,
      deviceName: _deviceName,
      firebaseToken: _firebaseToken,
    );

    final response = await _productRepo.getProducts(request);

    if(!response.isSuccess || response.data == null){
      return;
    }

    final items = response.data!.items;

    final filteredProducts = items..removeWhere((element) => _hiddenProductIds.contains(element.id));
    products.assignAll(filteredProducts);

    if(items.length < 10){
      stopLazyLoad();
    } else {
      _calculateEdgeId();
      resetLazyLoad();
    }

    if(_didBackendSaveLocation()){
      _handleOnBackendSaveLocation();
    }
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

    final request = LazyProductRequest(
      hiddenUserIds: _hiddenUserIds,
      latitude: here?.latitude,
      longitude: here?.longitude,
      lowId: _lowId,
      highId: _highId
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
    _lowId = products.first.id!;
    _highId = _lowId;
    for (var product in products) {
      if(product.id! > _highId){
        _highId = product.id!;
      }
      if(product.id! < _lowId){
        _lowId = product.id!;
      }
    }
  }

  _decideToSaveLocation() {
    if(_willBackendSaveLocation()){
      _tellBackendSaveLocation();
    } else {
      _tellBackendNotToSaveLocation();
    }
  }

  bool _willBackendSaveLocation() {
    final lastLocationTime = _localStorage.getLocationTime();
    return lastLocationTime == null ||
        DateTime.now().difference(lastLocationTime).inDays > 0;
  }

  bool _didBackendSaveLocation() =>
      _uniqueDeviceId != null && _deviceName != null && _firebaseToken != null && here != null;

  _handleOnBackendSaveLocation(){
    _localStorage.saveLocationTime(DateTime.now());
    _tellBackendNotToSaveLocation();
  }

  _tellBackendSaveLocation(){
    _uniqueDeviceId = _localStorage.getUniqueDeviceId();
    _deviceName = _localStorage.getDeviceName();
    _firebaseToken = _localStorage.getFirebaseToken();
  }

  _tellBackendNotToSaveLocation(){
    _uniqueDeviceId = null;
    _deviceName = null;
    _firebaseToken = null;
  }

  void _updateProduct(Product product) {
    final index = products.indexWhere((element) => element.id == product.id);
    if(index > -1) {
      products[index].name = product.name;
      products[index].images = product.images;
      products.refresh();
    }
  }

  @override
  void onClose(){
    WidgetsBinding.instance?.removeObserver(this);
    super.onClose();
  }
}