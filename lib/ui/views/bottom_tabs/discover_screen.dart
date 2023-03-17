import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wallpapers/ui/controller/discover_controller.dart';
import 'package:wallpapers/ui/helpers/app_extension.dart';
import 'package:wallpapers/ui/helpers/navigation_utils.dart';
import 'package:wallpapers/ui/models/category_data.dart';
import 'package:wallpapers/ui/views/components/skeleton.dart';
import 'package:wallpapers/ui/views/images_list_screen.dart';



class DiscoverScreen extends StatefulWidget {
  @override
  _DiscoverScreen createState() => _DiscoverScreen();
}

class _DiscoverScreen extends State<DiscoverScreen> {
  DiscoverController discoverController = Get.put(DiscoverController());

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        color: Colors.white,
        child: Obx(() => SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  _renderCarouselSlider(),
                  const SizedBox(height: 20),
                  _renderBetweenLabel("Popular Categories", false),
                  const SizedBox(height: 10),
                  _renderHorizontalUI(),
                  const SizedBox(height: 10),
                  _renderBetweenLabel("All Categories", true),
                  _renderAllCategoriesUI()
                ],
              ),
            )));
  }

  _navigateToImagesListScreen(CategoryData categoryItem) {
    var args = {'categoryItem': categoryItem};
    Go.to(const ImagesListScreen(), arguments: args);
  }

  _renderBetweenLabel(String label, bool isForAll) {
    return Column(
      children: [
        SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: const Divider(color: Colors.black45))
            .fadeAnimation(0.3),
        (isForAll
                ? discoverController.isAllDataLoading.value
                : discoverController.isPopularDataLoading.value)
            ? const Skeleton(
                width: 200,
                height: 30,
              )
            : Text(
                label,
                style: GoogleFonts.anton(
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w400)),
              ).fadeAnimation(0.4),
        SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: const Divider(color: Colors.black45))
            .fadeAnimation(0.5),
      ],
    );
  }

  _renderAllCategoriesUI() {
    return Container(
      margin: const EdgeInsets.all(12),
      child: StaggeredGridView.countBuilder(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          itemCount: discoverController.isAllDataLoading.value
              ? 10
              : discoverController.categoryList.length,
          itemBuilder: (context, index) {
            return discoverController.isAllDataLoading.value
                ? const Skeleton()
                : GestureDetector(
                    onTap: () => {
                      _navigateToImagesListScreen(
                          discoverController.categoryList[index])
                    },
                    child: Hero(
                      tag: discoverController.categoryList[index].id!,
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.transparent,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16)),
                              child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: discoverController
                                    .categoryList[index].thumbnailUrl!,
                                fit: BoxFit.cover,
                                height: double.infinity,
                                width: double.infinity,
                                alignment: Alignment.center,
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: const BoxDecoration(
                                  color: Colors.black45,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16))),
                            ),
                            Center(
                                child: Text(
                              discoverController.categoryList[index].name!,
                              style: GoogleFonts.anton(
                                  textStyle: const TextStyle(
                                      color: Colors.white, fontSize: 20)),
                            ))
                          ],
                        ),
                      ),
                    ),
                  );
          },
          staggeredTileBuilder: (index) {
            return StaggeredTile.count(1, index.isEven ? 0.5 : 1);
          }),
    ).fadeAnimation(0.6);
  }

  _renderCarouselSlider() {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.7,
        aspectRatio: 3,
        initialPage: 0,
      ),
      items: discoverController.trendingList.map((item) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                child: discoverController.isTrendingDataLoading.value
                    ? const Skeleton()
                    : InkWell(
                        onTap: () {
                          _navigateToImagesListScreen(item);
                        },
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16)),
                              child: CachedNetworkImage(
                                imageUrl: item.thumbnailUrl!,
                                fit: BoxFit.cover,
                                height: double.infinity,
                                width: double.infinity,
                                alignment: Alignment.center,
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: const BoxDecoration(
                                  color: Colors.black45,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16))),
                            ),
                            Center(
                                child: Text(
                              item.name!,
                              style: GoogleFonts.anton(
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400)),
                            ))
                          ],
                        ),
                      ));
          },
        );
      }).toList(),
    ).fadeAnimation(0.2);
  }

  _renderHorizontalUI() {
    return SizedBox(
      height: 80.0,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: discoverController.popularList.length,
        itemBuilder: (BuildContext ctx, int index) {
          CategoryData item = discoverController.popularList[index];
          return Container(
            width: 150,
            margin:
                EdgeInsets.only(left: (index == 0) ? 12.0 : 6.0, right: 6.0),
            child: discoverController.isPopularDataLoading.value
                ? const Skeleton()
                : InkWell(
                    onTap: () {
                      _navigateToImagesListScreen(item);
                    },
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16)),
                          child: Image.network(
                            item.thumbnailUrl!,
                            fit: BoxFit.cover,
                            height: double.infinity,
                            width: double.infinity,
                            alignment: Alignment.center,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: const BoxDecoration(
                              color: Colors.black45,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                        ),
                        Center(
                            child: Text(
                          item.name!,
                          style: GoogleFonts.anton(
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400)),
                        ))
                      ],
                    ),
                  ),
          );
        },
      ),
    ).fadeAnimation(0.3);
  }
}
