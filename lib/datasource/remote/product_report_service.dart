import 'package:forwa_app/schema/api_response.dart';
import 'package:forwa_app/schema/report/product_report.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../../constants.dart';

part 'product_report_service.g.dart';

@RestApi(baseUrl: '$HOST_URL/api/product_reports')
abstract class ProductReportService {
  factory ProductReportService(Dio dio,
      {String baseUrl}) = _ProductReportService;

  @POST('/')
  Future<ApiResponse<ProductReport>> create(@Body() ProductReport object);
}