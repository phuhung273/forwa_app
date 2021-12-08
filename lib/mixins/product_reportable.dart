
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/schema/report/product_report.dart';
import 'package:get/get.dart';

const ACTION_REPORT = 'report';

mixin ProductReportable{

  Future report(Map<String, dynamic> data);

  showReportModal(Map<String, dynamic> data) async {
    final context = Get.context;
    if(context == null) return;

    final theme = Theme.of(context);

    final result = await showModalActionSheet<String>(
      context: context,
      style: AdaptiveStyle.material,
      actions: [
        const SheetAction(
          icon: Icons.report,
          label: 'Báo cáo',
          key: ACTION_REPORT,
        ),
      ],
    );

    if(result == ACTION_REPORT){
      final type = await showConfirmationDialog<String>(
        context: context,
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
        await report(data);
      }
    }
  }
}