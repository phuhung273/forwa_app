import 'package:forwa_app/datasource/repository/review_repo.dart';
import 'package:forwa_app/schema/review/review.dart';
import 'package:forwa_app/screens/base_controller/rating_controller.dart';
import 'package:forwa_app/screens/my_receivings/my_receivings_screen_controller.dart';
import 'package:get/get.dart';
import 'package:rating_dialog/rating_dialog.dart';

class TakeSuccessScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TakeSuccessScreenController());
  }
}

const customerNameParam = 'customer_name';
const toIdParam = 'to_id';
const orderIdParam = 'order_id';

class TakeSuccessScreenController extends RatingController {

  final ReviewRepo _reviewRepo = Get.find();

  final MyReceivingsScreenController _myReceivingsController = Get.find();

  String? customerName;
  int? toId;
  int? orderId;

  @override
  void onInit(){
    super.onInit();

    customerName = Get.parameters[customerNameParam];
    toId = int.tryParse(Get.parameters[toIdParam]!);
    orderId = int.tryParse(Get.parameters[orderIdParam]!);
  }

  @override
  void onReady(){
    super.onReady();

    if(customerName == null) return;
    showRatingDialog(customerName!);
  }

  void submit() {
    Get.back();
  }

  @override
  Future onRating(RatingDialogResponse ratingDialogResponse) async {
    final review = Review(
      message: ratingDialogResponse.comment,
      rating: ratingDialogResponse.rating.toInt(),
      toUserId: toId!,
      orderId: orderId!,
    );

    showLoadingDialog();
    final response = await _reviewRepo.createBuyerReview(review);
    hideDialog();

    if(!response.isSuccess || response.data == null){
      return;
    }

    _myReceivingsController.setSuccessReviewId(orderId!, response.data!.id!);
  }
}