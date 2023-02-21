import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:wallpapers/ui/constant/api_constants.dart';
import 'package:wallpapers/ui/controller/home_controller.dart';
import 'package:wallpapers/ui/controller/popular_controller.dart';
import 'package:wallpapers/ui/helpers/app_extension.dart';
import 'package:wallpapers/ui/views/components/image_rail_item.dart';
import 'package:wallpapers/ui/views/components/skeleton.dart';

class PopularScreen extends StatefulWidget {
  const PopularScreen({Key? key}) : super(key: key);

  @override
  State<PopularScreen> createState() => _PopularScreenState();
}

class _PopularScreenState extends State<PopularScreen> {
  PopularController popularController = Get.put(PopularController());
  HomeController homeController = Get.find<HomeController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.isLoadMore && !popularController.paginationEnded) {
        popularController.mStart += ApiConstant.limit;
        popularController.getAllImages();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => popularController.isDataLoading.value
          ? renderSkeletonView()
          : Container(
              color: Colors.white,
              padding: const EdgeInsets.all(12),
              child: StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 12,
                  controller: _scrollController,
                  itemCount: popularController.imagesList.length,
                  itemBuilder: (context, index) {
                    return ImageRailItem(
                        imageData: popularController.imagesList[index]);
                  },
                  staggeredTileBuilder: (index) {
                    return const StaggeredTile.count(1, 1.8);
                  }),
            ).fadeAnimation(0.6)),
    );
  }

  renderSkeletonView() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: StaggeredGridView.countBuilder(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 12,
          itemCount: 10,
          itemBuilder: (context, index) {
            return const Skeleton();
          },
          staggeredTileBuilder: (index) {
            return const StaggeredTile.count(1, 1.8);
          }),
    );
  }

}
