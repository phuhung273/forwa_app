
import 'package:json_annotation/json_annotation.dart';

import 'extension_attributes.dart';

class ExtensionAttributeData{

  @JsonKey(name: 'extension_attributes')
  ExtensionAttributes? extensionAttributes;

  ExtensionAttributeData({
    this.extensionAttributes,
  });
}