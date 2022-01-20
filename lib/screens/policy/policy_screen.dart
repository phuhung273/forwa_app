import 'package:flutter/material.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/di/analytics/analytic_service.dart';
import 'package:forwa_app/route/route.dart';
import 'package:get/get.dart';

class PolicyScreen extends StatefulWidget {
  final VoidCallback onAgree;
  const PolicyScreen({
    Key? key,
    required this.onAgree,
  }) : super(key: key);

  @override
  State<PolicyScreen> createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {

  final LocalStorage _localStorage = Get.find();
  final AnalyticService _analyticService = Get.find();

  bool agree = false;


  @override
  void initState() {
    super.initState();

    _analyticService.setCurrentScreen(ROUTE_POLICY);
  }

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

              _buildPrimaryTitle('Nội dung, hình ảnh trên Forwa'),
              _buildListItem(
                  'Nội dung, hình ảnh được đăng trên Forwa sẽ luôn được kiểm duyệt để không '
                  'chứa các yếu tố độc hại, bạo lực, thô tục, chính trị, tôn giáo '
                  'và các yếu tố không phù hợp khác.'
              ),
              _buildListItem(
                  'Nếu phát hiện thấy các nội dung độc hại, bạn có thể báo cáo bài đăng. '
                      'Đội ngũ kiểm duyệt sẽ giải quyết trong vòng 24h sau khi nhận được báo cáo.'
              ),
              _buildListItem(
                  'Bạn cũng có thể ẩn đi những bài đăng khác (không chứa yếu tố độc hại) '
                      'nhưng không phù hợp theo ý kiến cá nhân trên nền tảng Forwa.'
              ),
              const Divider(),

              _buildPrimaryTitle('Điều khoản khi tham gia mục cho nhận'),
              _buildListItem('Forwa là nơi mà bạn có thể cho và nhận những món đồ miễn phí'),
              _buildListItem('Không kinh doanh, mua bán ở mục cho nhận.'),
              const Divider(),

              _buildSecondaryTitle('Về phía người cho'),
              _buildListItem(
                  'Tốt nhất, hãy chỉ cho đi những món không còn dùng tới, '
                      'hạn chế đăng những món đồ hư hỏng nặng.'
              ),
              _buildListItem(
                  'Nội dung, hình ảnh đăng lên không được có yếu tố độc hại bạo lực, thô tục, chính trị, tôn giáo '
                      'và các yếu tố không phù hợp khác.'
              ),
              _buildListItem(
                  'Forwa có toàn quyền ẩn đi bài đăng khi phát hiện nội dung không phù hợp.'
              ),
              const Divider(),

              _buildSecondaryTitle('Về phía người nhận'),
              _buildListItem(
                  'Forwa không chịu trách nhiệm về chất lượng đồ dùng ở mục cho nhận.'
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
                  _localStorage.saveAgreeTerm('yes');
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