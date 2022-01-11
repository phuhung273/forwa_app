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
const FIELD_ROOM = 'room';
const FIELD_TYPE = 'type';
const FIELD_READ_BY = 'readBy';

@JsonSerializable()
class ChatSocketMessage {

  @JsonKey(name: FIELD_ID)
  String? id;

  @JsonKey(name: FIELD_CONTENT)
  String content;

  @JsonKey(name: FIELD_FROM)
  int from;

  @JsonKey(name: FIELD_ROOM)
  String roomId;

  @JsonKey(name: FIELD_TYPE)
  String type;

  @JsonKey(name: FIELD_READ_BY)
  List<int>? readBy;

  @JsonKey(name: 'createdAt')
  DateTime? createdAt;

  @JsonKey(name: 'updatedAt')
  DateTime? updatedAt;

  ChatSocketMessage({
    this.id,
    required this.content,
    required this.from,
    required this.roomId,
    required this.type,
    this.readBy,
    this.createdAt,
    this.updatedAt,
  });

  factory ChatSocketMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatSocketMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ChatSocketMessageToJson(this);

}