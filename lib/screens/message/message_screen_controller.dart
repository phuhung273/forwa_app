import 'package:forwa_app/screens/chat/chat_screen_controller.dart';
import 'package:get/get.dart';

class MessageScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MessageScreenController());
  }
}

class MessageScreenController extends GetxController {

  final ChatScreenController _chatScreenController = Get.find();

  final destinationID = Get.arguments as int;

  void leaveMessage(){
    _chatScreenController.leaveMessage(destinationID);
  }

  void readMessage(){
    _chatScreenController.readMessage(destinationID);
  }

}