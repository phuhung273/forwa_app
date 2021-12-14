import 'package:json_annotation/json_annotation.dart';

part 'user_report.g.dart';

enum UserReportType{
  ABUSIVE,
  PERSONAL,
}

const USER_REPORT_TO_USER_ID_PARAM = 'to_user_id';
const USER_REPORT_TYPE_PARAM = 'type';

@JsonSerializable()
class UserReport {

  @JsonKey(name: USER_REPORT_TYPE_PARAM)
  String type;

  @JsonKey(name: USER_REPORT_TO_USER_ID_PARAM)
  int toUserId;

  UserReport({
    required this.type,
    required this.toUserId,
  });

  factory UserReport.fromJson(Map<String, dynamic> json) =>
      _$UserReportFromJson(json);

  Map<String, dynamic> toJson() => _$UserReportToJson(this);

}