import 'package:enum_to_string/enum_to_string.dart';
import 'package:json_annotation/json_annotation.dart';

part 'custom_attribute.g.dart';

enum CustomAttributeCode{
  IMAGE,
  SMALL_IMAGE,
  THUMBNAIL,
  PICKUP_TIME,
  DESCRIPTION,
  CATEGORY_IDS,
}

@JsonSerializable()
class CustomAttribute {

  @JsonKey(name: 'attribute_code')
  String attributeCode;

  @JsonKey(name: 'value')
  dynamic value;

  CustomAttribute({
    required this.attributeCode,
    required this.value,
  });

  factory CustomAttribute.fromJson(Map<String, dynamic> json) =>
      _$CustomAttributeFromJson(json);

  Map<String, dynamic> toJson() => _$CustomAttributeToJson(this);

  static getCode(CustomAttributeCode code){
    return EnumToString.convertToString(code).toLowerCase();
  }
}