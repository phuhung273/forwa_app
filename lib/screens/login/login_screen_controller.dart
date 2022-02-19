
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/repository/auth_repo.dart';
import 'package:forwa_app/di/analytics/analytic_service.dart';
import 'package:forwa_app/helpers/email_helper.dart';
import 'package:forwa_app/schema/api_response.dart';
import 'package:forwa_app/schema/auth/apple_login_request.dart';
import 'package:forwa_app/schema/auth/facebook_login_request.dart';
import 'package:forwa_app/schema/auth/facebook_user.dart';
import 'package:forwa_app/schema/auth/firebase_token.dart';
import 'package:forwa_app/schema/auth/email_login_request.dart';
import 'package:forwa_app/schema/auth/login_response.dart';
import 'package:forwa_app/schema/auth/phone_login_request.dart';
import 'package:forwa_app/schema/auth/social_email_login_request.dart';
import 'package:forwa_app/screens/base_controller/navigation_controller.dart';
import 'package:forwa_app/screens/base_controller/base_controller.dart';
import 'package:forwa_app/screens/base_controller/chat_controller.dart';
import 'package:forwa_app/screens/main/main_screen_controller.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginScreenController());
  }
}

class LoginScreenController extends BaseController {

  final AuthRepo _authRepo = Get.find();

  final MainScreenController _mainController = Get.find();

  final ChatController _chatController = Get.find();

  final LocalStorage _localStorage = Get.find();

  final NavigationController _navigationController = Get.find();

  final GoogleSignIn _googleSignIn = Get.find();
  final AnalyticService _analyticService = Get.find();

  var result = ''.obs;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future login() async {
    final method = usernameController.text;
    if(isValidEmail(method)){
      await emailLogin();
    } else {
      await phoneLogin();
    }
  }

  Future emailLogin() async {
    showLoadingDialog();

    final email = usernameController.text;
    final pwd = passwordController.text;

    final firebaseToken = _prepareFirebaseToken();

    final request = EmailLoginRequest(
      email: email,
      password: pwd,
      firebaseToken: firebaseToken.value,
      device: firebaseToken.deviceName,
    );
    final response = await _authRepo.emailLogin(request);

    hideDialog();
    _processLoginResponse(response);

  }

  Future phoneLogin() async {
    showLoadingDialog();

    final phone = usernameController.text;
    final pwd = passwordController.text;

    final firebaseToken = _prepareFirebaseToken();

    final request = PhoneLoginRequest(
      phone: phone,
      password: pwd,
      firebaseToken: firebaseToken.value,
      device: firebaseToken.deviceName,
    );
    final response = await _authRepo.phoneLogin(request);

    hideDialog();
    _processLoginResponse(response);

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
      _socialEmailLogin(username, email, avatar);

    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future facebookLogin() async {
    await FacebookAuth.i.logOut();
    final response = await FacebookAuth.i.login(); // by default we request the email and the public profile
    // or FacebookAuth.i.login()
    if (response.status == LoginStatus.success) {
      // you are logged
      // final AccessToken accessToken = response.accessToken!;
      final data = await FacebookAuth.i.getUserData();

      String? username;
      String? email;
      String? avatar;
      String? facebookId;
      try{
        final facebookAccount = FacebookUser.fromJson(data);
        username = facebookAccount.name;
        email = facebookAccount.email;
        avatar = facebookAccount.picture?.data.url;
        facebookId = facebookAccount.id!;
      } catch(e) {
        username = data['name'];
        email = data['email'];
        avatar = data['picture']['data']['url'];
      }

      if(username == null){
        result.value = 'Đăng nhập Facebook thất bại';
        return;
      }

      if(email != null){
        _socialEmailLogin(username, email, avatar);
      } else {
        _facebookLoginWithoutEmail(username, facebookId!, avatar);
      }


    } else {
      debugPrint(response.status.toString());
      debugPrint(response.message);
    }
  }

  Future _facebookLoginWithoutEmail(String username, String facebookId, String? avatar) async {
    showLoadingDialog();

    final firebaseToken = _prepareFirebaseToken();

    final request = FacebookLoginRequest(
      facebookId: facebookId,
      name: username,
      firebaseToken: firebaseToken.value,
      device: firebaseToken.deviceName,
      avatar: avatar,
    );

    final response = await _authRepo.facebookLogin(request);

    hideDialog();

    _processLoginResponse(response, avatar: avatar);
  }

  Future appleLogin() async {

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    showLoadingDialog();

    final firebaseToken = _prepareFirebaseToken();

    final name = credential.familyName != null
                  ? '${credential.familyName} ${credential.givenName}'
                  : null;

    final request = AppleLoginRequest(
      appleId: credential.userIdentifier!,
      email: credential.email,
      name: name,
      firebaseToken: firebaseToken.value,
      device: firebaseToken.deviceName,
    );

    final response = await _authRepo.appleLogin(request);

    hideDialog();

    _processLoginResponse(response);
  }

  Future _socialEmailLogin(String username, String email, String? avatar) async {
    showLoadingDialog();

    final firebaseToken = _prepareFirebaseToken();

    final request = SocialEmailLoginRequest(
      email: email,
      name: username,
      firebaseToken: firebaseToken.value,
      device: firebaseToken.deviceName,
      avatar: avatar,
    );

    final response = await _authRepo.socialEmailLogin(request);

    hideDialog();

    _processLoginResponse(response, avatar: avatar);
  }

  void _processLoginResponse(
      ApiResponse<LoginResponse> response,
      {
        String? avatar
      }
  ) {
    if(!response.isSuccess){
      final message = errorCodeMap[response.statusCode] ?? 'Lỗi không xác định';
      result.value = message;
      showErrorDialog(message: message);
      return;
    }

    final data = response.data;

    if(avatar != null) _localStorage.saveAvatarUrl(avatar);

    _localStorage.saveAccessToken(data!.accessToken);
    _localStorage.saveUserID(data.userId);
    _localStorage.saveCustomerName(data.username);
    _mainController.refreshCredential();

    _analyticService.setUserId(data.userId);
    _chatController.init();
    _chatController.fetchUnread();
    _navigationController.reset();
    Get.back();
  }

  FirebaseToken _prepareFirebaseToken(){
    final firebaseTokenValue = _localStorage.getFirebaseToken()!;
    final deviceName = _localStorage.getDeviceName()!;

    return FirebaseToken(value: firebaseTokenValue, deviceName: deviceName);
  }

  @override
  void onClose(){
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}