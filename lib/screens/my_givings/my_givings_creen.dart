import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/helpers/url_helper.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/product/product.dart';
import 'package:forwa_app/screens/choose_receiver/choose_receiver_screen_controller.dart';
import 'package:forwa_app/screens/components/appbar_chat_action.dart';
import 'package:forwa_app/screens/main/main_screen.dart';
import 'package:forwa_app/screens/main/main_screen_controller.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'my_giving_screen_controller.dart';

class MyGivingsScreen extends StatefulWidget {

  const MyGivingsScreen({Key? key}) : super(key: key);

  @override
  State<MyGivingsScreen> createState() => _MyGivingsScreenState();
}

class _MyGivingsScreenState extends State<MyGivingsScreen>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  final MyGivingsScreenController _controller = Get.find();

  final MainScreenController _mainController = Get.find();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        _mainController.changeTab(HOME_SCREEN_INDEX);
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: RefreshIndicator(
            color: theme.colorScheme.secondary,
            onRefresh: _controller.authorizedMain,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
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
                SliverFillRemaining(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(
                              () => Text(
                                'Bạn đã cho đi: ${_controller.products.length}',
                                style: theme.textTheme.subtitle1,
                              ),
                            ),
                            // ElevatedButton(
                            //   style: ElevatedButton.styleFrom(
                            //     shape: thinRoundedRectangleShape,
                            //     padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                            //     primary: secondaryColor,
                            //     onPrimary: Colors.white,
                            //   ),
                            //   onPressed: _mainController.toGiveScreen,
                            //   child: const Text('Tải lên')
                            // )
                          ],
                        ),
                      ),
                      const Divider(),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: Obx(
                            () => ScrollablePositionedList.builder(
                              itemCount: _controller.products.length,
                              itemPositionsListener: _controller.itemPositionsListener,
                              itemBuilder: (context, index) {
                                final product = _controller.products[index];
                                return InkWell(
                                  onTap: () => _buildOnTapCard(product),
                                  child: GivingItem(
                                    product: product
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ),
    );
  }

  Future? _buildOnTapCard(Product product){
    if(product.haveOrders){
      return Get.toNamed(
          ROUTE_CHOOSE_RECEIVER,
          parameters: {
            productIdParamChooseReceiver: product.id.toString(),
          }
      );
    }
  }
}

const IMAGE_WIDTH = 140.0;

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
                top: 8.0,
                bottom: 8.0,
              ),
              child: ExtendedImage.network(
                resolveUrl(imageUrl!, HOST_URL),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        product.name,
                        style: theme.textTheme.bodyText1?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if(product.haveOrders)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: RichText(
                          text: TextSpan(
                            text: '${product.orderCount} người',
                            style: theme.textTheme.bodyText1?.copyWith(
                              color: theme.colorScheme.secondaryVariant,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: ' đang xin',
                                style: theme.textTheme.bodyText1,
                              )
                            ]
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: StatusChip(status: product.status!),
                    ),
                  ],
                ),
              ),
            ),
            if(product.haveOrders)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.arrow_forward_ios),
              ),
          ],
        ),
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  final ProductStatus status;
  const StatusChip({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Chip(
      backgroundColor: _buildColor(status),
      avatar: Icon(
        _buildIcon(status),
        color: Colors.white,
      ),
      label: Text(
        _buildMessage(status),
        style: theme.textTheme.bodyText1?.copyWith(
            color: Colors.white
        ),
      ),
    );
  }

  IconData _buildIcon(ProductStatus status){
    switch(status){
      case ProductStatus.PROCESSING:
        return Icons.pending;
      case ProductStatus.FINISH:
        return Icons.done;
      default:
        return Icons.pending;
    }
  }

  _buildColor(ProductStatus status){
    switch(status){
      case ProductStatus.PROCESSING:
        return Colors.blueGrey;
      case ProductStatus.FINISH:
        return Colors.green;
      default:
        return Colors.blueGrey;
    }
  }

  _buildMessage(ProductStatus status){
    switch(status){
      case ProductStatus.PROCESSING:
        return 'Đang cho đi';
      case ProductStatus.FINISH:
        return 'Đã xong';
      default:
        return 'Đang cho đi';
    }
  }
}