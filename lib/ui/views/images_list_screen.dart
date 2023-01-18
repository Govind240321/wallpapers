import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wallpapers/ui/controller/images_list_controller.dart';
import 'package:wallpapers/ui/helpers/app_extension.dart';
import 'package:wallpapers/ui/helpers/navigation_utils.dart';
import 'package:wallpapers/ui/models/images_data_api.dart';
import 'package:wallpapers/ui/models/photos_data.dart';
import 'package:wallpapers/ui/views/components/skeleton.dart';
import 'package:wallpapers/ui/views/view_image_screen.dart';

class ImagesListScreen extends StatefulWidget {
  const ImagesListScreen({Key? key}) : super(key: key);

  @override
  State<ImagesListScreen> createState() => _ImagesListScreenState();
}

class _ImagesListScreenState extends State<ImagesListScreen> {
  ImagesListController imagesListController = Get.put(ImagesListController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.isLoadMore) {
        //if we are in the buttom of the page
        //Here get the data tha you wanna get it and set it in array and call
        imagesListController.mPage += 1;
        imagesListController.fetchImages();
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(imagesListController.categoryItem!.name),
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
      body: Obx(() => imagesListController.isDataLoading.value
          ? renderSkeletonView()
          : Container(
              color: Colors.white,
              padding: const EdgeInsets.all(12),
              child: StaggeredGridView.countBuilder(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 12,
                  controller: _scrollController,
                  itemCount: imagesListController.imagesDataApi!.photos!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => {
                        _navigateToViewImageScreen(
                            imagesListController.imagesDataApi!.photos![index])
                      },
                      child: Hero(
                        tag:
                            "${imagesListController.imagesDataApi!.photos![index].id}",
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.transparent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16)),
                            child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: imagesListController
                                  .imagesDataApi!.photos![index].src!.portrait!,
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                      ),
                    );
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

  _navigateToViewImageScreen(Photos photoItem) {
    var args = {
      'imageObject': PhotosData(
          id: photoItem.id.toString(), imageUrl: photoItem.src!.portrait!)
    };
    Go.to(() => const ViewImageScreen(), arguments: args);
  }
}
