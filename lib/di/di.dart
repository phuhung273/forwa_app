
import 'package:dio/dio.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/remote/address_service.dart';
import 'package:forwa_app/datasource/remote/auth_service.dart';
import 'package:forwa_app/datasource/remote/cart_service.dart';
import 'package:forwa_app/datasource/remote/customer_service.dart';
import 'package:forwa_app/datasource/remote/order_service.dart';
import 'package:forwa_app/datasource/remote/product_service.dart';
import 'package:forwa_app/datasource/repository/address_repo.dart';
import 'package:forwa_app/datasource/repository/auth_repo.dart';
import 'package:forwa_app/datasource/repository/cart_repo.dart';
import 'package:forwa_app/datasource/repository/customer_repo.dart';
import 'package:forwa_app/datasource/repository/order_repo.dart';
import 'package:forwa_app/datasource/repository/product_repo.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future configureDependencies() async {
  await GetStorage.init();

  Get.put(LocalStorage());

  _configureApiClient();

  Get.put(AuthService(Get.find()));
  Get.put(AuthRepo());
  Get.put(ProductService(Get.find()));
  Get.put(ProductRepo());
  Get.put(CartService(Get.find()));
  Get.put(CartRepo());
  Get.put(OrderService(Get.find()));
  Get.put(OrderRepo());
  Get.put(CustomerService(Get.find()));
  Get.put(CustomerRepo());
  Get.put(AddressService(Get.find()));
  Get.put(AddressRepo());

  Get.put(GoogleSignIn());

}

void _configureApiClient(){
  final dio = Dio(BaseOptions(
    contentType: 'application/json',
    connectTimeout: 60000,
  ));

  dio.interceptors.addAll([
    LogInterceptor(
      requestBody: true,
      responseBody: true,
    ),
    InterceptorsWrapper(
      onRequest: (RequestOptions options, handler) {

        final LocalStorage localStorage = Get.find();

        final accessToken = localStorage.getAccessToken() ?? '';
        // Do something before request is sent
        options.headers['Authorization'] = 'Bearer $accessToken';
        options.headers['Accept'] = 'application/json';
        return handler.next(options);
      }
    ),
  ]);

  Get.put(dio);
}