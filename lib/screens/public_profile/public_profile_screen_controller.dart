import 'package:forwa_app/datasource/repository/user_repo.dart';
import 'package:forwa_app/schema/review/review.dart';
import 'package:forwa_app/screens/base_controller/base_controller.dart';
import 'package:get/get.dart';

class PublicProfileScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PublicProfileScreenController());
  }
}

const userIdParam = 'user_id';

class PublicProfileScreenController extends BaseController {

  final UserRepo _userRepo = Get.find();

  int? _userId;
  final name = ''.obs;
  final rating = 0.0.obs;
  final status = ''.obs;
  final reviews = List<Review>.empty().obs;

  @override
  void onInit() {
    super.onInit();

    _userId = int.tryParse(Get.parameters[userIdParam]!);
  }

  @override
  Future onReady() async {
    super.onReady();

    if(_userId == null){
      return;
    }

    showLoadingDialog();
    final response = await _userRepo.userInfo(_userId!);
    hideDialog();

    if(!response.isSuccess || response.data == null){
      return;
    }
    final user = response.data!;

    name.value = user.name;
    reviews.assignAll(user.reviews ?? []);
    rating.value = user.rating ?? 0.0;
  }
}