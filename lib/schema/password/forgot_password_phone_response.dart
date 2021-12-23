import 'package:json_annotation/json_annotation.dart';

part 'forgot_password_phone_response.g.dart';

@JsonSerializable()
class ForgotPasswordPhoneResponse {

  @JsonKey(name: 'token')
  String token;

  ForgotPasswordPhoneResponse({
    required this.token,
  });

  factory ForgotPasswordPhoneResponse.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordPhoneResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ForgotPasswordPhoneResponseToJson(this);

}