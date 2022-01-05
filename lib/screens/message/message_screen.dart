
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
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'message_screen_controller.dart';
import '../chat/chat_screen_controller.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> with WidgetsBindingObserver {

  final MessageScreenController _controller = Get.find();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if(state == AppLifecycleState.paused){
      // print('Im dead');
      _controller.leaveMessage();
    }

    final lastState = WidgetsBinding.instance?.lifecycleState;
    if(lastState == AppLifecycleState.resumed){
      // print('Im alive');
      _controller.readMessage();
    }
  }


  @override
  Widget build(BuildContext context) {
    return MessageView();
  }
}


class MessageView extends GetView<MessageScreenController> {

  MessageView({Key? key}) : super(key: key);


  final LocalStorage _localStorage = Get.find();

  final ChatScreenController _chatScreenController = Get.find();

  final _picker = ImagePicker();

  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        controller.leaveMessage();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Obx(() => Text(_chatScreenController.users[controller.destinationID] != null
              ? _chatScreenController.users[controller.destinationID]!.username
              : 'Tin nhắn'
          )),
        ),
        body: Obx(
          (){
            final user = _chatScreenController.users[controller.destinationID];
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
                name: _localStorage.getCustomerName(),
                uid: _localStorage.getUserID().toString(),
              ),
              inputDecoration: const InputDecoration.collapsed(hintText: 'Nhập tin nhắn...'),
              messageTimeBuilder: _buildTime,
              dateBuilder: _buildDate,
              messageDecorationBuilder: _buildMessageDecoration,
              messageImageBuilder: _buildImage,
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
              onSend: (msg) => _chatScreenController.sendStringMessage(msg, controller.destinationID),
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
      _chatScreenController.sendImageMessage(base64Image, controller.destinationID);
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