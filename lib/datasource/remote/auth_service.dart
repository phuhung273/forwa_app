import 'package:dio/dio.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/schema/auth/handshake_response.dart';
import 'package:forwa_app/schema/auth/login_request.dart';
import 'package:forwa_app/schema/auth/login_response.dart';
import 'package:forwa_app/schema/auth/logout_request.dart';
import 'package:forwa_app/schema/auth/register_request.dart';
import 'package:forwa_app/schema/auth/save_firebase_token_request.dart';
import 'package:forwa_app/schema/auth/social_login_request.dart';
import 'package:forwa_app/schema/customer/customer.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_service.g.dart';

@RestApi(baseUrl: '$HOST_URL/rest')
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl}) = _AuthService;

  @POST('/V2/login')
  Future<LoginResponse> login(@Body() LoginRequest request);

  @POST('/V2/register')
  Future<Customer> register(@Body() RegisterRequest request);

  @POST('/V2/socialLogin')
  Future<LoginResponse> socialLogin(@Body() SocialLoginRequest request);

  @POST('/V2/handshake')
  Future<HandshakeResponse> handshake();

  @POST('/V2/logout')
  Future<String> logout(@Body() LogoutRequest request);

  @POST('/V2/firebaseTokens')
  Future<String> saveFirebaseToken(@Body() SaveFirebaseTokenRequest request);
}
