import 'package:flutter/material.dart';
import 'package:forwa_app/screens/base_controller/base_controller.dart';
import 'package:get/get.dart';
import 'package:rating_dialog/rating_dialog.dart';

class RatingController extends BaseController {


  void showRatingDialog(String customerName){
    final context = Get.context;
    if(context == null) return;
    final starSize = MediaQuery.of(context).size.width * 0.1;

    final dialog = RatingDialog(
      initialRating: 5.0,
      starSize: starSize,
      // your app's name?
      title: Text(
        customerName,
        textAlign: TextAlign.center,
      ),
      // // your app's logo?
      // image: const FlutterLogo(size: 100),
      commentHint: 'Nhập đánh giá',
      submitButtonText: 'Gửi',
      onSubmitted: (response) {
        print('rating: ${response.rating}, comment: ${response.comment}');
      },
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (context) => dialog,
    );
  }
}