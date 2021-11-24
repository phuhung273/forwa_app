import 'package:forwa_app/datasource/remote/otp_service.dart';
import 'package:forwa_app/datasource/repository/base_repo.dart';
import 'package:forwa_app/schema/api_response.dart';
import 'package:forwa_app/schema/otp/firebase_otp_request.dart';
import 'package:forwa_app/schema/otp/firebase_otp_response.dart';
import 'package:forwa_app/schema/otp/firebase_verify_otp_request.dart';
import 'package:forwa_app/schema/otp/firebase_verify_otp_response.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

class OtpRepo extends BaseRepo {
  final OtpService _service = Get.find();

  Future<ApiResponse<FirebaseOtpResponse>> sendSmsCode(FirebaseOtpRequest request) async {
    return _service.sendSmsCode(request).then((value){
      return ApiResponse<FirebaseOtpResponse>(data: value);
    }).catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if(res == null || res.statusCode == HttpStatus.internalServerError) return ApiResponse<FirebaseOtpResponse>.fromError();

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          print(error);
          return ApiResponse<FirebaseOtpResponse>.fromError(error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          print(error);
          return ApiResponse<FirebaseOtpResponse>.fromError(error: error);
      }
    });
  }

  Future<ApiResponse<FirebaseVerifyOtpResponse>> verifyOtp(FirebaseVerifyOtpRequest request) async {
    return _service.verifyOtp(request).then((value){
      return ApiResponse<FirebaseVerifyOtpResponse>(data: value);
    }).catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if(res == null || res.statusCode == HttpStatus.internalServerError) return ApiResponse<FirebaseVerifyOtpResponse>.fromError();

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          print(error);
          return ApiResponse<FirebaseVerifyOtpResponse>.fromError(error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          print(error);
          return ApiResponse<FirebaseVerifyOtpResponse>.fromError(error: error);
      }
    });
  }
}