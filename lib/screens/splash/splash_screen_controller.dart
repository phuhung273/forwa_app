import 'dart:async';

import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/remote/auth_service.dart';
import 'package:forwa_app/datasource/repository/auth_repo.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/auth/login_request.dart';
import 'package:get/get.dart';

class SplashScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashScreenController());
  }
}

class SplashScreenController extends GetxController {

  final AuthRepo _authRepo = Get.find();

  final LocalStorage _localStorage = Get.find();

  @override
  void onInit() {
    super.onInit();

    Future.microtask(() => _loadData());
  }

  Future<Timer> _loadData() async {
    return Timer(const Duration(seconds: 1), _onDoneLoading);
  }

  Future _onDoneLoading() async {
    if(_isEnoughInfo()){
        final response = await _authRepo.handshake();

        if(response.isSuccess && response.data != null){
          _localStorage.saveAccessToken(response.data!.accessToken!);
        } else {
          _localStorage.removeCredentials();
        }
    }
    Get.offAndToNamed(ROUTE_MAIN);
  }

  bool _isEnoughInfo(){
    return _localStorage.getAccessToken() != null;
  }
}