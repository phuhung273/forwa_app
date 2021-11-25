import 'package:forwa_app/constants.dart';
import 'package:forwa_app/schema/api_response.dart';
import 'package:forwa_app/schema/review/review.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'review_service.g.dart';

@RestApi(baseUrl: '$HOST_URL/api/reviews')
abstract class ReviewService {
  factory ReviewService(Dio dio, {String baseUrl}) = _ReviewService;

  @POST('')
  Future<ApiResponse<Review>> createReview(@Body() Review review);
}