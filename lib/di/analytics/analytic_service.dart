import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:forwa_app/di/analytics/analytic_param.dart';
import 'package:forwa_app/di/firebase_messaging_service.dart';
import 'package:forwa_app/schema/app_notification/app_notification.dart';
import 'package:forwa_app/screens/product/product_screen_controller.dart';
import 'package:forwa_app/screens/register/register_screen_controller.dart';

class AnalyticService {

  final analytics = FirebaseAnalytics.instance;

  Future logClickProcessingNotification(int orderId, int productId) {
    return analytics.logEvent(
      name: EVENT_NOTIFICATION_CLICK,
      parameters: {
        'type': APP_NOTIFICATION_TYPE_PROCESSING,
        'order_id': orderId,
        'product_id': productId,
      }
    );
  }

  Future logClickSelectedNotification(int orderId, int productId) {
    return analytics.logEvent(
        name: EVENT_NOTIFICATION_CLICK,
        parameters: {
          'type': APP_NOTIFICATION_TYPE_SELECTED,
          'order_id': orderId,
          'product_id': productId,
        }
    );
  }

  Future logClickUploadNotification(int productId) {
    return analytics.logEvent(
        name: EVENT_NOTIFICATION_CLICK,
        parameters: {
          'type': APP_NOTIFICATION_TYPE_UPLOAD,
          'product_id': productId,
        }
    );
  }

  Future logClickChatNotification(String roomId) {
    return analytics.logEvent(
        name: EVENT_NOTIFICATION_CLICK,
        parameters: {
          'type': NOTIFICATION_TYPE_CHAT,
          'room_id': roomId,
        }
    );
  }

  Future logShareByCopyToClipboard(String id) {
    return analytics.logShare(
      contentType: EnumToString.convertToString(ShareContentType.link),
      itemId: id,
      method: EnumToString.convertToString(ShareMethod.copyToClipboard),
    );
  }

  Future logAppOpen() {
    return analytics.logAppOpen();
  }

  Future logTutorialBegin(){
    return analytics.logTutorialBegin();
  }

  Future logTutorialComplete(){
    return analytics.logTutorialComplete();
  }

  Future logSignUpByPhone(){
    return analytics.logSignUp(signUpMethod: EnumToString.convertToString(RegisterMethod.phone));
  }

  Future logSignUpByEmail(){
    return analytics.logSignUp(signUpMethod: EnumToString.convertToString(RegisterMethod.email));
  }

  Future setCurrentScreen(String screenName){
    return analytics.setCurrentScreen(screenName: screenName);
  }

  Future setUserId(int id){
    return analytics.setUserId(id: id.toString());
  }
}