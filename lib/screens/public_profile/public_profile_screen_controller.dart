import 'package:forwa_app/datasource/local/hidden_user_db.dart';
import 'package:forwa_app/datasource/repository/user_repo.dart';
import 'package:forwa_app/datasource/repository/user_report_repo.dart';
import 'package:forwa_app/mixins/reportable.dart';
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

class PublicProfileScreenController extends BaseController with Reportable{

  final UserRepo _userRepo = Get.find();

  final UserReportRepo _userReportRepo = Get.find();

  final HiddenUserDB _hiddenUserDB = Get.find();

  final HomeScreenController _homeController = Get.find();

  int? userId;
  final name = ''.obs;
  final rating = 0.0.obs;
  final status = ''.obs;
  final reviews = List<Review>.empty().obs;
  final avatar = ''.obs;

  @override
  void onInit() {
    super.onInit();

    userId = int.tryParse(Get.parameters[userIdParam]!);
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
    _homeController.products.removeWhere((element) => element.user?.id == report.toUserId);
  }
}