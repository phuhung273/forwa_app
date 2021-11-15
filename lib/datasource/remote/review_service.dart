import 'package:forwa_app/constants.dart';
import 'package:forwa_app/schema/review/create_review_request.dart';
import 'package:forwa_app/schema/review/review.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'review_service.g.dart';

@RestApi(baseUrl: '$HOST_URL/rest')
abstract class ReviewService {
  factory ReviewService(Dio dio, {String baseUrl}) = _ReviewService;

  @POST('/V2/reviews')
  Future<Review> createReview(@Body() CreateReviewRequest request);
}