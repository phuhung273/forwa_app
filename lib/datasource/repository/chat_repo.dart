import 'package:forwa_app/datasource/remote/chat_api_service.dart';
import 'package:forwa_app/schema/api_response.dart';
import 'package:forwa_app/schema/chat/chat_unread_response.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

import 'base_repo.dart';

class ChatRepo extends BaseRepo {
  final ChatApiService _service = Get.find();

  Future<ApiResponse<ChatUnreadResponse>> getUnread() async {
    return _service.getUnread().catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if (res == null || res.statusCode == HttpStatus.internalServerError) {
            return ApiResponse<ChatUnreadResponse>.fromError();
          }

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          print(error);
          return ApiResponse<ChatUnreadResponse>.fromError(
              error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          print(error);
          return ApiResponse<ChatUnreadResponse>.fromError(error: error);
      }
    });
  }
}