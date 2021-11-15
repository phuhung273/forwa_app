import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/repository/review_repo.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/review/create_review_request.dart';
import 'package:forwa_app/schema/review/review.dart';
import 'package:forwa_app/screens/base_controller/rating_controller.dart';
import 'package:get/get.dart';
import 'package:rating_dialog/rating_dialog.dart';

class GiveSuccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GiveSuccessScreenController());
  }
}

const customerNameParam = 'customer_name';
const toIdParam = 'to_id';
const productIdParam = 'product_id';

class GiveSuccessScreenController extends RatingController {

  final LocalStorage _localStorage = Get.find();

  final ReviewRepo _reviewRepo = Get.find();

  String? customerName;
  int? fromId;
  int? toId;
  int? productId;

  @override
  void onInit(){
    super.onInit();

    customerName = Get.parameters[customerNameParam];
    fromId = _localStorage.getUserID();
    toId = int.tryParse(Get.parameters[toIdParam]!);
    productId = int.tryParse(Get.parameters[productIdParam]!);
  }

  @override
  void onReady(){
    super.onReady();

    if(customerName == null || fromId == null || toId == null || productId == null) {
      return;
    }
    showRatingDialog(customerName!);
  }

  void submit() {
    Get.offAndToNamed(ROUTE_MAIN);
  }

  @override
  Future onRating(RatingDialogResponse ratingDialogResponse) async {
    final request = CreateReviewRequest(
      review: Review(
        comment: ratingDialogResponse.comment,
        rating: ratingDialogResponse.rating.toInt(),
        fromCustomerId: fromId!,
        toCustomerId: toId!,
        productId: productId!,
      )
    );

    showLoadingDialog();
    final response = await _reviewRepo.createReview(request);
    hideDialog();

    if(!response.isSuccess || response.data == null){
      return;
    }

    hideDialog();
  }
}