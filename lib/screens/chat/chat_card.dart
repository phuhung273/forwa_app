import 'package:forwa_app/constants.dart';
import 'package:forwa_app/schema/chat/chat.dart';
import 'package:flutter/material.dart';

class ChatCard extends StatefulWidget {

  final Chat chat;
  final VoidCallback press;

  const ChatCard({
    Key? key,
    required this.chat,
    required this.press,
  }) : super(key: key);

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
    final words = _chat.name.split(' ');
    final shortWords = words.length > 1 ? [words.first, words.last] : [words.first];

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
                    shortWords.map((e) => e[0]).join(),
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
                child: Opacity(
                  opacity: _chat.isHighlight ? 1.0 : 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _chat.name,
                        style: theme.textTheme.subtitle1?.copyWith(
                          fontWeight: _chat.isHighlight ? FontWeight.w700 : null
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        _chat.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyText1?.copyWith(
                            fontWeight: _chat.isHighlight ? FontWeight.w700 : null
                        ),
                      ),
                    ],
                  ),
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
