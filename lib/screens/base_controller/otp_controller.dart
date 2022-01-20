
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/screens/base_controller/individual_screen_controller.dart';
import 'package:forwa_app/widgets/firebase_otp_screen.dart';
import 'package:get/get.dart';

abstract class OtpController extends IndividualScreenController {

  Future verifyOtp({
    required String phone,
    required VoidCallback onSuccess,
    required String previousRoute,
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
            onSuccess: onSuccess,
            previousRoute: previousRoute,
          )
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

}