import 'package:json_annotation/json_annotation.dart';

part 'apple_login_request.g.dart';

@JsonSerializable()
class AppleLoginRequest {

  @JsonKey(name: 'apple_id')
  String appleId;

  @JsonKey(name: 'email')
  String? email;

  @JsonKey(name: 'name')
  String? name;

  @JsonKey(name: 'device')
  String device;

  @JsonKey(name: 'firebase_token')
  String firebaseToken;

  AppleLoginRequest({
    required this.appleId,
    this.email,
    this.name,
    required this.device,
    required this.firebaseToken,
  });

  factory AppleLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$AppleLoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AppleLoginRequestToJson(this);

}