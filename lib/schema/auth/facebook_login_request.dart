import 'package:json_annotation/json_annotation.dart';

part 'facebook_login_request.g.dart';

@JsonSerializable()
class FacebookLoginRequest {

  @JsonKey(name: 'facebook_id')
  String facebookId;

  @JsonKey(name: 'email')
  String? email;

  @JsonKey(name: 'name')
  String? name;

  @JsonKey(name: 'device')
  String device;

  @JsonKey(name: 'firebase_token')
  String firebaseToken;

  @JsonKey(name: 'avatar')
  String? avatar;

  FacebookLoginRequest({
    required this.facebookId,
    this.email,
    this.name,
    required this.device,
    required this.firebaseToken,
    this.avatar,
  });

  factory FacebookLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$FacebookLoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$FacebookLoginRequestToJson(this);

}