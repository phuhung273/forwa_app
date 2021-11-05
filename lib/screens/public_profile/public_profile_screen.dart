import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/widgets/headless_table.dart';
import 'package:forwa_app/widgets/rating.dart';
import 'package:forwa_app/widgets/section_divider.dart';
import 'package:get/get.dart';

import 'public_profile_screen_controller.dart';

class PublicProfileScreen extends StatelessWidget {

  final PublicProfileScreenController _controller = Get.find();

  PublicProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            const SliverAppBar(),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: const ProfileSection(),
                  ),
                  const SectionDivider(),
                  Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Text(
                      'Tổng cho đi: 20',
                      style: theme.textTheme.headline6,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 5,
                      itemBuilder: (context, index) =>
                          GivingItem(),
                      separatorBuilder: (context, index) => const SizedBox(height: defaultPadding),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}

class ProfileSection extends StatelessWidget {
  const ProfileSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = 'Tran Pham Phu Hung';
    final List<String> words = name.split(' ');
    final List<String> shortWords = words.length > 1 ? [words.first, words.last] : [words.first];

    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              height: 115,
              width: 115,
              child: CircleAvatar(
                radius: 24.0,
                child: Text(
                  shortWords.map((e) => e[0]).join(),
                  style: theme.textTheme.headline5!.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: defaultPadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.headline6,
                  ),
                  const Rating(score: 3),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Flexible(
                            child: Text('3.5km')
                        ),
                        const Spacer(),
                        Flexible(
                            child: Text('27-10-2021')
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Divider(),
        Text(
          'Hãy cho đi đồ không dùng tới người xung quanh có nhu cầu, giảm lãng phí, giải phóng không gian sống, và giảm chất thải vào môi trường.',
          style: theme.textTheme.headline6?.copyWith(
            color: Colors.grey,
          ),
        ),
        const Divider(),
        HeadlessTable(
          striped: false,
          matchBackground: true,
          columnWidths: const {
            0: FixedColumnWidth(120),
            1: FlexColumnWidth(),
          },
          data: {
            'Thích': 'Bóng đá, phim, game',
            'Không thích': 'Bóng đá, phim, game'
          },
        ),
      ],
    );
  }
}

const IMAGE_WIDTH = 150.0;

class GivingItem extends StatelessWidget {
  const GivingItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        ExtendedImage.network(
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTRMJzoA-zbaFtz6UF7qt9Be1d_601nNAoDTA&usqp=CAU',
          width: IMAGE_WIDTH,
          fit: BoxFit.cover,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              'Tên đồ vật',
              style: theme.textTheme.headline6,
            ),
          )
        ),
      ],
    );
  }
}