import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallpapers/ui/helpers/app_extension.dart';
import 'package:wallpapers/ui/views/components/image_rail_item.dart';

import '../constant/api_constants.dart';
import '../controller/home_controller.dart';
import '../controller/images_list_controller.dart';
import 'components/skeleton.dart';

class ImagesListScreen extends StatefulWidget {
  const ImagesListScreen({Key? key}) : super(key: key);

  @override
  State<ImagesListScreen> createState() => _ImagesListScreenState();
}

class _ImagesListScreenState extends State<ImagesListScreen> {
  ImagesController imagesController = Get.put(ImagesController());
  HomeController homeController = Get.find<HomeController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.isLoadMore && !imagesController.paginationEnded) {
        imagesController.mStart += ApiConstant.limit;
        imagesController.getAllImagesByCategoryId();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(imagesController.categoryItem!.name!),
        titleTextStyle: GoogleFonts.openSans(
            textStyle: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () {
            Get.back();
          },
          iconSize: 24,
        ),
        iconTheme: const IconThemeData.fallback(),
      ),
      body: Obx(() => imagesController.isDataLoading.value
          ? renderSkeletonView()
          : Container(
              color: Colors.white,
              padding: const EdgeInsets.all(12),
              child: StaggeredGridView.countBuilder(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 12,
                  controller: _scrollController,
                  itemCount: imagesController.imagesList.length,
                  itemBuilder: (context, index) {
                    return ImageRailItem(
                        imageData: imagesController.imagesList[index],
                        isCategoryImageList: true);
                  },
                  staggeredTileBuilder: (index) {
                    return StaggeredTile.count(1, index.isEven ? 1.2 : 1.8);
                  }),
            ).fadeAnimation(0.6)),
    );
  }

  renderSkeletonView() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: StaggeredGridView.countBuilder(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 12,
          itemCount: 10,
          itemBuilder: (context, index) {
            return const Skeleton();
          },
          staggeredTileBuilder: (index) {
            return StaggeredTile.count(1, index.isEven ? 1.2 : 1.8);
          }),
    );
  }
}
