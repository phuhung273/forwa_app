
import 'package:flutter/foundation.dart';
import 'package:forwa_app/datasource/remote/app_notification_service.dart';
import 'package:forwa_app/datasource/repository/base_repo.dart';
import 'package:forwa_app/schema/api_response.dart';
import 'package:dio/dio.dart';
import 'package:forwa_app/schema/app_notification/app_notification.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

class AppNotificationRepo extends BaseRepo{

  final AppNotificationService _service = Get.find();

  Future<ApiResponse<List<AppNotification>>> getMyNoti() async {
    return _service.getMyNoti().catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if(res == null || res.statusCode == HttpStatus.internalServerError) return ApiResponse<List<AppNotification>>.fromError();

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          debugPrint(error);
          return ApiResponse<List<AppNotification>>.fromError(error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          debugPrint(error);
          return ApiResponse<List<AppNotification>>.fromError(error: error);
      }
    });
  }

  Future<ApiResponse<List<AppNotification>>> readMyNoti() async {
    return _service.readMyNoti().catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if(res == null || res.statusCode == HttpStatus.internalServerError) return ApiResponse<List<AppNotification>>.fromError();

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          debugPrint(error);
          return ApiResponse<List<AppNotification>>.fromError(error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          debugPrint(error);
          return ApiResponse<List<AppNotification>>.fromError(error: error);
      }
    });
  }
}