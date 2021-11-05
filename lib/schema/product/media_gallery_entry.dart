import 'package:forwa_app/schema/product/media_gallery_entry_content.dart';
import 'package:json_annotation/json_annotation.dart';

part 'media_gallery_entry.g.dart';

@JsonSerializable()
class MediaGalleryEntry {

  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'media_type')
  String mediaType;

  @JsonKey(name: 'label')
  String label;

  @JsonKey(name: 'types')
  List<String> types;

  @JsonKey(name: 'content')
  MediaGalleryEntryContent? content;

  MediaGalleryEntry({
    this.id,
    this.mediaType = 'image',
    this.label = 'Image',
    this.types = const ['image', 'small_image', 'thumbnail'],
    this.content,
  });

  factory MediaGalleryEntry.fromJson(Map<String, dynamic> json) =>
      _$MediaGalleryEntryFromJson(json);

  Map<String, dynamic> toJson() => _$MediaGalleryEntryToJson(this);

}