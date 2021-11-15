
import 'package:json_annotation/json_annotation.dart';

import 'custom_attribute.dart';
import 'extension_attributes.dart';

class CustomExtensibleData {

  @JsonKey(name: 'custom_attributes')
  List<CustomAttribute>? customAttributes;

  @JsonKey(name: 'extension_attributes')
  ExtensionAttributes? extensionAttributes;

  CustomExtensibleData({
    this.customAttributes,
    this.extensionAttributes,
  });
}