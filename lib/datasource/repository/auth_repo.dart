
import 'package:forwa_app/datasource/remote/auth_service.dart';
import 'package:forwa_app/datasource/repository/base_repo.dart';
import 'package:forwa_app/schema/api_response.dart';
import 'package:forwa_app/schema/auth/handshake_response.dart';
import 'package:forwa_app/schema/auth/handshake_response.dart';
import 'package:forwa_app/schema/auth/handshake_response.dart';
import 'package:forwa_app/schema/auth/handshake_response.dart';
import 'package:forwa_app/schema/auth/handshake_response.dart';
import 'package:forwa_app/schema/auth/login_request.dart';
import 'package:forwa_app/schema/auth/login_response.dart';
import 'package:forwa_app/schema/auth/register_request.dart';
import 'package:forwa_app/schema/auth/social_login_request.dart';
import 'package:forwa_app/schema/customer/customer.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

class AuthRepo extends BaseRepo{
  final AuthService _service = Get.find();

  Future<ApiResponse<LoginResponse>> login(LoginRequest request) async {
    return _service.login(request).then((value){
      return ApiResponse<LoginResponse>(data: value);
    }).catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if(res == null || res.statusCode == HttpStatus.internalServerError) return ApiResponse<LoginResponse>.fromError();

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          print(error);
          return ApiResponse<LoginResponse>.fromError(error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          print(error);
          return ApiResponse<LoginResponse>.fromError(error: error);
      }
    });
  }

  Future<ApiResponse<LoginResponse>> socialLogin(SocialLoginRequest request) async {
    return _service.socialLogin(request).then((value){
      return ApiResponse<LoginResponse>(data: value);
    }).catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if(res == null || res.statusCode == HttpStatus.internalServerError) return ApiResponse<LoginResponse>.fromError();

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          print(error);
          return ApiResponse<LoginResponse>.fromError(error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          print(error);
          return ApiResponse<LoginResponse>.fromError(error: error);
      }
    });
  }

  Future<ApiResponse<Customer>> register(RegisterRequest request) async {
    return _service.register(request).then((value){
      return ApiResponse<Customer>(data: value);
    }).catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if(res == null || res.statusCode == HttpStatus.internalServerError) return ApiResponse<Customer>.fromError();

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          print(error);
          return ApiResponse<Customer>.fromError(error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          print(error);
          return ApiResponse<Customer>.fromError(error: error);
      }
    });
  }

  Future<ApiResponse<HandshakeResponse>> handshake() async {
    return _service.handshake().then((value){
      return ApiResponse<HandshakeResponse>(data: value);
    }).catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if(res == null || res.statusCode == HttpStatus.internalServerError) return ApiResponse<HandshakeResponse>.fromError();

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          print(error);
          return ApiResponse<HandshakeResponse>.fromError(error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          print(error);
          return ApiResponse<HandshakeResponse>.fromError(error: error);
      }
    });
  }
}