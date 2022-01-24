import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/chat/chat.dart';
import 'package:forwa_app/schema/chat/chat_socket_message.dart';
import 'package:forwa_app/screens/base_controller/chat_controller.dart';
import 'package:forwa_app/screens/chat/chat_screen_controller.dart';
import 'package:forwa_app/screens/main/main_screen.dart';
import 'package:forwa_app/screens/main/main_screen_controller.dart';
import 'package:forwa_app/screens/message/message_screen_controller.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'chat_card.dart';

class ChatScreen extends StatefulWidget {

  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  final ChatScreenController _controller = Get.put(ChatScreenController());

  final ChatController _chatController = Get.find();

  final MainScreenController _mainController = Get.find();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        _mainController.changeTab(HOME_SCREEN_INDEX);
        return false;
      },
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: const Text('Tin nhắn'),
            leading: Container(
              margin: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.menu,
                  color: theme.colorScheme.secondary,
                ),
                iconSize: 20.0,
                onPressed: () => _mainController.openDrawer(),
              ),
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
      ),
    );
  }

  Widget _buildRecentMessages() {
    final theme = Theme.of(Get.context!);


    return Obx(
      () {
        if(_controller.roomMap.isEmpty){
          return const SliverFillRemaining(child: SizedBox());
        }

        return SliverFillRemaining(
          child: RefreshIndicator(
            onRefresh: _controller.main,
            color: theme.colorScheme.secondary,
            child: ScrollablePositionedList.builder(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              itemCount: _controller.roomMap.length,
              itemPositionsListener: _controller.itemPositionsListener,
              itemBuilder: (context, index) {
                final roomId = _controller.roomMap.keys.elementAt(index);
                final room = _controller.roomMap[roomId]!;

                return ChatCard(
                  key: UniqueKey(),
                  chat: Chat(
                    name: room.name ?? '',
                    isActive: room.connected == 1,
                    image: '',
                    time: '',
                    lastMessage: _getLastMessage(room.messages),
                    isHighlight: room.hasUnreadMessages
                  ),
                  press: () => _goToMessageScreen(room.id),
                );
              }
            ),
          ),
        );
      },
    );
  }

  String _getLastMessage(List<ChatSocketMessage> messages){
    if(messages.isEmpty){
      return '';
    }

    final message = messages.first;

    if(message.type == EnumToString.convertToString(MessageType.IMAGE)){
      return 'Image';
    } else if(message.type == EnumToString.convertToString(MessageType.LOCATION)){
      return 'Location';
    }
    return message.content;
  }

  void _goToMessageScreen(String id){
    MessageScreenController.openScreenOnChatScreen(id);
    _chatController.readMessage(id);
  }
}