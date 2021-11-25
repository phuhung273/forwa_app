import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/screens/take/take_screen_controller.dart';
import 'package:forwa_app/widgets/app_container.dart';
import 'package:forwa_app/widgets/app_level_action_container.dart';
import 'package:forwa_app/widgets/headless_table.dart';
import 'package:forwa_app/widgets/rating.dart';
import 'package:forwa_app/widgets/section_divider.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import 'product_screen_controller.dart';

class ProductScreen extends GetView<ProductScreenController> {

  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        body: Obx(
          () => CustomScrollView(
            slivers: [
              const SliverAppBar(
                floating: true,
              ),
              if(controller.name.isNotEmpty)
                const SliverToBoxAdapter(
                  child: ProductRender(),
                ),
            ]
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
    final sellerName = controller.sellerName.value;
    final List<String> words = sellerName.split(' ');
    final List<String> shortWords = words.length > 1 ? [words.first, words.last] : [words.first];

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ImageSlider(),
          const DotIndicator(),
          AppContainer(
            child: ListTile(
              minVerticalPadding: 0.0,
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                radius: 24.0,
                child: Text(
                  shortWords.map((e) => e[0]).join(),
                  style: theme.textTheme.headline5!.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              title: Text(
                sellerName,
                style: theme.textTheme.subtitle1,
                // overflow: TextOverflow.ellipsis,
              ),
              subtitle: const Rating(score: 3),
            ),
          ),
          AppContainer(
            child: Text(
              controller.name.value,
              style: theme.textTheme.headline5,
            ),
          ),
          AppContainer(
            child: Text(
              controller.description.value,
              style: theme.textTheme.subtitle1,
            ),
          ),
          const SectionDivider(),
          AppContainer(
              child: Text(
                'Thông Tin Chi tiết',
                style: theme.textTheme.headline6,
              )
          ),
          AppContainer(
            child: HeadlessTable(
              data: {
                'Khoảng cách': '${_buildDistance()} km',
                'Ngày đăng': controller.createdAt.value,
                'Giờ có thể lấy': controller.pickupTime.value,
              },
            ),
          ),
          const SectionDivider(),
          AppContainer(
              child: Text(
                'Điểm Lấy Đồ',
                style: theme.textTheme.headline6,
              )
          ),
          if(controller.location != null)
            AppContainer(
              child: PickupLocation(location: controller.location!)
            ),
          const SectionDivider(),
          Center(
            child: AppLevelActionContainer(
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
      onPressed: () => Get.toNamed(
        ROUTE_TAKE,
        parameters: {
          idParam: controller.id.toString(),
          sellerNameParam: controller.sellerName.value,
        }
      ),
      child: const Text('Tôi muốn nhận'),
    );
  }

  String _buildDistance(){
    final here = controller.here;
    return here != null
        ? (controller.distance.as(LengthUnit.Meter,
        LatLng(here.latitude!, here.longitude!), controller.location!) / 1000).toStringAsFixed(1)
        : '';
  }
}


class ImageSlider extends GetView<ProductScreenController> {
  const ImageSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return CarouselSlider(
      items: controller.images.map((item) => ExtendedImage.network(
        '$HOST_URL/$item',
        width: size.width,
        fit: BoxFit.cover,
      )).toList(),
      carouselController: controller.sliderController,
      options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 1.0,
        viewportFraction: 1.0,
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
                    color: (Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black)
                        .withOpacity(controller.page == i ? 0.9 : 0.4)
                ),
              ),
            )
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

    return Center(
      child: SizedBox(
        height: constraints.maxHeight * 0.3,
        width: constraints.maxWidth * 0.7,
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
      ),
    );
  }
}
