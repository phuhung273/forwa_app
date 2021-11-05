import 'package:flutter/material.dart';
import 'package:forwa_app/widgets/app_container.dart';
import 'package:forwa_app/widgets/app_level_action_container.dart';
import 'package:forwa_app/widgets/body_with_persistent_bottom.dart';
import 'package:forwa_app/widgets/rating.dart';
import 'package:forwa_app/widgets/section_divider.dart';
import 'package:forwa_app/widgets/text_field_container.dart';
import 'package:get/get.dart';

import 'take_screen_controller.dart';

class TakeScreen extends GetView<TakeScreenController> {

  const TakeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    final theme = Theme.of(context);
    final name = controller.sellerName;
    final List<String> words = name.split(' ');
    final List<String> shortWords = words.length > 1 ? [words.first, words.last] : [words.first];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Item Name'),
        ),
        body: BodyWithPersistentBottom(
          isKeyboard: isKeyboard,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              Center(
                child: AppContainer(
                  child: Text(
                    'Xin lưu ý:',
                    style: theme.textTheme.headline4,
                  )
                ),
              ),
              AppContainer(
                child: Text(
                  '1. Phép lịch sự lúc nào cũng được ghi nhận.',
                  style: theme.textTheme.subtitle1,
                )
              ),
              AppContainer(
                child: Text(
                  '2. Không nên tự ý ghé lấy đồ nếu chưa được xác nhận với người cho.',
                  style: theme.textTheme.subtitle1,
                )
              ),
              AppContainer(
                child: Text(
                  '3. Nếu không được chọn thì cũng không nên buồn nhé.',
                  style: theme.textTheme.subtitle1,
                )
              ),
              const SectionDivider(),
              AppContainer(
                child: ListTile(
                  minVerticalPadding: 0.0,
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 24.0,
                    child: Text(
                      shortWords.map((e) => e[0]).join(),
                      style: theme.textTheme.headline5!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  title: Text(
                    name,
                    style: theme.textTheme.subtitle1,
                    // overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: const Rating(score: 3),
                ),
              ),
              Center(
                child: AppContainer(
                  child: Text(
                    'Soạn tin nhắn',
                    style: theme.textTheme.headline4,
                  )
                ),
              ),
              AppContainer(
                child: Center(
                  child: TextFieldContainer(
                    child: TextField(
                      controller: controller.messageController,
                      maxLines: 5,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Soạn lời nhắn cho $name'
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottom: AppLevelActionContainer(
            child: ElevatedButton(
              onPressed: controller.addToOrder,
              child: const Text('Gửi'),
            )
          ),
        ),
      )
    );
  }
}