
import 'package:flutter/foundation.dart';
import 'package:forwa_app/datasource/remote/password_service.dart';
import 'package:forwa_app/datasource/repository/base_repo.dart';
import 'package:forwa_app/schema/api_response.dart';
import 'package:forwa_app/schema/password/forgot_password_email_request.dart';
import 'package:forwa_app/schema/password/forgot_password_phone_request.dart';
import 'package:forwa_app/schema/password/forgot_password_phone_response.dart';
import 'package:forwa_app/schema/password/reset_password_phone_request.dart';
import 'package:forwa_app/screens/password_forgot/password_forgot_screen_controller.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

const errorCodeMap = {
  'USER_005': 'Email sai định dạng',
  'USER_007': 'Email chưa đăng ký. Bạn có thể tạo tài khoản',
  'USER_008': 'Vui lòng thử lại sau vài phút',
  'USER_009': 'Số điện thoại chưa đăng ký. Bạn có thể tạo tài khoản'
};

const successMessageMap = {
  ForgotPasswordMethod.email: 'Thành công, vui lòng truy cập email để đặt lại mật khẩu',
  ForgotPasswordMethod.phone: 'Khôi phục mật khẩu thành công',
};

class PasswordRepo extends BaseRepo {
  final PasswordService _service = Get.find();

  Future<ApiResponse> forgotPasswordByEmail(ForgotPasswordEmailRequest request) async {
    return _service.forgotPasswordByEmail(request).catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if(res == null || res.statusCode == HttpStatus.internalServerError) return ApiResponse.fromError();

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          debugPrint(error);
          return ApiResponse.fromError(error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          debugPrint(error);
          return ApiResponse.fromError(error: error);
      }
    });
  }

  Future<ApiResponse<ForgotPasswordPhoneResponse>> forgotPasswordByPhone(ForgotPasswordPhoneRequest request) async {
    return _service.forgotPasswordByPhone(request).catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if(res == null || res.statusCode == HttpStatus.internalServerError) return ApiResponse<ForgotPasswordPhoneResponse>.fromError();

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          debugPrint(error);
          return ApiResponse<ForgotPasswordPhoneResponse>.fromError(error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          debugPrint(error);
          return ApiResponse<ForgotPasswordPhoneResponse>.fromError(error: error);
      }
    });
  }

  Future<ApiResponse> resetPasswordByPhone(ResetPasswordPhoneRequest request) async {
    return _service.resetPasswordByPhone(request).catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if(res == null || res.statusCode == HttpStatus.internalServerError) return ApiResponse.fromError();

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          debugPrint(error);
          return ApiResponse.fromError(error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          debugPrint(error);
          return ApiResponse.fromError(error: error);
      }
    });
  }
}