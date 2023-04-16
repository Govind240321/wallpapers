import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wallpapers/ui/controller/profile_controller.dart';
import 'package:wallpapers/ui/helpers/app_extension.dart';
import 'package:wallpapers/ui/helpers/navigation_utils.dart';
import 'package:wallpapers/ui/models/image_data.dart';
import 'package:wallpapers/ui/views/components/skeleton.dart';
import 'package:wallpapers/ui/views/view_image_screen.dart';

import '../../../constant/api_constants.dart';

class MyImagesScreen extends StatefulWidget {
  const MyImagesScreen({Key? key}) : super(key: key);

  @override
  State<MyImagesScreen> createState() => _MyImagesScreenState();
}

class _MyImagesScreenState extends State<MyImagesScreen> {
  ProfileController profileController = Get.find<ProfileController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    profileController.mStart = 0;
    profileController.getUserImages();

    _scrollController.addListener(() {
      if (_scrollController.isLoadMore && !profileController.paginationEnded) {
        profileController.mStart += ApiConstant.limit;
        profileController.getUserImages();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(() => profileController.isDataLoading.value
            ? renderSkeletonView()
            : Container(
                color: Colors.white,
                padding: const EdgeInsets.all(12),
                child: profileController.myImagesList.isNotEmpty
                    ? StaggeredGridView.countBuilder(
                    crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 12,
                        controller: _scrollController,
                        itemCount: profileController.myImagesList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => {
                              _navigateToViewImageScreen(
                                  profileController.myImagesList[index])
                            },
                            child: Hero(
                              tag: profileController.myImagesList[index].id!,
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(16)),
                                      child: FadeInImage.memoryNetwork(
                                        placeholder: kTransparentImage,
                                        image: profileController
                                            .myImagesList[index].imageUrl!,
                                        fit: BoxFit.cover,
                                        height: double.infinity,
                                        width: double.infinity,
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  ),
                                  // Positioned(
                                  //   top: 5,
                                  //   right: 5,
                                  //   child: Container(
                                  //       width: 35,
                                  //       padding: const EdgeInsets.only(
                                  //           top: 3, bottom: 3),
                                  //       decoration: const BoxDecoration(
                                  //           color: Colors.black,
                                  //           borderRadius: BorderRadius.all(
                                  //               Radius.circular(30))),
                                  //       child: Row(
                                  //         mainAxisAlignment:
                                  //             MainAxisAlignment.center,
                                  //         crossAxisAlignment:
                                  //             CrossAxisAlignment.center,
                                  //         children: [
                                  //           Text(Constants.streakIcon,
                                  //               style: GoogleFonts.sancreek(
                                  //                   textStyle: const TextStyle(
                                  //                       fontSize: 12))),
                                  //           Text(
                                  //               "${profileController.myImagesList[index].streakPoint}",
                                  //               style: GoogleFonts.anton(
                                  //                   textStyle: const TextStyle(
                                  //                       fontSize: 10,
                                  //                       color: Colors.white,
                                  //                       fontWeight:
                                  //                           FontWeight.w300)))
                                  //         ],
                                  //       )),
                                  // )
                                ],
                              ),
                            ),
                          );
                        },
                        staggeredTileBuilder: (index) {
                          return const StaggeredTile.count(1, 1.8);
                        })
                    : Container(
                        padding: const EdgeInsets.all(50),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            EmptyWidget(
                                image: null,
                                packageImage: PackageImage.Image_2),
                            const SizedBox(height: 30),
                            Text("No any image added",
                                style: GoogleFonts.anton(
                                    textStyle: const TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w300)))
                          ],
                        ),
                      ),
              )),
        // Positioned(
        //   bottom: 20,
        //   right: 20,
        //   child: Container(
        //     decoration: const BoxDecoration(
        //         color: Colors.teal,
        //         borderRadius: BorderRadius.all(Radius.circular(15))),
        //     child: IconButton(
        //       icon: const Icon(
        //         CupertinoIcons.plus,
        //         color: Colors.white,
        //       ),
        //       onPressed: () {
        //         Go.to(const UploadImageScreen());
        //       },
        //     ),
        //   ),
        // )
      ],
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

  _navigateToViewImageScreen(ImageData photoItem) {
    var args = {'imageObject': photoItem};
    Go.to(() => const ViewImageScreen(), arguments: args);
  }
}
