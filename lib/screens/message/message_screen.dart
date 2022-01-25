
import 'dart:convert';
import 'dart:io';

import 'package:dash_chat/dash_chat.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/chat/chat_socket_message.dart';
import 'package:forwa_app/widgets/hero_widget.dart';
import 'package:forwa_app/widgets/transparent_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'message_screen_controller.dart';

class MessageScreen extends GetView<MessageScreenController> {

  MessageScreen({Key? key}) : super(key: key);


  final LocalStorage _localStorage = Get.find();

  final _picker = ImagePicker();

  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        controller.leaveMessage();

        if(controller.isNotificationStartFromTerminated){
          Get.offAndToNamed(ROUTE_MAIN);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Obx(() => Text(controller.roomName.value)),
          leading: controller.isNotificationStartFromTerminated
            ? IconButton(
              icon: const Icon(
                Icons.arrow_back,
              ),
              iconSize: 20.0,
              onPressed: () => Get.offAndToNamed(ROUTE_MAIN),
            )
            : null,
        ),
        body: Obx(
          () {
            final messages = controller.messages.map((e){
              final message = ChatMessage(
                  id: e.id,
                  text: e.content,
                  user: ChatUser(
                    uid: e.from.toString(),
                  )
              );

              if(e.type == EnumToString.convertToString(MessageType.IMAGE)){
                message.image = '$CHAT_PUBLIC_URL/${message.text}';
                message.text = '';
              } else if(e.type == EnumToString.convertToString(MessageType.LOCATION)){
                message.image = '';
              }

              return message;
            }).toList();

            return DashChat(
              key: _chatViewKey,
              inverted: true,
              messages: messages,
              onLoadEarlier: controller.lazyLoad,
              user: ChatUser(
                name: _localStorage.getCustomerName(),
                uid: _localStorage.getUserID().toString(),
              ),
              inputDecoration: const InputDecoration.collapsed(hintText: 'Nhập tin nhắn...'),
              messageTimeBuilder: _buildTime,
              dateBuilder: _buildDate,
              messageDecorationBuilder: _buildMessageDecoration,
              messageImageBuilder: _buildImage,
              messagePadding: const EdgeInsets.all(16.0),
              scrollToBottomStyle: ScrollToBottomStyle(
                textColor: theme.colorScheme.secondary
              ),
              inputTextStyle: const TextStyle(fontSize: 16.0),
              inputContainerStyle: BoxDecoration(
                border: Border.all(width: 0.0),
                color: Colors.white,
              ),
              inputCursorColor: Colors.black,
              trailing: <Widget>[
                IconButton(
                  icon: const Icon(Icons.photo),
                  onPressed: _onPickImage,
                ),
              ],
              onSend: controller.sendStringMessage,
            );
          },
        ),
      ),
    );
  }

  Future _onPickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if(image != null){
      final bytes = File(image.path).readAsBytesSync();
      final base64Image =  'data:image/png;base64,${base64Encode(bytes)}';
      controller.sendImageMessage(base64Image);
    }
  }

  Widget _buildTime(String time, [ChatMessage? message]) => const SizedBox();
  Widget _buildDate(String date) => Container();

  BoxDecoration _buildMessageDecoration(ChatMessage msg, bool? isUser){
    final borderRadius = BorderRadius.circular(12.0);

    if(isUser == null) return BoxDecoration(borderRadius: borderRadius);
    if(msg.image != null) return BoxDecoration(borderRadius: borderRadius);

    return BoxDecoration(
      color: isUser
          ? secondaryColor
          : const Color.fromRGBO(225, 225, 225, 1),
      borderRadius: borderRadius
    );
  }

  Widget _buildImage(String? image, [ChatMessage? message]){
    if(message == null) return const SizedBox();

    return ImageMessageContainer(
      image: image,
      messageId: message.id!,
    );
  }
}

class ImageMessageContainer extends StatelessWidget {
  final String? image;
  final String messageId;

  const ImageMessageContainer({
    Key? key,
    required this.image,
    required this.messageId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final constraints = BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width);

    return HeroWidget(
      tag: messageId,
      onTap: _zoomImage,
      child: FadeInImage.memoryNetwork(
        height: constraints.maxHeight * 0.3,
        width: constraints.maxWidth * 0.7,
        fit: BoxFit.contain,
        placeholder: kTransparentImage,
        image: image!,
      ),
    );
  }

  void _zoomImage() {
    Navigator.of(Get.context!).push(MaterialPageRoute<void>(
      builder: (BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        body: Hero(
          tag: messageId,
          child: FadeInImage.memoryNetwork(
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            placeholder: kTransparentImage,
            image: image!,
          ),
        ),
      ),
    ));
  }
}