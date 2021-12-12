import 'package:flutter/material.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:get/get.dart';

import '../../constants.dart';

class PolicyUploadScreen extends StatefulWidget {
  final VoidCallback onAgree;

  const PolicyUploadScreen({
    Key? key,
    required this.onAgree,
  }) : super(key: key);

  @override
  State<PolicyUploadScreen> createState() => _PolicyUploadScreenState();
}

class _PolicyUploadScreenState extends State<PolicyUploadScreen> {

  final LocalStorage _localStorage = Get.find();

  bool agree = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('EULA'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
              children: [
                _buildPrimaryTitle('Thỏa thuận với người dùng cuối (EULA)'),
                const Divider(),

                _buildSecondaryTitle('1. Quy định bắt buộc khi đăng tải nội dung, hình ảnh'),
                _buildListItem(
                    'Nghiêm cấm nội dung, hình ảnh '
                        'chứa các yếu tố độc hại, bạo lực, thô tục, chính trị, tôn giáo '
                        'và các yếu tố không phù hợp khác.'
                ),
                _buildListItem(
                    'Mọi hành vi cố tình đăng nội dung sai quy định đều không được dung thứ.'
                ),
                _buildListItem(
                    'Forwa có toàn quyền ẩn đi bài đăng khi phát hiện nội dung không phù hợp.'
                ),
                const Divider(),

                _buildSecondaryTitle('2. Các hành vi sẽ được nhắc nhở'),
                _buildListItem('Không kinh doanh, mua bán ở mục cho nhận.'),
                _buildListItem(
                    'Tốt nhất, hãy chỉ cho đi những món không còn dùng tới, '
                        'hạn chế đăng những món đồ hư hỏng nặng.'
                ),
                Row(
                  children: [
                    Checkbox(
                      value: agree,
                      onChanged: (value) {
                        setState(() {
                          agree = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        'Đồng ý với các điều khoản nêu trên',
                        style: theme.textTheme.bodyText1,
                      ),
                    )
                  ],
                ),
                ElevatedButton(
                    onPressed: agree ? (){
                      _localStorage.saveAgreeUploadTerm('yes');
                      widget.onAgree();
                    } : null,
                    child: const Text('Xác nhận')
                )
              ]
          ),
        ),
      ),
    );
  }

  _buildPrimaryTitle(String text){
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.headline6,
          ),
        ),
      ],
    );
  }

  _buildSecondaryTitle(String text){
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.subtitle1,
          ),
        ),
      ],
    );
  }

  _buildListItem(String text){
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
            child: RichText(
              text: TextSpan(
                text: '• ',
                style: theme.textTheme.headline6,
                children: [
                  TextSpan(
                      text: text,
                      style: theme.textTheme.bodyText1
                  ),
                ],
              ),
            )
        ),
      ],
    );
  }
}