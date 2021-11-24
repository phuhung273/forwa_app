import 'package:dio/dio.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/schema/api_response.dart';
import 'package:forwa_app/schema/auth/email_login_request.dart';
import 'package:forwa_app/schema/auth/login_response.dart';
import 'package:forwa_app/schema/auth/logout_request.dart';
import 'package:forwa_app/schema/auth/phone_login_request.dart';
import 'package:forwa_app/schema/auth/phone_register_request.dart';
import 'package:forwa_app/schema/auth/refresh_token_request.dart';
import 'package:forwa_app/schema/auth/refresh_token_response.dart';
import 'package:forwa_app/schema/auth/email_register_request.dart';
import 'package:forwa_app/schema/auth/social_email_login_request.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_service.g.dart';

@RestApi(baseUrl: '$HOST_URL/api')
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl}) = _AuthService;

  @POST('/login/email')
  Future<ApiResponse<LoginResponse>> emailLogin(@Body() EmailLoginRequest request);

  @POST('/login/phone')
  Future<ApiResponse<LoginResponse>> phoneLogin(@Body() PhoneLoginRequest request);

  @POST('/register/email')
  Future emailRegister(@Body() EmailRegisterRequest request);

  @POST('/register/phone')
  Future phoneRegister(@Body() PhoneRegisterRequest request);

  @POST('/login/social/email')
  Future<ApiResponse<LoginResponse>> socialEmailLogin(@Body() SocialEmailLoginRequest request);

  @POST('/refreshToken')
  Future<ApiResponse<RefreshTokenResponse>> refreshToken(@Body() RefreshTokenRequest request);

  @POST('/logout')
  Future<String> logout(@Body() LogoutRequest request);
}
