import 'package:forwa_app/constants.dart';
import 'package:forwa_app/schema/api_response.dart';
import 'package:forwa_app/schema/password/forgot_password_email_request.dart';
import 'package:forwa_app/schema/password/forgot_password_phone_request.dart';
import 'package:forwa_app/schema/password/forgot_password_phone_response.dart';
import 'package:forwa_app/schema/password/reset_password_phone_request.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'password_service.g.dart';

@RestApi(baseUrl: '$HOST_URL/api/password')
abstract class PasswordService {
  factory PasswordService(Dio dio, {String baseUrl}) = _PasswordService;

  @POST('/forgot/email')
  Future<ApiResponse> forgotPasswordByEmail(@Body() ForgotPasswordEmailRequest request);

  @POST('/forgot/phone')
  Future<ApiResponse<ForgotPasswordPhoneResponse>> forgotPasswordByPhone(@Body() ForgotPasswordPhoneRequest request);

  @POST('/reset/phone')
  Future<ApiResponse> resetPasswordByPhone(@Body() ResetPasswordPhoneRequest request);
}