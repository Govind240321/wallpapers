import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wallpapers/ui/controller/profile_controller.dart';
import 'package:wallpapers/ui/helpers/navigation_utils.dart';
import 'package:wallpapers/ui/models/photos_data.dart';
import 'package:wallpapers/ui/views/components/skeleton.dart';
import 'package:wallpapers/ui/views/upload_image_screen.dart';
import 'package:wallpapers/ui/views/view_image_screen.dart';

class MyImagesScreen extends StatefulWidget {
  const MyImagesScreen({Key? key}) : super(key: key);

  @override
  State<MyImagesScreen> createState() => _MyImagesScreenState();
}

class _MyImagesScreenState extends State<MyImagesScreen> {
  ProfileController profileController = Get.find<ProfileController>();

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
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 12,
                        itemCount: profileController.myImagesList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => {
                              _navigateToViewImageScreen(
                                  profileController.myImagesList[index])
                            },
                            child: Hero(
                              tag: profileController.myImagesList[index].id!,
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
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
                            ),
                          );
                        },
                        staggeredTileBuilder: (index) {
                          return StaggeredTile.count(
                              1, index.isEven ? 1.2 : 1.8);
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
        Positioned(
          bottom: 20,
          right: 20,
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: IconButton(
              icon: const Icon(
                CupertinoIcons.plus,
                color: Colors.white,
              ),
              onPressed: () {
                Go.to(const UploadImageScreen());
              },
            ),
          ),
        )
      ],
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

  _navigateToViewImageScreen(PhotosData photoItem) {
    var args = {'imageObject': photoItem};
    Go.to(() => const ViewImageScreen(), arguments: args);
  }
}
