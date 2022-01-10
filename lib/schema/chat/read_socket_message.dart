import 'package:json_annotation/json_annotation.dart';

part 'read_socket_message.g.dart';

@JsonSerializable()
class ReadSocketMessage {

  @JsonKey(name: 'roomID')
  String roomId;

  ReadSocketMessage({
    required this.roomId,
  });

  factory ReadSocketMessage.fromJson(Map<String, dynamic> json) =>
      _$ReadSocketMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ReadSocketMessageToJson(this);

}