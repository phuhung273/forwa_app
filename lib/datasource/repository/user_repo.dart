
import 'package:forwa_app/datasource/remote/user_service.dart';
import 'package:forwa_app/datasource/repository/base_repo.dart';
import 'package:forwa_app/schema/api_response.dart';
import 'package:forwa_app/schema/user/user.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

class UserRepo extends BaseRepo {
  final UserService _service = Get.find();

  Future<ApiResponse<User>> userInfo(int customerId) async {
    return _service.userInfo(customerId).catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if(res == null || res.statusCode == HttpStatus.internalServerError) return ApiResponse<User>.fromError();

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          print(error);
          return ApiResponse<User>.fromError(error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          print(error);
          return ApiResponse<User>.fromError(error: error);
      }
    });
  }
}