
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/schema/report/product_report.dart';
import 'package:forwa_app/schema/report/user_report.dart';
import 'package:forwa_app/screens/home/home_screen.dart';
import 'package:get/get.dart';

const ACTION_REPORT_PRODUCT = 'report_product';
const ACTION_REPORT_USER = 'report_user';

enum ReportType{
  PRODUCT,
  USER,
}

mixin Reportable{

  Future reportProduct(Map<String, dynamic> data);
  Future reportUser(Map<String, dynamic> data);

  showReportModal(Map<String, dynamic> data, List<ReportType> reportTypes) async {
    final context = Get.context;
    if(context == null) return;

    final theme = Theme.of(context);

    final result = await showModalActionSheet<String>(
      context: context,
      style: AdaptiveStyle.material,
      actions: [
        if(reportTypes.contains(ReportType.USER))
          const SheetAction(
            icon: Icons.person_off,
            label: 'Báo cáo người dùng',
            key: ACTION_REPORT_USER,
          ),
        if(reportTypes.contains(ReportType.PRODUCT))
          const SheetAction(
            icon: Icons.report,
            label: 'Báo cáo sản phẩm',
            key: ACTION_REPORT_PRODUCT,
          ),
      ],
    );

    switch(result){
      case ACTION_REPORT_PRODUCT:
        _reportProduct(data);
        break;
      case ACTION_REPORT_USER:
        _reportUser(data);
        break;
      default:
        break;
    }
  }

  Future _reportProduct(Map<String, dynamic> data) async {
    final context = Get.context;
    if(context == null) return;

    final theme = Theme.of(context);

    final type = await showConfirmationDialog<String>(
      context: context,
      style: AdaptiveStyle.material,
      title: 'Báo cáo bài đăng',
      message: 'Vì sao bài đăng này không phù hợp với bạn?',
      okLabel: 'Gửi',
      cancelLabel: 'Hủy',
      actions: [
        AlertDialogAction(
          label: 'Nội dung không hợp lệ',
          textStyle: theme.textTheme.bodyText1!,
          key: EnumToString.convertToString(ProductReportType.ABUSIVE).toLowerCase(),
        ),
        AlertDialogAction(
          label: 'Lý do cá nhân',
          textStyle: theme.textTheme.bodyText1!,
          key: EnumToString.convertToString(ProductReportType.PERSONAL).toLowerCase(),
        ),
      ],
    );

    if(type != null){
      data[PRODUCT_REPORT_TYPE_PARAM] = type;
      data[PRODUCT_REPORT_USER_ID_PARAM] = data[REPORT_USER_ID];
      data[PRODUCT_REPORT_PRODUCT_ID_PARAM] = data[REPORT_PRODUCT_ID];
      await reportProduct(data);
    }
  }

  Future _reportUser(Map<String, dynamic> data) async {
    final context = Get.context;
    if(context == null) return;

    final theme = Theme.of(context);

    final type = await showConfirmationDialog<String>(
      context: context,
      style: AdaptiveStyle.material,
      title: 'Chặn người dùng',
      message: 'Vì sao bạn muốn chặn người dùng này?',
      okLabel: 'Gửi',
      cancelLabel: 'Hủy',
      actions: [
        AlertDialogAction(
          label: 'Đăng nội dung không phù hợp',
          textStyle: theme.textTheme.bodyText1!,
          key: EnumToString.convertToString(UserReportType.ABUSIVE).toLowerCase(),
        ),
        AlertDialogAction(
          label: 'Lý do cá nhân',
          textStyle: theme.textTheme.bodyText1!,
          key: EnumToString.convertToString(UserReportType.PERSONAL).toLowerCase(),
        ),
      ],
    );

    if(type != null){
      data[USER_REPORT_TYPE_PARAM] = type;
      data[USER_REPORT_TO_USER_ID_PARAM] = data[PRODUCT_REPORT_USER_ID_PARAM];
      await reportUser(data);
    }
  }
}