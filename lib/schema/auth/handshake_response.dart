import 'package:json_annotation/json_annotation.dart';

part 'handshake_response.g.dart';

@JsonSerializable()
class HandshakeResponse {

  @JsonKey(name: 'access_token')
  String? accessToken;

  HandshakeResponse({
    this.accessToken,
  });

  factory HandshakeResponse.fromJson(Map<String, dynamic> json) =>
      _$HandshakeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HandshakeResponseToJson(this);

}