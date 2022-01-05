import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/repository/app_notification_repo.dart';
import 'package:forwa_app/schema/app_notification/app_notification.dart';
import 'package:get/get.dart';

class AppNotificationController extends GetxController {

  final AppNotificationRepo _appNotificationRepo = Get.find();

  final LocalStorage _localStorage = Get.find();

  final notifications = List<AppNotification>.empty().obs;
  int? _userId;

  final myGivingCount = 0.obs;
  final myReceivingCount = 0.obs;
  final notificationCount = 0.obs;

  @override
  void onInit() {
    super.onInit();

    _userId = _localStorage.getUserID();
  }

  @override
  void onReady() {
    super.onReady();

    main();
  }

  Future main() async {
    if(_userId == null) return;

    final response = await _appNotificationRepo.getMyNoti();

    if(!response.isSuccess || response.data == null){
      return;
    }

    final data = response.data!;
    notifications.assignAll(data);

    myGivingCount.value = data.fold(0, (previousValue, element) =>
      element.status != AppNotificationStatus.CLICKED && element.type == AppNotificationType.PROCESSING
        ? previousValue + 1
        : previousValue
    );

    myReceivingCount.value = data.fold(0, (previousValue, element) =>
      element.status != AppNotificationStatus.CLICKED && element.type == AppNotificationType.SELECTED
          ? previousValue + 1
          : previousValue
    );

    notificationCount.value = data.fold(0, (previousValue, element) =>
      element.status == AppNotificationStatus.UNREAD
          ? previousValue + 1
          : previousValue
    );
  }

  void readMyGiving(){
    myGivingCount.value = 0;
  }

  void readMyReceiving(){
    myReceivingCount.value = 0;
  }

  void readMyNotification(){
    notificationCount.value = 0;
  }

  void increaseMyGiving(AppNotification notification){
    myGivingCount.value++;
    notificationCount.value++;
    _addNotification(notification);
  }

  void increaseMyReceiving(AppNotification notification){
    myReceivingCount.value++;
    notificationCount.value++;
    _addNotification(notification);
  }

  void _addNotification(AppNotification notification){
    notifications.insert(0, notification);
  }
}