import 'package:flutter/material.dart';
import 'package:forwa_app/di/analytics/analytic_service.dart';
import 'package:forwa_app/route/route.dart';
import 'package:get/get.dart';

import '../../constants.dart';

class SupportScreen extends StatefulWidget {

  const SupportScreen({Key? key}) : super(key: key);

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {

  final AnalyticService _analyticService = Get.find();

  @override
  void initState() {
    super.initState();

    _analyticService.setCurrentScreen(ROUTE_SUPPORT);
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hỗ trợ'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: defaultPadding),
          child: Column(
            children: [
              Image.asset(
                'assets/images/app_icon_transparent.png',
                width: 150,
                height: 150,
              ),
              const Divider(),

              _buildPrimaryTitle('Kênh liên lạc hỗ trợ'),
              _buildListItem(
                  'Email: ezlaunchgroup@gmail.com'
              ),
              const Divider(),

              _buildSecondaryTitle('Forwa sẽ hỗ trợ bạn trong các trường hợp sau'),
              _buildListItem(
                  'Hỗ trợ lỗi phát sinh khi sử dụng app'
              ),
              _buildListItem(
                  'Hỗ trợ kĩ thuật'
              ),
              _buildListItem(
                  'Liên hệ hợp tác từ thiện'
              ),
              _buildListItem(
                  'Với các trường hợp khác, vui lòng xem lại mục Điều khoản'
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildPrimaryTitle(String text){
    final theme = Theme.of(Get.context!);
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
    final theme = Theme.of(Get.context!);
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
    final theme = Theme.of(Get.context!);
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