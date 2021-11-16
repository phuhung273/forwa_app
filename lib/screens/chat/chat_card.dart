import 'package:forwa_app/constants.dart';
import 'package:forwa_app/schema/chat/chat.dart';
import 'package:flutter/material.dart';

class ChatCard extends StatefulWidget {
  const ChatCard({
    Key? key,
    required this.chat,
    required this.press,
  }) : super(key: key);

  final Chat chat;
  final VoidCallback press;

  @override
  _ChatCardState createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {

  late Chat _chat;

  @override
  void initState() {
    super.initState();
    _chat = widget.chat;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: widget.press,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: defaultSpacing, vertical: defaultSpacing * 0.75
        ),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  // backgroundImage: AssetImage(_chat.image),
                  child: Text(
                    _chat.name.split(' ').map((e) => e[0]).join(),
                    style: theme.textTheme.headline6!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
                if (_chat.isActive)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 16,
                      width: 16,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: 3
                        ),
                      ),
                    ),
                  )
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _chat.name,
                      style: theme.textTheme.subtitle1,
                    ),
                    const SizedBox(height: 4.0),
                    Opacity(
                      opacity: 0.64,
                      child: Text(
                        _chat.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Opacity(
            //   opacity: 0.64,
            //   child: Text(_chat.time),
            // ),
          ],
        ),
      ),
    );
  }
}
