
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/screens/base_controller/base_controller.dart';
import 'package:forwa_app/widgets/firebase_otp_screen.dart';
import 'package:get/get.dart';

class OtpController extends BaseController {

  Future verifyOtp({
    required String phone,
    required VoidCallback onSuccess,
  }) {
    return FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        Get.generalDialog(
          pageBuilder: (context, animation, secondaryAnimation) => FirebaseOtpScreen(
            phoneNumber: phone,
            verificationId: verificationId,
            onSuccess: onSuccess
          )
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

}