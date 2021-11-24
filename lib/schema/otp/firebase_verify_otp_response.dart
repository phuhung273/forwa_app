import 'package:json_annotation/json_annotation.dart';

part 'firebase_verify_otp_response.g.dart';

@JsonSerializable()
class FirebaseVerifyOtpResponse {

  @JsonKey(name: 'phoneNumber')
  String phone;

  FirebaseVerifyOtpResponse({
    required this.phone,
  });

  factory FirebaseVerifyOtpResponse.fromJson(Map<String, dynamic> json) =>
      _$FirebaseVerifyOtpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseVerifyOtpResponseToJson(this);

}