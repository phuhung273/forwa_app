import 'package:json_annotation/json_annotation.dart';

part 'forgot_password_phone_request.g.dart';

@JsonSerializable()
class ForgotPasswordPhoneRequest {

  @JsonKey(name: 'phone')
  String phone;

  ForgotPasswordPhoneRequest({
    required this.phone,
  });

  factory ForgotPasswordPhoneRequest.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordPhoneRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ForgotPasswordPhoneRequestToJson(this);

}