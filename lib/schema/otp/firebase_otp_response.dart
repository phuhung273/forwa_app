import 'package:json_annotation/json_annotation.dart';

part 'firebase_otp_response.g.dart';

@JsonSerializable()
class FirebaseOtpResponse {

  @JsonKey(name: 'sessionInfo')
  String sessionInfo;

  FirebaseOtpResponse({
    required this.sessionInfo,
  });

  factory FirebaseOtpResponse.fromJson(Map<String, dynamic> json) =>
      _$FirebaseOtpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseOtpResponseToJson(this);

}