import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wallpapers/ui/constant/constants.dart';
import 'package:wallpapers/ui/controller/home_controller.dart';
import 'package:wallpapers/ui/controller/popular_controller.dart';
import 'package:wallpapers/ui/helpers/app_extension.dart';
import 'package:wallpapers/ui/helpers/navigation_utils.dart';
import 'package:wallpapers/ui/models/photos_data.dart';
import 'package:wallpapers/ui/views/components/skeleton.dart';
import 'package:wallpapers/ui/views/streak_premium.dart';
import 'package:wallpapers/ui/views/view_image_screen.dart';

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
      // if (_scrollController.isLoadMore) {
      //   popularController.mPage += 1;
      //   popularController.fetchImages();
      //   setState(() {});
      // }
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
                    return GestureDetector(
                      onTap: () {
                        var item = popularController.imagesList[index];
                        if (item.points != null && item.points! > 0) {
                          if (item.points! <=
                              homeController.userData.value!.streaksPoint!) {
                            _showAvailDialog(item);
                          } else {
                            _showEarnStreaksDialog();
                          }
                        } else {
                          _navigateToViewImageScreen(item);
                        }
                      },
                      child: Hero(
                        tag: "${popularController.imagesList[index].id}",
                        child: Stack(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(16)),
                                child: FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image: popularController
                                      .imagesList[index].imageUrl!,
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),
                            popularController.imagesList[index].premium == true
                                ? Positioned(
                                    top: 5,
                                    right: 5,
                                    child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 3,
                                            bottom: 3),
                                        decoration: const BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30))),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(Constants.streakIcon,
                                                style: GoogleFonts.sancreek(
                                                    textStyle: const TextStyle(
                                                        fontSize: 12))),
                                            Text(
                                                "${popularController.imagesList[index].points}",
                                                style: GoogleFonts.anton(
                                                    textStyle: const TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w300)))
                                          ],
                                        )),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    );
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

  _navigateToViewImageScreen(PhotosData photoItem) {
    var args = {'imageObject': photoItem};
    Go.to(() => const ViewImageScreen(), arguments: args);
  }

  _showAvailDialog(PhotosData photosData) {
    Dialogs.materialDialog(
        msg: '${Constants.streakIcon}${photosData.points}',
        title: "Confirm to Avail",
        color: Colors.white,
        context: context,
        msgStyle: GoogleFonts.openSansCondensed(
            fontSize: 24, fontWeight: FontWeight.bold),
        actions: [
          IconsOutlineButton(
            onPressed: () {
              Get.back();
            },
            text: 'Cancel',
            iconData: Icons.cancel_rounded,
            textStyle: const TextStyle(color: Colors.grey),
            iconColor: Colors.grey,
          ),
          IconsButton(
            onPressed: () {
              Get.back();
              homeController.updateStreaks(-(photosData.points!.toInt()));
              _navigateToViewImageScreen(photosData);
            },
            text: 'Confirm',
            iconData: Icons.done,
            color: Colors.green,
            textStyle: const TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
  }

  _showEarnStreaksDialog() {
    Dialogs.materialDialog(
        msg: 'Watch Ads and Earn \n upto 25 Streaks per Ad',
        title: "Insufficient Streaks${Constants.streakIcon}",
        color: Colors.white,
        context: context,
        msgStyle: GoogleFonts.openSansCondensed(
            fontSize: 16, fontWeight: FontWeight.bold),
        actions: [
          IconsOutlineButton(
            onPressed: () {
              Get.back();
            },
            text: 'Cancel',
            iconData: Icons.cancel_rounded,
            textStyle: const TextStyle(color: Colors.grey),
            iconColor: Colors.grey,
          ),
          IconsButton(
            onPressed: () {
              Get.back();
              Go.to(const StreakPremiumScreen());
            },
            text: 'Watch & Earn',
            iconData: Icons.done,
            color: Colors.green,
            textStyle: const TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
  }
}
