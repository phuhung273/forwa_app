import 'package:enum_to_string/enum_to_string.dart';
import 'package:json_annotation/json_annotation.dart';

import '../image/image.dart';
import '../product/product.dart';

part 'app_notification.g.dart';

enum AppNotificationType {
  PROCESSING,
  SELECTED,
  UPLOAD,
  CANCEL,
}

const APP_NOTIFICATION_TYPE_PROCESSING = 'processing';
const APP_NOTIFICATION_TYPE_SELECTED = 'selected';
const APP_NOTIFICATION_TYPE_UPLOAD = 'upload';
const APP_NOTIFICATION_TYPE_CANCEL = 'cancel';

enum AppNotificationStatus {
  READ,
  UNREAD,
  CLICKED,
}

@JsonSerializable()
class AppNotification {

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'type')
  String typeString;

  @JsonKey(name: 'status')
  String statusString;

  @JsonKey(name: 'image')
  Image image;

  @JsonKey(name: 'product')
  Product product;

  @JsonKey(name: 'created_at')
  DateTime createdAt;

  AppNotification({
    required this.id,
    required this.typeString,
    required this.image,
    required this.product,
    required this.createdAt,
    required this.statusString,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$AppNotificationToJson(this);

  AppNotificationType? get type => EnumToString.fromString(AppNotificationType.values, typeString.toUpperCase());

  AppNotificationStatus? get status => EnumToString.fromString(AppNotificationStatus.values, statusString.toUpperCase());
}