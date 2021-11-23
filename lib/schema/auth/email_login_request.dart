import 'package:json_annotation/json_annotation.dart';

import 'firebase_token.dart';

part 'email_login_request.g.dart';

@JsonSerializable()
class EmailLoginRequest {

  @JsonKey(name: 'email')
  String email;

  @JsonKey(name: 'password')
  String password;

  @JsonKey(name: 'device')
  String device;

  @JsonKey(name: 'firebase_token')
  String firebaseToken;

  EmailLoginRequest({
    required this.email,
    required this.password,
    required this.device,
    required this.firebaseToken,
  });

  factory EmailLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$EmailLoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$EmailLoginRequestToJson(this);

}