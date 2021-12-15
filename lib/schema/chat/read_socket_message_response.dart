import 'package:json_annotation/json_annotation.dart';

part 'read_socket_message_response.g.dart';

@JsonSerializable()
class ReadSocketMessageResponse {

  @JsonKey(name: 'modifiedCount')
  int count;

  ReadSocketMessageResponse({
    required this.count,
  });

  factory ReadSocketMessageResponse.fromJson(Map<String, dynamic> json) =>
      _$ReadSocketMessageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ReadSocketMessageResponseToJson(this);

}