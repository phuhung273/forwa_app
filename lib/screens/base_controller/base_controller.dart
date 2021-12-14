import 'package:flutter/material.dart';
import 'package:forwa_app/route/route.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class BaseController extends GetxController{

  void showLoadingDialog(){
    if(Get.isDialogOpen == false){
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
    }
  }

  void hideDialog(){
    if(Get.isDialogOpen == null || Get.isDialogOpen == false) return;
    Get.back();
  }

  Future showSuccessDialog({
    String? title,
    required String message,
    String okLabel = 'Đóng',
  }) async {
    final context = Get.context;
    if(context == null) return;

    final theme = Theme.of(context);

    return Alert(
      context: context,
      type: AlertType.success,
      title: title,
      desc: message,
      style: AlertStyle(
        descStyle: theme.textTheme.bodyText1!,
      ),
      buttons: [
        DialogButton(
          child: Text(
            okLabel,
            style: theme.textTheme.subtitle1?.copyWith(
              color: Colors.white,
            ),
          ),
          color: theme.colorScheme.secondary,
          onPressed: () => Navigator.pop(context),
        )
      ],
    ).show();
  }

  Future showErrorDialog({
    String? title,
    required String message,
    String okLabel = 'Đóng',
  }) async {
    final context = Get.context;
    if(context == null) return;

    final theme = Theme.of(context);

    return Alert(
      context: context,
      type: AlertType.error,
      title: title,
      desc: message,
      style: AlertStyle(
        descStyle: theme.textTheme.bodyText1!,
      ),
      buttons: [
        DialogButton(
          child: Text(
            okLabel,
            style: theme.textTheme.subtitle1?.copyWith(
              color: Colors.white,
            ),
          ),
          color: theme.colorScheme.secondary,
          onPressed: () => Navigator.pop(context),
        )
      ],
    ).show();
  }

  Future showLoginDialog() async {
    final context = Get.context;
    if(context == null) return;

    final theme = Theme.of(context);

    final result = await Alert(
      context: context,
      type: AlertType.info,
      desc: 'Đăng nhập để sử dụng chức năng',
      style: AlertStyle(
        descStyle: theme.textTheme.bodyText1!,
      ),
      buttons: [
        DialogButton(
          child: Text(
            'Đăng nhập',
            style: theme.textTheme.subtitle1?.copyWith(
              color: Colors.white,
            ),
          ),
          color: theme.colorScheme.secondary,
          onPressed: () => Navigator.pop(context, true),
        )
      ],
    ).show();

    if(result == true){
      Get.toNamed(ROUTE_LOGIN);
    }
  }
}