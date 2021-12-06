
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/repository/auth_repo.dart';
import 'package:forwa_app/helpers/email_helper.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/api_response.dart';
import 'package:forwa_app/schema/auth/facebook_user.dart';
import 'package:forwa_app/schema/auth/firebase_token.dart';
import 'package:forwa_app/schema/auth/email_login_request.dart';
import 'package:forwa_app/schema/auth/login_response.dart';
import 'package:forwa_app/schema/auth/phone_login_request.dart';
import 'package:forwa_app/schema/auth/social_email_login_request.dart';
import 'package:forwa_app/screens/base_controller/base_controller.dart';
import 'package:forwa_app/screens/main/main_screen_controller.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart' as the_apple_sign_in;

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
    final method = usernameController.text;
    if(isValidEmail(method)){
      await emailLogin();
    } else {
      await phoneLogin();
    }
  }

  Future emailLogin() async {
    showLoadingDialog();

    final username = usernameController.text;
    final pwd = passwordController.text;

    final firebaseToken = await _prepareFirebaseToken();
    if(firebaseToken == null){
      hideDialog();
      return;
    }

    final request = EmailLoginRequest(
      email: username,
      password: pwd,
      firebaseToken: firebaseToken.value,
      device: firebaseToken.deviceName,
    );
    final response = await _authRepo.emailLogin(request);

    hideDialog();
    _processLoginResponse(response, username);

  }

  Future phoneLogin() async {
    showLoadingDialog();

    final username = usernameController.text;
    final pwd = passwordController.text;

    final firebaseToken = await _prepareFirebaseToken();
    if(firebaseToken == null){
      hideDialog();
      return;
    }

    final request = PhoneLoginRequest(
      phone: username,
      password: pwd,
      firebaseToken: firebaseToken.value,
      device: firebaseToken.deviceName,
    );
    final response = await _authRepo.phoneLogin(request);

    hideDialog();
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
      _socialEmailLogin(username, email, avatar);

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
      // final AccessToken accessToken = response.accessToken!;
      final data = await FacebookAuth.i.getUserData();

      String? username;
      String? email;
      String? avatar;
      try{
        final facebookAccount = FacebookUser.fromJson(data);
        username = facebookAccount.name;
        email = facebookAccount.email;
        avatar = facebookAccount.picture?.data.url;
      } catch(e) {
        username = data['name'];
        email = data['email'];
        avatar = data['picture']['data']['url'];
      }

      if(username == null){
        result.value = 'Đăng nhập Facebook thất bại';
        return;
      }
      if(email == null){
        result.value = 'Tài khoản Facebook thiếu email';
        return;
      }

      _socialEmailLogin(username, email, avatar);
    } else {
      print(response.status);
      print(response.message);
    }

  }

  Future appleLogin() async {
    // // To prevent replay attacks with the credential returned from Apple, we
    // // include a nonce in the credential request. When signing in with
    // // Firebase, the nonce in the id token returned by Apple, is expected to
    // // match the sha256 hash of `rawNonce`.
    // final rawNonce = generateNonce();
    // final nonce = sha256ofString(rawNonce);

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
        clientId:APPLE_SERVICE_IDENTIFIER,
        redirectUri:Uri.parse(APPLE_LOGIN_REDIRECT_URI),
      ),
      // nonce: nonce,
    );

    print(credential);

    // final AuthorizationResult result = await TheAppleSignIn.performRequests([
    //   const AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    // ]);
    //
    // switch (result.status) {
    //   case the_apple_sign_in.AuthorizationStatus.authorized:
    //
    //     print('Name: ${result.credential?.fullName?.familyName} ${result.credential?.fullName?.givenName}');
    //     print('Email: ${result.credential?.email}');
    //     print('Apple user id: ${result.credential?.user}');
    //     break;
    //
    //   case the_apple_sign_in.AuthorizationStatus.error:
    //     print('Sign in failed');
    //     break;
    //
    //   case the_apple_sign_in.AuthorizationStatus.cancelled:
    //     print('User cancelled');
    //     break;
    // }


    // This is the endpoint that will convert an authorization code obtained
    // via Sign in with Apple into a session in your system
    final signInWithAppleEndpoint = Uri(
      scheme: 'https',
      host: APPLE_LOGIN_HOST,
      path: APPLE_LOGIN_ENDPOINT,
      queryParameters: <String, String>{
        'code': credential.authorizationCode,
        if (credential.givenName != null)
          'firstName': credential.givenName!,
        if (credential.familyName != null)
          'lastName': credential.familyName!,
        'useBundleId': Platform.isIOS || Platform.isMacOS
            ? 'true'
            : 'false',
        if (credential.state != null) 'state': credential.state!,
      },
    );

    final session = await http.Client().post(
      signInWithAppleEndpoint,
    );

    // If we got this far, a session based on the Apple ID credential has been created in your system,
    // and you can now set this as the app's session
    // ignore: avoid_print
    print(session);
  }

  Future _socialEmailLogin(String username, String email, String? avatar) async {
    showLoadingDialog();

    final firebaseToken = await _prepareFirebaseToken();
    if(firebaseToken == null){
      hideDialog();
      return;
    }

    final request = SocialEmailLoginRequest(
      email: email,
      name: username,
      firebaseToken: firebaseToken.value,
      device: firebaseToken.deviceName,
    );

    final response = await _authRepo.socialEmailLogin(request);

    hideDialog();

    _processLoginResponse(response, email, avatar: avatar);
  }

  void _processLoginResponse(
      ApiResponse<LoginResponse> response,
      String emailOrPhone,
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
      _localStorage.saveUserID(data.userId);
      _localStorage.saveUsername(emailOrPhone);
      // _localStorage.savePwd(pwd);
      _localStorage.saveCustomerName(data.username);
      _mainController.refreshCredential();
      Get.offAndToNamed(ROUTE_MAIN);
    }
  }

  Future<FirebaseToken?> _prepareFirebaseToken() async{
    final firebaseTokenValue = await FirebaseMessaging.instance.getToken();
    final deviceName = _localStorage.getDeviceName();

    if(firebaseTokenValue == null || deviceName == null){
      return null;
    }

    return FirebaseToken(value: firebaseTokenValue, deviceName: deviceName);
  }
}

// /// Generates a cryptographically secure random nonce, to be included in a
// /// credential request.
// String generateNonce([int length = 32]) {
//   const charset =
//       '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
//   final random = Random.secure();
//   return List.generate(length, (_) => charset[random.nextInt(charset.length)])
//       .join();
// }
//
// /// Returns the sha256 hash of [input] in hex notation.
// String sha256ofString(String input) {
//   final bytes = utf8.encode(input);
//   final digest = sha256.convert(bytes);
//   return digest.toString();
// }