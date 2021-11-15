
import 'package:forwa_app/schema/custom_attribute.dart';
import 'package:json_annotation/json_annotation.dart';

class CustomAttributeData {

  @JsonKey(name: 'custom_attributes')
  List<CustomAttribute>? customAttributes;

  CustomAttributeData({
    this.customAttributes,
  });
}