import 'package:json_annotation/json_annotation.dart';

part 'media_gallery_entry_content.g.dart';

@JsonSerializable()
class MediaGalleryEntryContent {

  @JsonKey(name: 'type')
  String type;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'base64_encoded_data')
  String base64Data;

  MediaGalleryEntryContent({
    required this.type,
    required this.name,
    required this.base64Data,
  });

  factory MediaGalleryEntryContent.fromJson(Map<String, dynamic> json) =>
      _$MediaGalleryEntryContentFromJson(json);

  Map<String, dynamic> toJson() => _$MediaGalleryEntryContentToJson(this);

}