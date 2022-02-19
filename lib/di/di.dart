
import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/datasource/local/hidden_product_db.dart';
import 'package:forwa_app/datasource/local/hidden_user_db.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/local/persistent_local_storage.dart';
import 'package:forwa_app/datasource/remote/address_service.dart';
import 'package:forwa_app/datasource/remote/app_notification_service.dart';
import 'package:forwa_app/datasource/remote/auth_service.dart';
import 'package:forwa_app/datasource/remote/chat_api_service.dart';
import 'package:forwa_app/datasource/remote/product_report_service.dart';
import 'package:forwa_app/datasource/remote/user_report_service.dart';
import 'package:forwa_app/datasource/remote/user_service.dart';
import 'package:forwa_app/datasource/remote/order_service.dart';
import 'package:forwa_app/datasource/remote/product_service.dart';
import 'package:forwa_app/datasource/remote/review_service.dart';
import 'package:forwa_app/datasource/repository/address_repo.dart';
import 'package:forwa_app/datasource/repository/app_notification_repo.dart';
import 'package:forwa_app/datasource/repository/auth_repo.dart';
import 'package:forwa_app/datasource/repository/chat_repo.dart';
import 'package:forwa_app/datasource/repository/product_report_repo.dart';
import 'package:forwa_app/datasource/repository/user_repo.dart';
import 'package:forwa_app/datasource/repository/order_repo.dart';
import 'package:forwa_app/datasource/repository/product_repo.dart';
import 'package:forwa_app/datasource/repository/review_repo.dart';
import 'package:forwa_app/datasource/repository/user_report_repo.dart';
import 'package:forwa_app/di/analytics/analytic_service.dart';
import 'package:forwa_app/di/google_place_service.dart';
import 'package:forwa_app/di/location_service.dart';
import 'package:forwa_app/di/notification_service.dart';
import 'package:forwa_app/screens/base_controller/navigation_controller.dart';
import 'package:forwa_app/screens/base_controller/chat_controller.dart';
import 'package:forwa_app/screens/base_controller/order_controller.dart';
import 'package:forwa_app/screens/base_controller/product_success_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:latlong2/latlong.dart';
import 'package:socket_io_client/socket_io_client.dart';

Future configureDependenciesBeforeFirebase() async {
  await GetStorage.init();

  Get.put(LocalStorage());
  Get.lazyPut(() => PersistentLocalStorage());


  _configureApiClient();
  _configureSocketIO();

  Get.put(HiddenProductDB.instance);
  Get.put(HiddenUserDB.instance);

  Get.put(AuthService(Get.find()));
  Get.put(AuthRepo());
  Get.put(ProductService(Get.find()));
  Get.put(ProductRepo());
  Get.put(OrderService(Get.find()));
  Get.put(OrderRepo());
  Get.put(UserService(Get.find()));
  Get.put(UserRepo());
  Get.put(AddressService(Get.find()));
  Get.put(AddressRepo());
  Get.put(ReviewService(Get.find()));
  Get.put(ReviewRepo());
  Get.put(ProductReportService(Get.find()));
  Get.put(ProductReportRepo());
  Get.put(UserReportService(Get.find()));
  Get.put(UserReportRepo());
  Get.put(ChatApiService(Get.find()));
  Get.put(ChatRepo());
  Get.put(AppNotificationService(Get.find()));
  Get.put(AppNotificationRepo());

  Get.put(ChatController());
  Get.put(NavigationController());
  Get.put(ProductSuccessController());
  Get.put(OrderController());

  Get.put(GoogleSignIn());
  Get.put(LocationService());
  Get.put(const Distance());
  Get.put(FlutterLocalNotificationsPlugin());
  Get.put(GooglePlaceService());

}

Future configureDependenciesAfterFirebase() async {
  Get.put(AnalyticService());
  Get.put(NotificationService());
}

void _configureSocketIO() {
  final Socket socket = io(CHAT_HOST_URL,
      OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build()
  );
  Get.put(socket);
}

void _configureApiClient(){
  final dio = Dio(BaseOptions(
    contentType: 'application/json',
    connectTimeout: 10000,
  ));

  dio.interceptors.addAll([
    LogInterceptor(
      requestBody: true,
      responseBody: true,
    ),
    InterceptorsWrapper(
      onRequest: (RequestOptions options, handler) {

        final LocalStorage localStorage = Get.find();

        final accessToken = localStorage.getAccessToken();
        // Do something before request is sent

        if(accessToken != null){
          options.headers['Authorization'] = 'Bearer $accessToken';
        }

        options.headers['Accept'] = 'application/json';
        options.headers['Content-Type'] = 'application/json';
        return handler.next(options);
      }
    ),
  ]);

  Get.put(dio);
}