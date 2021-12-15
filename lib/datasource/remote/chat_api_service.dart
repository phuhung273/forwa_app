import 'package:forwa_app/constants.dart';
import 'package:forwa_app/schema/api_response.dart';
import 'package:forwa_app/schema/chat/chat_unread_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'chat_api_service.g.dart';

@RestApi(baseUrl: '$CHAT_HOST_URL')
abstract class ChatApiService {
  factory ChatApiService(Dio dio, {String baseUrl}) = _ChatApiService;

  @GET('/messages/unread')
  Future<ApiResponse<ChatUnreadResponse>> getUnread();
}