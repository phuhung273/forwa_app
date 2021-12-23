import 'package:json_annotation/json_annotation.dart';

part 'forgot_password_email_request.g.dart';

@JsonSerializable()
class ForgotPasswordEmailRequest {

  @JsonKey(name: 'email')
  String email;

  ForgotPasswordEmailRequest({
    required this.email,
  });

  factory ForgotPasswordEmailRequest.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordEmailRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ForgotPasswordEmailRequestToJson(this);

}