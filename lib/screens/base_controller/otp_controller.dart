import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:forwa_app/screens/base_controller/base_controller.dart';
import 'package:forwa_app/widgets/firebase_otp.dart';
import 'package:get/get.dart';

class OtpController extends BaseController {

  Future showOtpDialog({
    required String phone,
    required VoidCallback onSuccess,
    required VoidCallback onError,
  }) async {
    final auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (credential){ },
      verificationFailed: (e) { },
      codeSent: (verificationId, int? resendToken) async {
        final smsCode = await Get.generalDialog<String>(
          pageBuilder: (context, animation, secondaryAnimation) => FirebaseOtpScreen(
            phoneNumber: phone
          )
        );

        if(smsCode == null){
          print('error');
          return;
        }

        final credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);

        try{
          await auth.signInWithCredential(credential);
          onSuccess();
        }catch (e){
          print(e.toString());
          onError();
        }
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );

  }

}