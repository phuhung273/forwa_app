import 'package:forwa_app/datasource/local/hidden_user_db.dart';
import 'package:forwa_app/datasource/repository/user_repo.dart';
import 'package:forwa_app/datasource/repository/user_report_repo.dart';
import 'package:forwa_app/di/analytics/analytic_service.dart';
import 'package:forwa_app/di/notification_service.dart';
import 'package:forwa_app/mixins/reportable.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/report/user_report.dart';
import 'package:forwa_app/schema/review/review.dart';
import 'package:forwa_app/screens/base_controller/base_controller.dart';
import 'package:forwa_app/screens/home/home_screen_controller.dart';
import 'package:get/get.dart';

class PublicProfileScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PublicProfileScreenController());
  }
}

const userIdParam = 'user_id';

class PublicProfileScreenController extends BaseController
    with Reportable {

  final UserRepo _userRepo = Get.find();

  final UserReportRepo _userReportRepo = Get.find();

  final HiddenUserDB _hiddenUserDB = Get.find();

  late HomeScreenController _homeController;

  bool isNotificationStart = false;
  int? userId;
  final name = ''.obs;
  final rating = 0.0.obs;
  final status = ''.obs;
  final reviews = List<Review>.empty().obs;
  final avatar = ''.obs;
  final productsCount = 0.obs;

  @override
  void onInit() {
    super.onInit();

    userId = int.tryParse(Get.parameters[userIdParam]!);

    if(Get.parameters[notificationStartParam] == NOTIFICATION_START_TRUE){
      isNotificationStart = true;
    } else {
      _homeController = Get.find();
    }
  }

  @override
  Future onReady() async {
    super.onReady();

    if(userId == null){
      return;
    }

    showLoadingDialog();
    final response = await _userRepo.userInfo(userId!);
    hideDialog();

    if(!response.isSuccess || response.data == null){
      return;
    }
    final user = response.data!;

    name.value = user.name;
    reviews.assignAll(user.reviews ?? []);
    rating.value = user.rating ?? 0.0;
    avatar.value = user.image?.url ?? '';
    productsCount.value = user.productCount ?? 0;
  }

  @override
  Future reportProduct(data) async {

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

    _hiddenUserDB.insert(report.toUserId);

    if(!isNotificationStart){
      _homeController.products.removeWhere((element) => element.user?.id == report.toUserId);
    }
  }

  static void openScreen(int id){
    Get.toNamed(
      ROUTE_PUBLIC_PROFILE,
      parameters: {
        userIdParam: id.toString()
      }
    );

    final AnalyticService analyticService = Get.find();
    analyticService.logSelectUserItem(id);
  }

  static void openScreenWithNotificationClickBefore(int id){
    Get.toNamed(
      ROUTE_PUBLIC_PROFILE,
      parameters: {
        userIdParam: id.toString(),
        notificationStartParam: NOTIFICATION_START_TRUE
      }
    );

    final AnalyticService analyticService = Get.find();
    analyticService.logSelectUserItem(id);
  }
}