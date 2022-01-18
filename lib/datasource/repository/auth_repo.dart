
import 'package:flutter/foundation.dart';
import 'package:forwa_app/datasource/remote/auth_service.dart';
import 'package:forwa_app/datasource/repository/base_repo.dart';
import 'package:forwa_app/schema/api_response.dart';
import 'package:forwa_app/schema/auth/apple_login_request.dart';
import 'package:forwa_app/schema/auth/email_login_request.dart';
import 'package:forwa_app/schema/auth/facebook_login_request.dart';
import 'package:forwa_app/schema/auth/login_response.dart';
import 'package:forwa_app/schema/auth/logout_request.dart';
import 'package:forwa_app/schema/auth/phone_login_request.dart';
import 'package:forwa_app/schema/auth/phone_register_request.dart';
import 'package:forwa_app/schema/auth/refresh_token_request.dart';
import 'package:forwa_app/schema/auth/refresh_token_response.dart';
import 'package:forwa_app/schema/auth/email_register_request.dart';
import 'package:forwa_app/schema/auth/social_email_login_request.dart';
import 'package:forwa_app/screens/register/register_screen_controller.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

const errorCodeMap = {
  'USER_001': 'Email chưa kích hoạt',
  'USER_002': 'Tài khoản/mật khẩu không đúng',
  'USER_003': 'Xác nhận lại mật khẩu',
  'USER_004': 'Email đã tồn tại',
  'USER_005': 'Email sai định dạng',
  'USER_006': 'Số điện thoại đã tồn tại',
  'USER_010': 'Họ tên quá ngắn',
  'USER_011': 'Mật khẩu quá ngắn',
};

const successMessageMap = {
  RegisterMethod.EMAIL: 'Đăng ký thành công, vui lòng kích hoạt email để đăng nhập',
  RegisterMethod.PHONE: 'Đăng ký thành công',
};

class AuthRepo extends BaseRepo{
  final AuthService _service = Get.find();

  Future<ApiResponse<LoginResponse>> emailLogin(EmailLoginRequest request) async {
    return _service.emailLogin(request).catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if(res == null || res.statusCode == HttpStatus.internalServerError) return ApiResponse<LoginResponse>.fromError();

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          debugPrint(error);
          return ApiResponse<LoginResponse>.fromError(error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          debugPrint(error);
          return ApiResponse<LoginResponse>.fromError(error: error);
      }
    });
  }

  Future<ApiResponse<LoginResponse>> phoneLogin(PhoneLoginRequest request) async {
    return _service.phoneLogin(request).catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if(res == null || res.statusCode == HttpStatus.internalServerError) return ApiResponse<LoginResponse>.fromError();

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          debugPrint(error);
          return ApiResponse<LoginResponse>.fromError(error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          debugPrint(error);
          return ApiResponse<LoginResponse>.fromError(error: error);
      }
    });
  }

  Future<ApiResponse<LoginResponse>> socialEmailLogin(SocialEmailLoginRequest request) async {
    return _service.socialEmailLogin(request).catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if(res == null || res.statusCode == HttpStatus.internalServerError) return ApiResponse<LoginResponse>.fromError();

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          debugPrint(error);
          return ApiResponse<LoginResponse>.fromError(error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          debugPrint(error);
          return ApiResponse<LoginResponse>.fromError(error: error);
      }
    });
  }

  Future<ApiResponse<LoginResponse>> appleLogin(AppleLoginRequest request) async {
    return _service.appleLogin(request).catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if(res == null || res.statusCode == HttpStatus.internalServerError) return ApiResponse<LoginResponse>.fromError();

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          debugPrint(error);
          return ApiResponse<LoginResponse>.fromError(error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          debugPrint(error);
          return ApiResponse<LoginResponse>.fromError(error: error);
      }
    });
  }

  Future<ApiResponse<LoginResponse>> facebookLogin(FacebookLoginRequest request) async {
    return _service.facebookLogin(request).catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if(res == null || res.statusCode == HttpStatus.internalServerError) return ApiResponse<LoginResponse>.fromError();

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          debugPrint(error);
          return ApiResponse<LoginResponse>.fromError(error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          debugPrint(error);
          return ApiResponse<LoginResponse>.fromError(error: error);
      }
    });
  }

  Future<ApiResponse<String>> emailRegister(EmailRegisterRequest request) async {
    return _service.emailRegister(request).catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if(res == null || res.statusCode == HttpStatus.internalServerError) return ApiResponse<String>.fromError();

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          debugPrint(error);
          return ApiResponse<String>.fromError(error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          debugPrint(error);
          return ApiResponse<String>.fromError(error: error);
      }
    });
  }

  Future<ApiResponse<String>> phoneRegister(PhoneRegisterRequest request) async {
    return _service.phoneRegister(request).catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if(res == null || res.statusCode == HttpStatus.internalServerError) return ApiResponse<String>.fromError();

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          debugPrint(error);
          return ApiResponse<String>.fromError(error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          debugPrint(error);
          return ApiResponse<String>.fromError(error: error);
      }
    });
  }

  Future<ApiResponse<String>> logout(LogoutRequest request) async {
    return _service.logout(request).then((value){
      return ApiResponse<String>(data: value);
    }).catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if(res == null || res.statusCode == HttpStatus.internalServerError) return ApiResponse<String>.fromError();

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          debugPrint(error);
          return ApiResponse<String>.fromError(error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          debugPrint(error);
          return ApiResponse<String>.fromError(error: error);
      }
    });
  }

  Future<ApiResponse<RefreshTokenResponse>> refreshToken(RefreshTokenRequest request) async {
    return _service.refreshToken(request).catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if(res == null || res.statusCode == HttpStatus.internalServerError) return ApiResponse<RefreshTokenResponse>.fromError();

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          debugPrint(error);
          return ApiResponse<RefreshTokenResponse>.fromError(error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          debugPrint(error);
          return ApiResponse<RefreshTokenResponse>.fromError(error: error);
      }
    });
  }
}