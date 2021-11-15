import 'package:json_annotation/json_annotation.dart';
import 'review.dart';

part 'create_review_request.g.dart';

@JsonSerializable()
class CreateReviewRequest {

  @JsonKey(name: 'review')
  Review review;

  CreateReviewRequest({
    required this.review,
  });

  factory CreateReviewRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateReviewRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateReviewRequestToJson(this);

}