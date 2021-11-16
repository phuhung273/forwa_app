import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/chat/chat.dart';
import 'package:forwa_app/schema/chat/chat_socket_message.dart';
import 'package:forwa_app/screens/chat/chat_screen_controller.dart';
import 'package:get/get.dart';

import 'chat_card.dart';

class ChatScreen extends StatelessWidget {

  final ChatScreenController _controller = Get.put(ChatScreenController());

  ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          title: const Text('Tin nhắn'),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: (){},
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: const Text(
                      'Tin nhắn gần đây',
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),
                ]
              ),
            ]
          ),
        ),
        _buildRecentMessages()
      ],
    );
  }

  Widget _buildRecentMessages() {
    return Obx(
          () => SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final userId = _controller.users.keys.elementAt(index);
          final chatSocketUser = _controller.users[userId];

          return ChatCard(
            key: UniqueKey(),
            chat: Chat(
              name: chatSocketUser!.username,
              isActive: chatSocketUser.connected == 1,
              image: '',
              time: '',
              lastMessage: _getLastMessage(chatSocketUser.messages),
            ),
            press: () => _goToMessageScreen(chatSocketUser.userID),
          );
        },
          childCount: _controller.users.length,
        ),
      ),
    );
  }

  String _getLastMessage(List<ChatSocketMessage>? messages){
    if(messages == null || messages.isEmpty){
      return '';
    }

    final message = messages.last;

    if(message.type == EnumToString.convertToString(MessageType.IMAGE)){
      return 'Image';
    } else if(message.type == EnumToString.convertToString(MessageType.LOCATION)){
      return 'Location';
    }
    return message.content;
  }

  void _goToMessageScreen(int id){
    Get.toNamed(ROUTE_MESSAGE, arguments: id);
  }
}