import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/repository/auth_repo.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/api_response.dart';
import 'package:forwa_app/schema/auth/facebook_user.dart';
import 'package:forwa_app/schema/auth/login_request.dart';
import 'package:forwa_app/schema/auth/login_response.dart';
import 'package:forwa_app/schema/auth/social_login_request.dart';
import 'package:forwa_app/schema/customer/customer.dart';
import 'package:forwa_app/screens/base_controller.dart';
import 'package:forwa_app/screens/main/main_screen_controller.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';

class LoginScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginScreenController());
  }
}

class LoginScreenController extends BaseController {

  final AuthRepo _authRepo = Get.find();
  final MainScreenController _mainController = Get.find();

  final LocalStorage _localStorage = Get.find();

  final GoogleSignIn _googleSignIn = Get.find();
  final uuid = const Uuid();

  var result = ''.obs;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future login() async {

    showLoadingDialog();

    final username = usernameController.text;
    final pwd = passwordController.text;
    final request = LoginRequest(username: username, password: pwd);
    final response = await _authRepo.login(request);

    hideDialog();

    // if(!response.isSuccess){
    //   result.value = response.message!;
    // } else {
    //   final data = response.data;
    //   _localStorage.saveAccessToken(data!.accessToken);
    //   _localStorage.saveUsername(username);
    //   _localStorage.saveUserID(data.customer.id!);
    //   // _localStorage.savePwd(pwd);
    //   _localStorage.saveStoreId(data.customer.storeId!);
    //   _localStorage.saveWebsiteId(data.customer.websiteId!);
    //   Get.offAndToNamed(ROUTE_MAIN);
    // }

    _processLoginResponse(response, username);

  }

  Future googleLogin() async {
    try {
      _googleSignIn.disconnect();
      final googleAccount = await _googleSignIn.signIn();
      if(googleAccount == null){
        result.value = 'Đăng nhập Google thất bại';
        return;
      }
      final username = googleAccount.displayName ?? 'Guest';
      final email = googleAccount.email;
      final avatar = googleAccount.photoUrl;
      _socialLogin(username, email, avatar);

    } catch (error) {
      print(error);
    }
  }

  Future facebookLogin() async {
    await FacebookAuth.i.logOut();
    final response = await FacebookAuth.i.login(); // by default we request the email and the public profile
    // or FacebookAuth.i.login()
    if (response.status == LoginStatus.success) {
      // you are logged
      final AccessToken accessToken = response.accessToken!;
      final data = await FacebookAuth.i.getUserData();
      final facebookAccount = FacebookUser.fromJson(data);
      final username = facebookAccount.name;
      final email = facebookAccount.email;
      final avatar = facebookAccount.picture?.data.url;

      if(username == null){
        result.value = 'Đăng nhập Facebook thất bại';
        return;
      }
      if(email == null){
        result.value = 'Tài khoản Facebook thiếu email';
        return;
      }

      _socialLogin(username, email, avatar);
    } else {
      print(response.status);
      print(response.message);
    }

  }

  Future _socialLogin(String username, String email, String? avatar) async {
    showLoadingDialog();

    final words = username.split(' ');

    final request = SocialLoginRequest(
      customer: Customer(
        firstName: words.first,
        lastName: words.length > 1 ? words.last : words.first,
        email: email,
      ),
    );

    final response = await _authRepo.socialLogin(request);

    hideDialog();

    _processLoginResponse(response, email, avatar: avatar);
  }

  void _processLoginResponse(
      ApiResponse<LoginResponse> response,
      String email,
      {
        String? avatar
      }
  ) {
    if(!response.isSuccess){
      result.value = response.message!;
    } else {
      final data = response.data;

      if(avatar != null) _localStorage.saveAvatarUrl(avatar);

      _localStorage.saveAccessToken(data!.accessToken);
      _localStorage.saveUserID(data.customer.id!);
      _localStorage.saveUsername(email);
      // _localStorage.savePwd(pwd);
      _localStorage.saveStoreCode(data.storeCode);
      _localStorage.saveStoreWebsiteId(data.storeWebsiteId);
      _localStorage.saveCustomerName('${data.customer.firstName} ${data.customer.lastName}');
      _mainController.refreshCredential();
      Get.offAndToNamed(ROUTE_MAIN);
    }
  }
}