import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/schema/review/review.dart';
import 'package:forwa_app/widgets/rating.dart';
import 'package:get/get.dart';

import 'public_profile_screen_controller.dart';

class PublicProfileScreen extends GetView<PublicProfileScreenController> {

  const PublicProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 280,
                  padding: const EdgeInsets.only(top: 50),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(0.5, 0.0),
                      colors: <Color>[
                        theme.colorScheme.secondary,
                        theme.colorScheme.secondaryVariant,
                      ],
                    ),
                    // color: Colors.orange,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(height: defaultSpacing * 2),
                      Obx(
                        () => ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.reviews.length,
                          itemBuilder: (context, index) =>
                              ReviewItem(review: controller.reviews[index]),
                          separatorBuilder: (context, index) => const SizedBox(height: defaultPadding),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const Positioned(
              top: 140,
              left: 0,
              right: 0,
              // bottom: 0,
              child: Profile(),
            ),
          ],
        ),
      ),
    );
  }
}

class Profile extends GetView<PublicProfileScreenController> {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: defaultSpacing),
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ]
      ),
      child: Obx(() {
        final name = controller.name.value;
        final List<String> words = name.split(' ');
        final List<String> shortWords = words.length > 1 ? [words.first, words.last] : [words.first];

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.subtitle1,
                  ),
                  // const Divider(),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      const ItemCountBox(),
                      _buildVerticalDivider(),
                      const RatingBox(),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: -32.0,
              left: 0,
              right: 0,
              child: Center(
                child: CircleAvatar(
                  radius: 48.0,
                  child: Text(
                    shortWords[0].isEmpty ? '' : shortWords.map((e) => e[0]).join(),
                    style: theme.textTheme.headline5!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      }),
    );
  }

  Widget _buildVerticalDivider(){
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 8,
      ),
      child: Container(
        height: 50,
        width: 3,
        decoration: BoxDecoration(
          borderRadius:
          BorderRadius.circular(100),
          color: Colors.grey,
        ),
      ),
    );
  }
}

class ItemCountBox extends GetView<PublicProfileScreenController> {
  const ItemCountBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AchievementContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Đã cho đi',
            style: theme.textTheme.headline6,
          ),
          const SizedBox(height: defaultPadding),
          Obx(
            () => Text(
              controller.reviews.length.toString(),
              style: theme.textTheme.headline6?.copyWith(
                  color: theme.colorScheme.secondary
              ),
            ),
          ),
        ],
      )
    );
  }
}

class RatingBox extends GetView<PublicProfileScreenController> {
  const RatingBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AchievementContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Đánh giá',
              style: theme.textTheme.headline6,
            ),
            const SizedBox(height: defaultPadding),
            Obx(
              () => Text(
                controller.rating.value.toString(),
                style: theme.textTheme.headline6?.copyWith(
                    color: theme.colorScheme.secondary
                ),
              ),
            ),
          ],
        )
    );
  }
}


class AchievementContainer extends StatelessWidget {
  final Widget child;
  const AchievementContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(2.0),
      width: 100,
      height: 100,
      child: child,
    );
  }
}

const IMAGE_WIDTH = 150.0;

class ReviewItem extends StatelessWidget {
  final Review review;
  const ReviewItem({
    Key? key,
    required this.review,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = review.fromUser?.name ?? 'Không tên';
    final words = name.split(' ');
    final shortWords = words.length > 1 ? [words.first, words.last] : [words.first];

    return Row(
      children: [
        ExtendedImage.network(
          '$HOST_URL/${review.productBaseImageUrl}',
          width: IMAGE_WIDTH,
          fit: BoxFit.cover,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  review.productName ?? '',
                  style: theme.textTheme.headline6,
                ),
                const Divider(),
                ListTile(
                  minVerticalPadding: 0.0,
                  minLeadingWidth: 0.0,
                  horizontalTitleGap: 8.0,
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    child: Text(
                      shortWords.map((e) => e[0]).join(),
                      style: theme.textTheme.headline6!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  title: Text(
                    shortWords.join(' '),
                    style: theme.textTheme.subtitle1,
                    // overflow: TextOverflow.ellipsis,
                  ),
                  // subtitle: ,
                ),
                Rating(score: review.rating),
                Text(
                  review.message,
                  style: theme.textTheme.subtitle1,
                )
              ],
            ),
          )
        ),
      ],
    );
  }
}