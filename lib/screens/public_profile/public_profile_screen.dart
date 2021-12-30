import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/helpers/url_helper.dart';
import 'package:forwa_app/mixins/reportable.dart';
import 'package:forwa_app/schema/review/review.dart';
import 'package:forwa_app/widgets/rating.dart';
import 'package:get/get.dart';

import 'public_profile_screen_controller.dart';

const REPORT_USER_ID = 'user_id';

class PublicProfileScreen extends GetView<PublicProfileScreenController> {

  const PublicProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () => controller.showReportModal(
              {
                REPORT_USER_ID: controller.userId
              },
              [
                ReportType.USER,
              ]
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Profile(),
            const Divider(),
            // Obx(
            //   () => ListView.separated(
            //     shrinkWrap: true,
            //     physics: const NeverScrollableScrollPhysics(),
            //     itemCount: controller.reviews.length,
            //     itemBuilder: (context, index) =>
            //       ReviewItem(review: controller.reviews[index]),
            //     separatorBuilder: (context, index) => const SizedBox(height: defaultPadding),
            //   ),
            // )
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${controller.reviews.length} đánh giá',
                    style: theme.textTheme.subtitle1?.copyWith(
                        fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.reviews.length,
                    itemBuilder: (context, index){
                      final review = controller.reviews[index];
                      return ReviewItem(
                        review: review
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(),
                  ),
                  const Divider(),
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}

const AVATAR_SIZE = 90.0;

class Profile extends GetView<PublicProfileScreenController> {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final name = controller.name.isNotEmpty ? controller.name.value : 'Không tên';

      return Column(
        children: [
          const SizedBox(height: 16.0),
          _buildAvatar(),
          const SizedBox(height: 16.0),
          Text(
            name,
            style: theme.textTheme.subtitle1,
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceAround,
            children: const [
              Expanded(
                child: ItemCountBox(),
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: RatingBox(),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildAvatar(){
    final theme = Theme.of(Get.context!);
    final name = controller.name.isNotEmpty ? controller.name.value : 'Không tên';
    final List<String> words = name.split(' ');
    final List<String> shortWords = words.length > 1 ? [words.first, words.last] : [words.first];

    return Container(
      width: AVATAR_SIZE,
      height: AVATAR_SIZE,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: theme.colorScheme.secondary
      ),
      child: controller.avatar.isEmpty
        ? Center(
          child: Text(
            shortWords[0].isEmpty ? '' : shortWords.map((e) => e[0]).join(),
            style: theme.textTheme.headline5!.copyWith(
              color: Colors.white,
            ),
          ),
        )
        : ExtendedImage.network(
          resolveUrl(controller.avatar.value, HOST_URL),
          fit: BoxFit.cover,
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
            style: theme.textTheme.subtitle1,
          ),
          Obx(
            () => Text(
              controller.productsCount.string,
              style: theme.textTheme.subtitle1?.copyWith(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Rating(
                score: 1,
                color: theme.colorScheme.secondary,
              ),
              Obx(
                () => Text(
                  controller.rating.value.toString(),
                  style: theme.textTheme.subtitle1?.copyWith(
                    color: theme.colorScheme.secondary
                  ),
                ),
              ),
            ],
          ),
          Text(
            '${controller.reviews.length.toString()} đánh giá',
            style: theme.textTheme.subtitle1?.copyWith(
              color: Colors.grey[500]
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
      padding: const EdgeInsets.all(2.0),
      child: child,
      height: 80.0,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }
}

const IMAGE_WIDTH = 120.0;
const REVIEW_AVATAR_SIZE = 16.0;

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
    final imageUrl = review.firstImageUrl;

    return Row(
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          width: IMAGE_WIDTH,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ExtendedImage.network(
            resolveUrl(imageUrl!, HOST_URL),
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0),
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
                  leading: _buildAvatar(),
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

  Widget _buildAvatar(){
    final theme = Theme.of(Get.context!);
    final name = review.fromUser?.name ?? 'Không tên';
    final words = name.split(' ');
    final shortWords = words.length > 1 ? [words.first, words.last] : [words.first];

    if(review.fromUser?.imageUrl == null){
      return CircleAvatar(
        radius: REVIEW_AVATAR_SIZE,
        child: Text(
          shortWords.map((e) => e[0]).join(),
          style: theme.textTheme.bodyText1!.copyWith(
            color: Colors.white,
          ),
        ),
      );
    }

    return ExtendedImage.network(
      resolveUrl(review.fromUser!.imageUrl!, HOST_URL),
      fit: BoxFit.cover,
      shape: BoxShape.circle,
      width: REVIEW_AVATAR_SIZE * 2,
      height: REVIEW_AVATAR_SIZE * 2,
    );
  }
}