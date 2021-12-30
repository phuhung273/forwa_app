import 'package:json_annotation/json_annotation.dart';

part 'social_email_login_request.g.dart';

@JsonSerializable()
class SocialEmailLoginRequest {

  @JsonKey(name: 'email')
  String email;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'device')
  String device;

  @JsonKey(name: 'firebase_token')
  String firebaseToken;

  @JsonKey(name: 'avatar')
  String? avatar;

  SocialEmailLoginRequest({
    required this.email,
    required this.name,
    required this.device,
    required this.firebaseToken,
    this.avatar,
  });

  factory SocialEmailLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$SocialEmailLoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SocialEmailLoginRequestToJson(this);

}