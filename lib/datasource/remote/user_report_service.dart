import 'package:forwa_app/constants.dart';
import 'package:forwa_app/schema/api_response.dart';
import 'package:forwa_app/schema/report/user_report.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'user_report_service.g.dart';

@RestApi(baseUrl: '$HOST_URL/api/user_reports')
abstract class UserReportService {
  factory UserReportService(Dio dio, {String baseUrl}) = _UserReportService;

  @POST('/')
  Future<ApiResponse<UserReport>> create(@Body() UserReport object);
}