import 'package:forwa_app/schema/auth/firebase_token.dart';
import 'package:json_annotation/json_annotation.dart';

part 'save_firebase_token_request.g.dart';

@JsonSerializable()
class SaveFirebaseTokenRequest {

  @JsonKey(name: 'token')
  FirebaseToken token;

  SaveFirebaseTokenRequest({
    required this.token,
  });

  factory SaveFirebaseTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$SaveFirebaseTokenRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SaveFirebaseTokenRequestToJson(this);

}