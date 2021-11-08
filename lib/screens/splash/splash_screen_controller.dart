import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/repository/auth_repo.dart';
import 'package:forwa_app/di/firebase_messaging_service.dart';
import 'package:forwa_app/route/route.dart';
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
  void onReady() {
    super.onReady();
    Future.microtask(() => _loadData());
  }

  Future<Timer> _loadData() async {
    final token = await FirebaseMessaging.instance.getToken();

    if(token != null) {
      print('Firebase token: $token');
      _localStorage.saveFirebaseToken(token);
    }

    if(_isEnoughInfo()){
      final response = await _authRepo.handshake();

      if(response.isSuccess && response.data != null){
        _localStorage.saveAccessToken(response.data!.accessToken!);
      } else {
        _localStorage.removeCredentials();
      }
    }
    return Timer(const Duration(seconds: 1), _onDoneLoading);
  }

  Future _onDoneLoading() async {
    Get.offAndToNamed(ROUTE_MAIN);
  }

  bool _isEnoughInfo(){
    return _localStorage.getAccessToken() != null;
  }
}