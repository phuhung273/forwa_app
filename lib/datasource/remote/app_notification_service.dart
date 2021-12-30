import 'package:forwa_app/constants.dart';
import 'package:forwa_app/schema/api_response.dart';
import 'package:forwa_app/schema/app_notification/app_notification.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'app_notification_service.g.dart';

@RestApi(baseUrl: '$HOST_URL/api/app_notifications')
abstract class AppNotificationService {
  factory AppNotificationService(Dio dio,
      {String baseUrl}) = _AppNotificationService;

  @GET('/')
  Future<ApiResponse<List<AppNotification>>> getMyNoti();

  @GET('/me/read')
  Future<ApiResponse<List<AppNotification>>> readMyNoti();
}