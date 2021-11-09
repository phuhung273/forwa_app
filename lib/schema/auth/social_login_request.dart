import 'package:forwa_app/schema/customer/customer.dart';
import 'package:json_annotation/json_annotation.dart';

import 'firebase_token.dart';

part 'social_login_request.g.dart';

@JsonSerializable()
class SocialLoginRequest {

  @JsonKey(name: 'customer')
  Customer customer;

  @JsonKey(name: 'firebase_token')
  FirebaseToken firebaseToken;

  SocialLoginRequest({
    required this.customer,
    required this.firebaseToken,
  });

  factory SocialLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$SocialLoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SocialLoginRequestToJson(this);

}