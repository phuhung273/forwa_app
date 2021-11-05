import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/helpers/url_helper.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/product/product.dart';
import 'package:forwa_app/widgets/secondary_action_container.dart';
import 'package:get/get.dart';

import 'my_giving_screen_controller.dart';

const DEFAULT_MAX_QUANTITY = 5;

class MyGivingsScreen extends StatelessWidget {

  final MyGivingsScreenController _controller = Get.put(MyGivingsScreenController());

  MyGivingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            const SliverAppBar(
              automaticallyImplyLeading: false,
              title: Text('Danh Sách Cho Đi'),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(defaultSpacing),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () => Text(
                            'Tổng cho đi: ${_controller.products.length}',
                            style: theme.textTheme.headline6,
                          ),
                        ),
                        SecondaryActionContainer(
                          child: ElevatedButton(
                            onPressed: () => Get.toNamed(ROUTE_GIVE),
                            child: const Text('Tải lên')
                          ),
                        )
                      ],
                    ),
                    const Divider(),
                    Obx(
                      () => ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _controller.products.length,
                        itemBuilder: (context, index) =>
                          InkWell(
                            onTap: () => Get.toNamed(
                              ROUTE_CHOOSE_RECEIVER,
                              arguments: _controller.products[index].id
                            ),
                            child: GivingItem(product: _controller.products[index]),
                          ),
                        separatorBuilder: (context, index) => const SizedBox(height: defaultPadding),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}

const IMAGE_WIDTH = 150.0;

class GivingItem extends StatelessWidget {
  final Product product;
  const GivingItem({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl = product.firstImageUrl;
    return Row(
      children: [
        ExtendedImage.network(
          imageUrl != null
              ? resolveUrl(imageUrl)
              : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTRMJzoA-zbaFtz6UF7qt9Be1d_601nNAoDTA&usqp=CAU',
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
                  product.name,
                  style: theme.textTheme.headline6,
                ),
                if(product.quantity != null)
                  RichText(
                    text: TextSpan(
                      text: '${DEFAULT_MAX_QUANTITY - product.quantity!} người',
                      style: theme.textTheme.subtitle1?.copyWith(
                        color: theme.colorScheme.secondaryVariant,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(
                          text: ' đang xin',
                          style: theme.textTheme.subtitle1,
                        )
                      ]
                    ),
                  ),
              ],
            ),
          )
        ),
        const Icon(Icons.arrow_forward_ios),
      ],
    );
  }
}
