
import 'package:forwa_app/screens/base_controller/base_controller.dart';
import 'package:forwa_app/widgets/firebase_otp_screen.dart';
import 'package:get/get.dart';

class OtpController extends BaseController {

  Future<bool?> showOtpDialog({
    required String phone,
    required String sessionInfo,
  }) {
    return Get.generalDialog<bool?>(
      pageBuilder: (context, animation, secondaryAnimation) => FirebaseOtpScreen(
        phoneNumber: phone,
        sessionInfo: sessionInfo,
      )
    );
  }

}