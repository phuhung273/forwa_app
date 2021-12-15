import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/product/product.dart';
import 'package:forwa_app/screens/components/appbar_chat_action.dart';
import 'package:forwa_app/screens/main/main_screen_controller.dart';
import 'package:forwa_app/widgets/rating.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import 'home_screen_controller.dart';

class HomeScreen extends StatelessWidget {

  final HomeScreenController _controller = Get.put(HomeScreenController());
  final MainScreenController _mainController = Get.find();

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return RefreshIndicator(
      onRefresh: _controller.main,
      color: theme.colorScheme.secondary,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverAppBar(
            floating: true,
            leading: Container(
              margin: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.menu,
                  color: theme.colorScheme.secondary,
                ),
                iconSize: 20.0,
                onPressed: () => _mainController.openDrawer(),
              ),
            ),
            actions: [
              AppBarChatAction()
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                // borderRadius: roundedRectangleBorderRadius,
              ),
              child: Text(
                'Chào buổi sáng, ${_mainController.fullname.isNotEmpty ? _mainController.fullname : 'người lạ'}!',
                style: theme.textTheme.subtitle1?.copyWith(
                  color: theme.colorScheme.secondary,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                        margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                        child: Text(
                          'Miễn phí',
                          style: theme.textTheme.subtitle1?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ]
                  ),
                  Obx(
                    () => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _controller.products.length,
                      itemBuilder: (context, index) {
                        final product = _controller.products[index];
                        return InkWell(
                          onTap: () => Get.toNamed(ROUTE_PRODUCT, arguments: product.id),
                          child: ProductCard(
                            product: product,
                          )
                        );
                      }
                    ),
                  ),
                  const Divider(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

const IMAGE_WIDTH = 140.0;
const REPORT_PRODUCT_ID = 'product_id';
const REPORT_USER_ID = 'user_id';

class ProductCard extends GetView<HomeScreenController> {
  final Product product;
  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final name = product.sellerName!;
    final List<String> words = name.split(' ');
    final List<String> shortWords = words.length > 1 ? [words.first, words.last] : [words.first];

    final imageUrl = product.firstImageUrl;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Card(
        shape: roundedRectangleShape,
        elevation: 4.0,
        child: Row(
          children: [
            Container(
              height: IMAGE_WIDTH,
              width: IMAGE_WIDTH,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: roundedRectangleBorderRadius
              ),
              margin: const EdgeInsets.only(
                right: 0.0,
                left: 8.0,
                top: 4.0,
                bottom: 4.0,
              ),
              child: ExtendedImage.network(
                '$HOST_URL$imageUrl',
                width: IMAGE_WIDTH,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                  top: 0.0,
                  bottom: 4.0,
                  right: 4.0,
                  left: 12.0
                ),
                child: SizedBox(
                  height: 170.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            child: const Icon(Icons.more_horiz),
                            onTap: () => controller.showReportModal({
                              REPORT_PRODUCT_ID: product.id,
                              REPORT_USER_ID: product.user?.id
                            }),
                          )
                        ],
                      ),
                      ListTile(
                        minVerticalPadding: 0.0,
                        minLeadingWidth: 0.0,
                        horizontalTitleGap: 8.0,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        leading: CircleAvatar(
                          radius: 16.0,
                          backgroundColor: theme.colorScheme.secondary,
                          child: Text(
                            shortWords.map((e) => e[0]).join(),
                            style: theme.textTheme.bodyText1!.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        title: Text(
                          // shortWords.join(' '),
                          name,
                          style: theme.textTheme.bodyText1?.copyWith(
                            fontWeight: FontWeight.w600
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Rating(score: 5, size: 12.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Text(
                          product.name,
                          style: theme.textTheme.bodyText1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'Cách ${_buildDistance()}km',
                          style: theme.textTheme.bodyText1?.copyWith(
                            color: theme.colorScheme.secondary
                          ),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 4.0,
                            right: 4.0,
                          ),
                          child: Text(
                            'Mới lên',
                            textAlign: TextAlign.end,
                            style: theme.textTheme.bodyText1?.copyWith(
                                // color: theme.colorScheme.secondaryVariant
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[600]
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String _buildDistance() {
    final here = controller.here;
    return here != null && product.location != null
        ? (controller.distance.as(LengthUnit.Meter,
        LatLng(here.latitude!, here.longitude!), product.location!) / 1000)
        .toStringAsFixed(1)
        : '';
  }
}
