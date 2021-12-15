import 'package:json_annotation/json_annotation.dart';

part 'read_socket_message.g.dart';

@JsonSerializable()
class ReadSocketMessage {

  @JsonKey(name: 'fromID')
  int fromId;

  ReadSocketMessage({
    required this.fromId,
  });

  factory ReadSocketMessage.fromJson(Map<String, dynamic> json) =>
      _$ReadSocketMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ReadSocketMessageToJson(this);

}