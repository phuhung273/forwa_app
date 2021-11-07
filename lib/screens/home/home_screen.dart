import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/helpers/url_helper.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/product/product.dart';
import 'package:forwa_app/screens/main/main_screen_controller.dart';
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

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          // title: const Text('Forwa'),
          floating: true,
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _mainController.openDrawer(),
          ),
          // title: Text(_controller.greeting.value),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.send,
                // color: theme.colorScheme.secondary,
              ),
              onPressed: (){ },
            )
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(defaultSpacing),
            child: Column(
              children: [
                Text(
                  'Hãy cho đi đồ không dùng tới người xung quanh có nhu cầu, giảm lãng phí, giải phóng không gian sống, và giảm chất thải vào môi trường.',
                  style: theme.textTheme.headline6?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: defaultSpacing),
                  child: Obx(
                    () => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _controller.products.length,
                      itemBuilder: (context, index) {
                        final product = _controller.products[index];
                        return InkWell(
                          onTap: () => Get.toNamed(ROUTE_PRODUCT, arguments: product.sku),
                          child: ProductCard(
                            product: product,
                          )
                        );
                        }
                      ),
                  ),
                ),
                const Divider(),
              ],
            ),
          ),
        )
      ],
    );
  }
}

const IMAGE_WIDTH = 150.0;

class ProductCard extends GetView<HomeScreenController> {
  final Product product;
  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final name = product.sellerName ?? 'Không tên';
    final List<String> words = name.split(' ');
    final List<String> shortWords = words.length > 1 ? [words.first, words.last] : [words.first];

    final imageUrl = product.firstImageUrl;

    return  Card(
      child: Row(
        children: [
          SizedBox(
            height: IMAGE_WIDTH,
            width: IMAGE_WIDTH,
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //     image: NetworkImage(
            //       'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTRMJzoA-zbaFtz6UF7qt9Be1d_601nNAoDTA&usqp=CAU',
            //     ),
            //     fit: BoxFit.cover,
            //   )
            // ),
            child: ExtendedImage.network(
              imageUrl != null
                  ? resolveUrl(imageUrl)
                  : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTRMJzoA-zbaFtz6UF7qt9Be1d_601nNAoDTA&usqp=CAU',
              width: IMAGE_WIDTH,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                    child: Text(
                      product.name,
                      style: theme.textTheme.subtitle1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Cách đây ${_buildDistance()}km',
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      )
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
