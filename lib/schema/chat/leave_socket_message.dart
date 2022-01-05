import 'package:json_annotation/json_annotation.dart';

part 'leave_socket_message.g.dart';

@JsonSerializable()
class LeaveSocketMessage {

  @JsonKey(name: 'fromID')
  int fromId;

  LeaveSocketMessage({
    required this.fromId,
  });

  factory LeaveSocketMessage.fromJson(Map<String, dynamic> json) =>
      _$LeaveSocketMessageFromJson(json);

  Map<String, dynamic> toJson() => _$LeaveSocketMessageToJson(this);

}