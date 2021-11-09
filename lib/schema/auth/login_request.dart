import 'package:json_annotation/json_annotation.dart';

import 'firebase_token.dart';

part 'login_request.g.dart';

@JsonSerializable()
class LoginRequest {

  @JsonKey(name: 'username')
  String username;

  @JsonKey(name: 'password')
  String password;

  @JsonKey(name: 'firebase_token')
  FirebaseToken firebaseToken;

  LoginRequest({
    required this.username,
    required this.password,
    required this.firebaseToken,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);

}