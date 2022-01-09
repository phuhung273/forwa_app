import 'package:json_annotation/json_annotation.dart';

part 'lazy_app_notification_request.g.dart';

@JsonSerializable()
class LazyAppNotificationRequest {

  @JsonKey(name: 'take')
  int take;

  @JsonKey(name: 'low_id')
  int lowId;

  LazyAppNotificationRequest({
    this.take = 10,
    required this.lowId,
  });

  factory LazyAppNotificationRequest.fromJson(Map<String, dynamic> json) =>
      _$LazyAppNotificationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LazyAppNotificationRequestToJson(this);

}