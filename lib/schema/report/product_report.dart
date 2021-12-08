import 'package:json_annotation/json_annotation.dart';

part 'product_report.g.dart';

enum ProductReportType{
  ABUSIVE,
  PERSONAL,
}

const PRODUCT_REPORT_PRODUCT_ID_PARAM = 'product_id';
const PRODUCT_REPORT_USER_ID_PARAM = 'user_id';
const PRODUCT_REPORT_TYPE_PARAM = 'type';

@JsonSerializable()
class ProductReport {

  @JsonKey(name: PRODUCT_REPORT_TYPE_PARAM)
  String type;

  @JsonKey(name: PRODUCT_REPORT_PRODUCT_ID_PARAM)
  int productId;

  @JsonKey(name: PRODUCT_REPORT_USER_ID_PARAM)
  int userId;

  ProductReport({
    required this.type,
    required this.productId,
    required this.userId,
  });

  factory ProductReport.fromJson(Map<String, dynamic> json) =>
      _$ProductReportFromJson(json);

  Map<String, dynamic> toJson() => _$ProductReportToJson(this);

}