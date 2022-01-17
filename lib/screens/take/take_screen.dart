import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:forwa_app/widgets/app_container.dart';
import 'package:forwa_app/widgets/body_with_persistent_bottom.dart';
import 'package:forwa_app/widgets/rating.dart';
import 'package:get/get.dart';

import 'take_screen_controller.dart';

class TakeScreen extends GetView<TakeScreenController> {

  TakeScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  void _validate() {
    if (_formKey.currentState!.validate()) {
      controller.createOrder();
    }
  }

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
          title: const Text(
            'Soạn tin nhắn',
          ),
        ),
        body: Form(
          key: _formKey,
          child: BodyWithPersistentBottom(
            isKeyboard: isKeyboard,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppContainer(
                  padding: const EdgeInsets.only(
                      left: 12.0,
                      top: 24.0
                  ),
                  child: Text(
                    'Xin lưu ý:',
                    style: theme.textTheme.subtitle1?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.secondary
                    ),
                  )
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: const PolicySection()
                  ),
                ),
                const SellerInfoSection(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: Text(
                    'Soạn tin nhắn',
                    style: theme.textTheme.subtitle1?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  )
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 16.0,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 8.0
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextFormField(
                    controller: controller.messageController,
                    maxLines: 5,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Soạn lời nhắn cho $name',
                      hintStyle: theme.textTheme.bodyText1,
                    ),
                    cursorColor: Colors.black,
                    validator: ValidationBuilder(requiredMessage: 'Vui lòng nhập lời nhắn')
                        .minLength(10, 'Lời nhắn quá ngắn!')
                        .build(),
                  ),
                ),
              ],
            ),
            bottom: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0
              ),
              child: ElevatedButton(
                onPressed: _validate,
                child: const Text('Gửi'),
              )
            ),
          ),
        ),
      )
    );
  }
}

class PolicySection extends StatelessWidget {
  const PolicySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppContainer(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
          color: Colors.grey[200]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPolicyRow(
            '1. Phép lịch sự lúc nào cũng được ghi nhận.',
            context
          ),
          _buildPolicyRow(
            '2. Không nên tự ý ghé lấy đồ nếu chưa được xác nhận với người cho.',
            context
          ),
          _buildPolicyRow(
            '3. Nếu không được chọn thì cũng không nên buồn nhé.',
            context
          )
        ],
      ),
    );
  }

  Widget _buildPolicyRow(String text, context){
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(
          top: 8.0
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyText1?.copyWith(
                fontWeight: FontWeight.w600
              ),
              // overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class SellerInfoSection extends GetView<TakeScreenController> {
  const SellerInfoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sellerName = controller.sellerName;
    final List<String> words = sellerName.split(' ');
    final List<String> shortWords = words.length > 1 ? [words.first, words.last] : [words.first];

    return Container(
      // decoration: BoxDecoration(
      //     color: Colors.grey[200]
      // ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0
      ),
      child: ListTile(
        minVerticalPadding: 0.0,
        minLeadingWidth: 0.0,
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          radius: 24.0,
          backgroundColor: theme.colorScheme.secondary,
          child: Text(
            shortWords.map((e) => e[0]).join(),
            style: theme.textTheme.headline6!.copyWith(
              color: Colors.white,
            ),
          ),
        ),
        title: Text(
          sellerName,
          style: theme.textTheme.subtitle1,
          // overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          children: [
            Row(
              children: [
                const Rating(score: 3),
              ],
            ),
          ],
        ),
      ),
    );
  }
}