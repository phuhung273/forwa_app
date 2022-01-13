import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forwa_app/screens/introduction/intro_screen_controller.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';

const IMAGE_HEIGHT = 250.0;

class IntroScreen extends GetView<IntroScreenController> {

  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IntroductionScreen(
      isTopSafeArea: true,
      pages: [
        _buildPageView(
          'Forwa',
          'Nơi mà các bạn có thể cho và nhận những món đồ miễn phí',
          'undraw_empty_re_opql.svg',
        ),
        _buildPageView(
          'Cho Đi',
          'Đồ không còn nhu cầu dùng, bạn có thể cho đi',
          'undraw_add_post_re_174w.svg',
          description: 'Chụp hình - Nhập thông tin - Tải lên'
        ),
        _buildPageView(
          'Nhận Lấy',
          'Bạn có thể xin nhận tất cả các món đồ trên ứng dụng',
          'undraw_gift_card_re_5dyy.svg',
          description: 'Xem - Chọn và liên hệ người cho - Chờ xác nhận',
        ),
        _buildPageView(
          'Happy Sharing',
          'Chia sẻ nhiều hơn, quan tâm nhiều hơn, lãng phí ít hơn',
          'undraw_happy_announcement_re_tsm0.svg',
          description: 'Đánh giá để nhận quà'
        ),
      ],
      onDone: controller.done,
      onSkip: controller.doneAndNeverShowAgain,
      showSkipButton: true,
      skip: Text(
        'Bỏ qua',
        style: theme.textTheme.caption,
      ),
      next: Text(
        'Tiếp',
        style: theme.textTheme.subtitle1,
      ),
      done: Text(
        'Xong',
        style: theme.textTheme.subtitle1?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.secondary
        )
      ),
    );
  }

  PageViewModel _buildPageView(
    String title,
    String body,
    String imagePath,
    {
      String? description
    }
  ){
    final theme = Theme.of(Get.context!);

    return PageViewModel(
      title: title,
      body: description == null ? body : null,
      bodyWidget: description != null
        ? Column(
          children: [
            Text(
              body,
              textAlign: TextAlign.center,
            ),
            const Divider(),
            Text(
              description,
              textAlign: TextAlign.center,
            ),
          ],
        )
        : null,
      image: SvgPicture.asset(
        'assets/images/$imagePath',
        height: IMAGE_HEIGHT
      ),
      decoration: PageDecoration(
        imageFlex: 3,
        bodyFlex: 2,
        contentMargin: const EdgeInsets.only(
          left: 48.0,
          right: 48.0,
          top: 48.0,
          bottom: 16.0,
        ),
        bodyTextStyle: theme.textTheme.subtitle1!.copyWith(
          color: Colors.grey[600],
        ),
        titleTextStyle: theme.textTheme.headline6!.copyWith(
          fontWeight: FontWeight.bold,
        )
      )
    );
  }
}