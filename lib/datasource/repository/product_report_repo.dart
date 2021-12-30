
import 'package:flutter/foundation.dart';
import 'package:forwa_app/datasource/remote/product_report_service.dart';
import 'package:forwa_app/datasource/repository/base_repo.dart';
import 'package:forwa_app/schema/api_response.dart';
import 'package:dio/dio.dart';
import 'package:forwa_app/schema/report/product_report.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

class ProductReportRepo extends BaseRepo{

  final ProductReportService _service = Get.find();

  Future<ApiResponse<ProductReport>> create(ProductReport object) async {
    return _service.create(object).catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if(res == null || res.statusCode == HttpStatus.internalServerError) return ApiResponse<ProductReport>.fromError();

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          debugPrint(error);
          return ApiResponse<ProductReport>.fromError(error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          debugPrint(error);
          return ApiResponse<ProductReport>.fromError(error: error);
      }
    });
  }
}