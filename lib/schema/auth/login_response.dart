import 'package:forwa_app/schema/customer/customer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {

  @JsonKey(name: 'access_token')
  String accessToken;

  @JsonKey(name: 'user_name')
  String username;

  @JsonKey(name: 'user_id')
  int userId;

  LoginResponse({
    required this.accessToken,
    required this.username,
    required this.userId,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);

}