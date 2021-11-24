import 'package:forwa_app/constants.dart';
import 'package:forwa_app/schema/api_response.dart';
import 'package:forwa_app/schema/otp/firebase_otp_request.dart';
import 'package:forwa_app/schema/otp/firebase_otp_response.dart';
import 'package:forwa_app/schema/otp/firebase_verify_otp_request.dart';
import 'package:forwa_app/schema/otp/firebase_verify_otp_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'otp_service.g.dart';

const GOOGLE_IDENTITY_HOST_URL = 'https://identitytoolkit.googleapis.com:443/v1';

@RestApi(baseUrl: GOOGLE_IDENTITY_HOST_URL)
abstract class OtpService {
  factory OtpService(Dio dio, {String baseUrl}) = _OtpService;

  @POST('/accounts:sendVerificationCode?key=$GOOGLE_CLOUD_WEB_API_KEY')
  Future<FirebaseOtpResponse> sendSmsCode(@Body() FirebaseOtpRequest request);

  @POST('/accounts:signInWithPhoneNumber?key=$GOOGLE_CLOUD_WEB_API_KEY')
  Future<FirebaseVerifyOtpResponse> verifyOtp(@Body() FirebaseVerifyOtpRequest request);
}