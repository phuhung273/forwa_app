
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/repository/app_notification_repo.dart';
import 'package:forwa_app/mixins/lazy_load.dart';
import 'package:forwa_app/schema/app_notification/lazy_app_notification_request.dart';
import 'package:forwa_app/screens/base_controller/app_notification_controller.dart';
import 'package:forwa_app/screens/base_controller/main_tab_controller.dart';
import 'package:forwa_app/screens/main/main_screen.dart';
import 'package:get/get.dart';

class NotificationScreenController extends MainTabController
    with LazyLoad {

  final AppNotificationRepo _appNotificationRepo = Get.find();

  final AppNotificationController _appNotificationController = Get.find();

  final LocalStorage _localStorage = Get.find();

  int? _userId;

  DateTime now = DateTime.now();

  @override
  int get pageIndex => NOTIFICATION_SCREEN_INDEX;

  @override
  int get listLength => _appNotificationController.notifications.length;

  @override
  int get stepToLoad => 1;

  late int _lowId;

  @override
  Future<bool> onReady() async {
    if(!isAuthorized()){
      showLoginDialog();
      return false;
    }

    initLazyLoad();
    await main();
    return true;
  }

  @override
  Future main() async {
    _userId = _localStorage.getUserID();
    now = DateTime.now();

    final response = await _appNotificationRepo.readMyNoti();

    if(!response.isSuccess || response.data == null){
      return;
    }

    final items = response.data!;
    _appNotificationController.assignAll(items);

    if(items.length < 10){
      stopLazyLoad();
    } else {
      _calculateEdgeId();
      resetLazyLoad();
    }
  }

  @override
  Future onLazyLoad() async {
    final request = LazyAppNotificationRequest(
        lowId: _lowId
    );

    final response = await _appNotificationRepo.lazyLoadMine(request);

    if(!response.isSuccess || response.data == null){
      return;
    }

    final newItems = response.data!;
    if(newItems.isEmpty){
      stopLazyLoad();
      return;
    }

    _appNotificationController.notifications.addAll(newItems);
    _calculateEdgeId();
  }

  void _calculateEdgeId(){
    _lowId = _appNotificationController.notifications.first.id;
    for (var item in _appNotificationController.notifications) {
      if(item.id < _lowId){
        _lowId = item.id;
      }
    }
  }

  @override
  void cleanData(){
    _appNotificationController.clear();
  }

  @override
  bool isAuthorized() {
    _userId = _localStorage.getUserID();
    return _userId != null;
  }
}