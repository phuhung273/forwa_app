import 'package:flutter/material.dart';
import 'package:forwa_app/screens/base_controller/base_controller.dart';
import 'package:get/get.dart';
import 'package:rating_dialog/rating_dialog.dart';

const LOGO_SIZE = 70.0;

abstract class RatingController extends BaseController {

  Future onRating(RatingDialogResponse ratingDialogResponse);

  void showRatingDialog(String customerName){
    final context = Get.context;
    if(context == null) return;
    final starSize = MediaQuery.of(context).size.width * 0.08;
    final theme = Theme.of(context);

    final dialog = RatingDialog(
      initialRating: 5.0,
      starSize: starSize,
      // your app's name?
      title: Text(
        customerName,
        textAlign: TextAlign.center,
        style: theme.textTheme.subtitle1,
      ),
      // your app's logo?
      image: Image.asset(
        'assets/images/app_icon_transparent.png',
        width: LOGO_SIZE,
        height: LOGO_SIZE,
      ),
      commentHint: 'Viết nhận xét',
      submitButtonText: 'Gửi',
      onSubmitted: (ratingDialogResponse) async {
        await onRating(ratingDialogResponse);
        hideDialog();
      },
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (context) => Theme(
        data: theme.copyWith(
          inputDecorationTheme: theme.inputDecorationTheme.copyWith(
            border: const UnderlineInputBorder(),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: theme.colorScheme.secondary,
              )
            ),
          ),
          textSelectionTheme: theme.textSelectionTheme.copyWith(
            cursorColor: Colors.black,
          ),
        ),
        child: dialog
      ),
    );
  }
}