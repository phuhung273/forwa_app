import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/route/route.dart';
import 'package:get/get.dart';

class BaseController extends GetxController{

  void showLoadingDialog(){
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
  }

  void hideDialog(){
    if(Get.isDialogOpen == null || Get.isDialogOpen == false) return;
    Get.back();
  }

  // void showErrorDialog({
  //   String title = 'Lỗi',
  //   required String message,
  //   String? textConfirm,
  //   VoidCallback? onConfirm,
  //   String? textCancel,
  //   VoidCallback? onCancel,
  // }){
  //   Get.defaultDialog(
  //     title: title,
  //     titleStyle: const TextStyle(color: Colors.red),
  //     middleText: message,
  //     textConfirm: textConfirm,
  //     onConfirm: onConfirm,
  //     textCancel: textCancel,
  //     onCancel: onCancel,
  //   );
  // }

  Future showLoginDialog() async {
    final context = Get.context;
    if(context == null) return;

    final result = await showOkAlertDialog(
      context: context,
      message: 'Đăng nhập để sử dụng chức năng',
      okLabel: 'Đăng nhập',
    );

    if(result == OkCancelResult.ok){
      Get.toNamed(ROUTE_LOGIN);
    }
  }
}