import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/helpers/url_helper.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/screens/public_profile/public_profile_screen_controller.dart';
import 'package:forwa_app/widgets/app_container.dart';
import 'package:forwa_app/widgets/headless_table.dart';
import 'package:forwa_app/widgets/rating.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import 'product_screen_controller.dart';

class ProductScreen extends GetView<ProductScreenController> {

  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        if(controller.isNotificationStart){
          Get.offAndToNamed(ROUTE_MAIN);
          return false;
        } else {
          return true;
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Obx(
            () => CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  title: Text(
                    'Thông tin món đồ',
                    style: theme.textTheme.headline6
                  ),
                  leading: controller.isNotificationStart
                    ? IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                      ),
                      iconSize: 20.0,
                      onPressed: () => Get.offAndToNamed(ROUTE_MAIN),
                    )
                    : null,
                ),
                if(controller.name.isNotEmpty)
                  const SliverToBoxAdapter(
                    child: ProductRender(),
                  ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}

class ProductRender extends GetView<ProductScreenController> {
  const ProductRender({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ImageSlider(),
          const DotIndicator(),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              clipBehavior: Clip.antiAlias,
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: const SellerInfoSection()
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: (){
                    Clipboard.setData(ClipboardData(text: 'http://forwa.co?id=${controller.id}'))
                      .then(
                        (_) => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Đã lưu vào khay nhớ'))
                      )
                    );
                  },
                  child: const Text('Chia sẻ'),
                )
              ],
            ),
          ),
          AppContainer(
            padding: const EdgeInsets.only(
              left: 12.0,
              top: 24.0
            ),
            child: Text(
              'Thông Tin Chi tiết',
              style: theme.textTheme.subtitle1?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.secondary
              ),
            )
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              clipBehavior: Clip.antiAlias,
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: const ProductPrimaryInfoSection()
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: const PickupSection(),
          ),
          Center(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: _buildTakeButton(),
            ),
          ),
          const Divider(),
        ]
    );
  }

  _buildTakeButton(){
    if(!controller.enabled.value){
      return const TextButton(
        onPressed: null,
        child: Text('Không thể nhận'),
      );
    }
    return ElevatedButton(
      onPressed: controller.toTakeScreen,
      child: const Text('Tôi muốn nhận'),
    );
  }
}

const AVATAR_SIZE = 24.0;

class SellerInfoSection extends GetView<ProductScreenController> {
  const SellerInfoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sellerName = controller.sellerName.value;

    return AppContainer(
      decoration: BoxDecoration(
        color: Colors.grey[200]
      ),
      child: ListTile(
        minVerticalPadding: 0.0,
        minLeadingWidth: 0.0,
        contentPadding: EdgeInsets.zero,
        onTap: () => Get.toNamed(
          ROUTE_PUBLIC_PROFILE,
          parameters: {
            userIdParam: controller.userId.toString()
          }
        ),
        leading: _buildAvatar(),
        title: Text(
          sellerName,
          style: theme.textTheme.subtitle1,
          // overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          children: [
            Row(
              children: [
                const Rating(score: 3),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Muốn cho đi',
                  style: theme.textTheme.bodyText1?.copyWith(
                      color: Colors.grey[600]
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(){
    final theme = Theme.of(Get.context!);
    final sellerName = controller.sellerName.value;
    final List<String> words = sellerName.split(' ');
    final List<String> shortWords = words.length > 1 ? [words.first, words.last] : [words.first];

    if(controller.avatar.isEmpty){
      return CircleAvatar(
        radius: AVATAR_SIZE,
        backgroundColor: theme.colorScheme.secondary,
        child: Text(
          shortWords.map((e) => e[0]).join(),
          style: theme.textTheme.headline6!.copyWith(
            color: Colors.white,
          ),
        ),
      );
    }

    return ExtendedImage.network(
      resolveUrl(controller.avatar.value, HOST_URL),
      fit: BoxFit.cover,
      shape: BoxShape.circle,
      width: AVATAR_SIZE * 2,
      height: AVATAR_SIZE * 2,
    );
  }
}

class ProductPrimaryInfoSection extends GetView<ProductScreenController> {
  const ProductPrimaryInfoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppContainer(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
          color: Colors.grey[200]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    controller.name.value,
                    style: theme.textTheme.subtitle1,
                    // overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              controller.description.value,
              style: theme.textTheme.bodyText1,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Ngày đăng',
                    style: theme.textTheme.bodyText1?.copyWith(
                      color: Colors.grey[600]
                    ),
                  ),
                  Text(
                    controller.createdAt.value,
                    style: theme.textTheme.bodyText1?.copyWith(
                        color: Colors.grey[600]
                    ),
                  )
                ],
              )
            ],
          ),
          const SizedBox(height: 16.0),
          HeadlessTable(
            striped: false,
            matchBackground: true,
            data: {
              'Cách đây': '${_buildDistance()} km',
              'Ngày hết hạn': controller.dueDate.value,
              'Giờ có thể lấy': controller.pickupTime.value,
            },
          )
        ],
      ),
    );
  }

  String _buildDistance() {
    final here = controller.here;
    return here != null && controller.location != null
        ? (controller.distance.as(LengthUnit.Meter,
        LatLng(here.latitude, here.longitude), controller.location!) / 1000)
        .toStringAsFixed(1)
        : '';
  }
}


const IMAGE_HEIGHT = 340.0;

class ImageSlider extends GetView<ProductScreenController> {
  const ImageSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return CarouselSlider(
      items: controller.images.map((item) => Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: ExtendedImage.network(
          resolveUrl(item, HOST_URL),
          // width: size.width,
          fit: BoxFit.cover,
        ),
      )).toList(),
      carouselController: controller.sliderController,
      options: CarouselOptions(
        enlargeCenterPage: true,
        aspectRatio: 1.0,
        viewportFraction: 1.0,
        height: IMAGE_HEIGHT,
        enableInfiniteScroll: false,
        onPageChanged: (index, _) => controller.page = index
      ),
    );
  }
}

class DotIndicator extends GetView<ProductScreenController> {
  const DotIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for(var i = 0; i < controller.images.length; i++)
            GestureDetector(
              onTap: () => controller.sliderController.animateToPage(i),
              child: Container(
                width: 12.0,
                height: 12.0,
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // color: (Theme.of(context).brightness == Brightness.dark
                  //     ? Colors.white
                  //     : theme.colorScheme.secondary)
                  //     .withOpacity(controller.page == i ? 0.9 : 0.4)
                  color: controller.page == i
                      ? theme.colorScheme.secondary
                      : Colors.grey[200]
                ),
              ),
            )
        ],
      ),
    );
  }
}

class PickupSection extends GetView<ProductScreenController> {
  const PickupSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppContainer(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 0.0,
              top: 8.0,
              bottom: 12.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Khu Vực',
                    style: theme.textTheme.subtitle1?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          PickupLocation(location: controller.wardLocation!)
        ],
      ),
    );
  }
}


class PickupLocation extends StatelessWidget {
  final LatLng location;
  const PickupLocation({
    Key? key,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final constraints = BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height,
        maxWidth: MediaQuery.of(context).size.width);

    return Container(
      height: constraints.maxHeight * 0.4,
      width: constraints.maxWidth * 1.0,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: FlutterMap(
        options: MapOptions(
          center: location,
          zoom: 17.0,
          maxZoom: 20.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayerOptions(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: location,
                builder: (ctx) => const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 36.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
