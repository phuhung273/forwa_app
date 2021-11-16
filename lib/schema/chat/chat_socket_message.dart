import 'package:json_annotation/json_annotation.dart';

part 'chat_socket_message.g.dart';

enum MessageType{
  STRING,
  IMAGE,
  LOCATION,
}

const FIELD_ID = '_id';
const FIELD_CONTENT = 'content';
const FIELD_FROM = 'fromID';
const FIELD_TO = 'toID';
const FIELD_TYPE = 'type';

@JsonSerializable()
class ChatSocketMessage {

  @JsonKey(name: FIELD_ID)
  String? id;

  @JsonKey(name: FIELD_CONTENT)
  String content;

  @JsonKey(name: FIELD_FROM)
  int from;

  @JsonKey(name: FIELD_TO)
  int to;

  @JsonKey(name: FIELD_TYPE)
  String type;

  ChatSocketMessage({
    this.id,
    required this.content,
    required this.from,
    required this.to,
    required this.type,
  });

  factory ChatSocketMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatSocketMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ChatSocketMessageToJson(this);

}