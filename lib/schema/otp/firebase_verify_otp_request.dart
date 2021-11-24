import 'package:json_annotation/json_annotation.dart';

part 'firebase_verify_otp_request.g.dart';

@JsonSerializable()
class FirebaseVerifyOtpRequest {

  @JsonKey(name: 'sessionInfo')
  String sessionInfo;

  @JsonKey(name: 'code')
  String code;

  FirebaseVerifyOtpRequest({
    required this.sessionInfo,
    required this.code,
  });

  factory FirebaseVerifyOtpRequest.fromJson(Map<String, dynamic> json) =>
      _$FirebaseVerifyOtpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseVerifyOtpRequestToJson(this);

}