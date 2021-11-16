
import 'dart:convert';
import 'dart:io';

import 'package:dash_chat/dash_chat.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/schema/chat/chat_socket_message.dart';
import 'package:forwa_app/screens/chat/chat_screen_controller.dart';
import 'package:forwa_app/widgets/transparent_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

import 'chat_screen_controller.dart';


class MessageScreen extends GetView<ChatScreenController> {

  MessageScreen({Key? key}) : super(key: key);

  final _destinationID = Get.arguments as int;

  final LocalStorage _localStorage = Get.find();

  final _picker = ImagePicker();

  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.users[_destinationID] != null
            ? controller.users[_destinationID]!.username
            : 'Message'
        )),
      ),
      body: Obx(
        (){
          final user = controller.users[_destinationID];
          if(user == null) return const SizedBox();
          final socketMessages = user.messages;
          if(socketMessages == null) return const SizedBox();

          final messages = socketMessages.map((e){
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
            messages: messages,
            user: ChatUser(
              name: _localStorage.getUsername(),
              uid: _localStorage.getUserID().toString(),
            ),
            inputDecoration: const InputDecoration.collapsed(hintText: "Add message here..."),
            messageTimeBuilder: _buildTime,
            dateBuilder: _buildDate,
            messageDecorationBuilder: _buildMessageDecoration,
            messageImageBuilder: _buildImage,
            inputTextStyle: const TextStyle(fontSize: 16.0),
            inputContainerStyle: BoxDecoration(
              border: Border.all(width: 0.0),
              color: Colors.white,
            ),
            trailing: <Widget>[
              IconButton(
                icon: const Icon(Icons.photo),
                onPressed: _onPickImage,
              ),
            ],
            onSend: (msg) => controller.sendStringMessage(msg, _destinationID),
          );
        },
      ),
    );
  }

  Future _onPickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if(image != null){
      final bytes = File(image.path).readAsBytesSync();
      final base64Image =  "data:image/png;base64,${base64Encode(bytes)}";
      controller.sendImageMessage(base64Image, _destinationID);
    }
  }

  Widget _buildTime(String time, [ChatMessage? message]) => const SizedBox();
  Widget _buildDate(String date) => Container();

  BoxDecoration _buildMessageDecoration(ChatMessage msg, bool? isUser){
    if(isUser == null) return const BoxDecoration();
    if(msg.image != null) return const BoxDecoration();

    return BoxDecoration(
      color: isUser
          ? secondaryColor
          : const Color.fromRGBO(225, 225, 225, 1)
    );
  }

  Widget _buildImage(String? image, [ChatMessage? message]){
    if(message == null) return const SizedBox();
    return ImageContainer(image: image);
  }
}

class ImageContainer extends StatelessWidget {
  final String? image;

  const ImageContainer({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final constraints = BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width);

    return FadeInImage.memoryNetwork(
      height: constraints.maxHeight * 0.3,
      width: constraints.maxWidth * 0.7,
      fit: BoxFit.contain,
      placeholder: kTransparentImage,
      image: image!,
    );
  }
}