
import 'package:forwa_app/datasource/remote/review_service.dart';
import 'package:forwa_app/datasource/repository/base_repo.dart';
import 'package:forwa_app/schema/api_response.dart';
import 'package:dio/dio.dart';
import 'package:forwa_app/schema/review/create_review_request.dart';
import 'package:forwa_app/schema/review/review.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

class ReviewRepo extends BaseRepo{

  final ReviewService _service = Get.find();

  Future<ApiResponse<Review>> createReview(Review review) async {
    return _service.createReview(review).catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if(res == null || res.statusCode == HttpStatus.internalServerError) return ApiResponse<Review>.fromError();

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          print(error);
          return ApiResponse<Review>.fromError(error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          print(error);
          return ApiResponse<Review>.fromError(error: error);
      }
    });
  }
}