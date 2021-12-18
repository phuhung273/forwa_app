import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/repository/app_notification_repo.dart';
import 'package:forwa_app/schema/app_notification/app_notification.dart';
import 'package:forwa_app/screens/base_controller/authorized_refreshable_controller.dart';
import 'package:get/get.dart';

class NotificationScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NotificationScreenController());
  }
}

class NotificationScreenController extends AuthorizedRefreshableController {
  final AppNotificationRepo _appNotificationRepo = Get.find();

  final LocalStorage _localStorage = Get.find();

  final notifications = List<AppNotification>.empty().obs;
  int? _userId;

  DateTime now = DateTime.now();

  @override
  void onInit() {
    super.onInit();

    _userId = _localStorage.getUserID();
  }

  @override
  Future main() async {
    now = DateTime.now();
    final response = await _appNotificationRepo.getMyNoti();

    if(!response.isSuccess || response.data == null){
      return;
    }

    notifications.assignAll(response.data ?? []);
  }

  @override
  bool isAuthorized() {
    _userId = _localStorage.getUserID();
    return _userId != null;
  }
}