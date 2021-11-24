import 'package:json_annotation/json_annotation.dart';

part 'phone_login_request.g.dart';

@JsonSerializable()
class PhoneLoginRequest {

  @JsonKey(name: 'phone')
  String phone;

  @JsonKey(name: 'password')
  String password;

  @JsonKey(name: 'device')
  String device;

  @JsonKey(name: 'firebase_token')
  String firebaseToken;

  PhoneLoginRequest({
    required this.phone,
    required this.password,
    required this.device,
    required this.firebaseToken,
  });

  factory PhoneLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$PhoneLoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PhoneLoginRequestToJson(this);

}