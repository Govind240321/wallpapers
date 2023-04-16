import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wallpapers/ui/controller/home_controller.dart';
import 'package:wallpapers/ui/controller/images_list_controller.dart';
import 'package:wallpapers/ui/controller/popular_controller.dart';
import 'package:wallpapers/ui/models/image_data.dart';

import '../../constant/ads_id_constant.dart';
import '../../helpers/navigation_utils.dart';
import '../image_pager_screen.dart';

class ImageRailItem extends StatelessWidget {
  final ImageData imageData;
  final bool isCategoryImageList;
  final bool isFromPopular;
  final VoidCallback callback;
  final void Function(ImageData) favClickCallback;
  final GetStorage getStorage;
  final ImagesController? imagesController;
  final PopularController? popularController;
  final int imageIndex;
  HomeController homeController = Get.find<HomeController>();

  ImageRailItem(
      {Key? key,
      required this.imageData,
      this.isCategoryImageList = false,
      required this.callback,
      required this.getStorage,
      this.imagesController,
      required this.imageIndex,
      this.popularController,
      required this.isFromPopular,
      required this.favClickCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // if (imageData.streakPoint != null && imageData.streakPoint! > 0) {
        //   if (homeController.isLoggedIn.value) {
        //     var checkAvail = await homeController.checkAvailImage(imageData);
        //     if ((imageData.streakPoint! <=
        //             homeController.userData.value!.streakPoint!) ||
        //         checkAvail) {
        //       if (checkAvail) {
        //         _navigateToViewImageScreen();
        //       } else {
        //         _showAvailDialog(imageData, context);
        //       }
        //     } else {
        //       _showEarnStreaksDialog(context);
        //     }
        //   } else {
        //     _showLoggedInDialog(context);
        //   }
        // } else {
        //   callback();
        //   var clickCount = getStorage.read("clickCount") ?? 0;
        //   if (clickCount < AdsConstant.CLICK_COUNT) {
        //     getStorage.write('clickCount', clickCount + 1);
        //     _navigateToViewImageScreen();
        //   }
        // }
        callback();
        var clickCount = getStorage.read("clickCount") ?? 0;
        if (clickCount < AdsConstant.CLICK_COUNT) {
          getStorage.write('clickCount', clickCount + 1);
          _navigateToViewImageScreen();
        }
      },
      child: Hero(
        tag: "${imageData.id}",
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 9 / 16,
              child: CachedNetworkImage(
                  imageUrl: imageData.imageUrl!,
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(color: Colors.black))),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  favClickCallback.call(imageData);
                },
                child: Container(
                  height: 50,
                  width: 50,
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(50))),
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(
                          (imageData.isFavorite ?? false)
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          color: Colors.white)),
                ),
              ),
            )
            // (imageData.streakPoint?.toInt() ?? 0) > 0
            //     ? Positioned(
            //         top: 5,
            //         right: 5,
            //         child: Container(
            //             padding: const EdgeInsets.only(
            //                 left: 10, right: 10, top: 3, bottom: 3),
            //             decoration: const BoxDecoration(
            //                 color: Colors.black,
            //                 borderRadius:
            //                     BorderRadius.all(Radius.circular(30))),
            //             child: Row(
            //               crossAxisAlignment: CrossAxisAlignment.center,
            //               children: [
            //                 DefaultTextStyle(
            //                   style: GoogleFonts.sancreek(
            //                       textStyle: const TextStyle(fontSize: 10)),
            //                   child: const Text(Constants.streakIcon),
            //                 ),
            //                 Text("${imageData.streakPoint}",
            //                     style: GoogleFonts.anton(
            //                         textStyle: const TextStyle(
            //                             fontSize: 10,
            //                             color: Colors.white,
            //                             fontWeight: FontWeight.w300)))
            //               ],
            //             )),
            //       )
            //     : Container()
          ],
        ),
      ),
    );
  }

  _navigateToViewImageScreen() {
    // var args = {'imageObject': photoItem};
    // Go.to(() => const ViewImageScreen(), arguments: args);
    Go.to(() => ImagePagerScreen(
          imagesController: imagesController,
          popularController: popularController,
          imageIndex: imageIndex,
          isFromPopular: isFromPopular,
        ));
  }

// _showAvailDialog(ImageData photosData, BuildContext context) {
//   Dialogs.materialDialog(
//       msg: '${Constants.streakIcon}${photosData.streakPoint}',
//       title: "Confirm to Avail",
//       color: Colors.white,
//       context: context,
//       msgStyle: GoogleFonts.openSansCondensed(
//           fontSize: 24, fontWeight: FontWeight.bold),
//       actions: [
//         IconsOutlineButton(
//           onPressed: () {
//             Get.back();
//           },
//           text: 'Cancel',
//           iconData: Icons.cancel_rounded,
//           textStyle: const TextStyle(color: Colors.grey),
//           iconColor: Colors.grey,
//         ),
//         IconsButton(
//           onPressed: () async {
//             Get.back();
//             var availed = await homeController.availImage(imageData);
//             if (availed) {
//               homeController.checkUserOnServer();
//               _navigateToViewImageScreen();
//             }
//           },
//           text: 'Confirm',
//           iconData: Icons.done,
//           color: Colors.green,
//           textStyle: const TextStyle(color: Colors.white),
//           iconColor: Colors.white,
//         ),
//       ]);
// }
//
// _showLoggedInDialog(BuildContext context) {
//   Dialogs.materialDialog(
//       msg: 'Please login first to avail this.',
//       title: "Login to Avail",
//       color: Colors.white,
//       context: context,
//       msgStyle: GoogleFonts.openSansCondensed(
//           fontSize: 20, fontWeight: FontWeight.bold),
//       actions: [
//         IconsOutlineButton(
//           onPressed: () {
//             Get.back();
//           },
//           text: 'Cancel',
//           iconData: Icons.cancel_rounded,
//           textStyle: const TextStyle(color: Colors.grey),
//           iconColor: Colors.grey,
//         ),
//         IconsButton(
//           onPressed: () {
//             Get.back();
//             homeController.goToLogin(false);
//             homeController.goToLogin(true);
//             if (isCategoryImageList) {
//               Get.back();
//             }
//           },
//           text: 'Login Page',
//           iconData: Icons.done,
//           color: Colors.green,
//           textStyle: const TextStyle(color: Colors.white),
//           iconColor: Colors.white,
//         ),
//       ]);
// }
//
// _showEarnStreaksDialog(BuildContext context) {
//   Dialogs.materialDialog(
//       msg: 'Watch Ads and Earn \n upto 25 Streaks per Ad',
//       title: "Insufficient Streaks${Constants.streakIcon}",
//       color: Colors.white,
//       context: context,
//       msgStyle: GoogleFonts.openSansCondensed(
//           fontSize: 16, fontWeight: FontWeight.bold),
//       msgAlign: TextAlign.center,
//       actions: [
//         IconsOutlineButton(
//           onPressed: () {
//             Get.back();
//           },
//           text: 'Cancel',
//           iconData: Icons.cancel_rounded,
//           textStyle: const TextStyle(color: Colors.grey),
//           iconColor: Colors.grey,
//         ),
//         IconsButton(
//           onPressed: () {
//             Get.back();
//             Go.to(const StreakPremiumScreen());
//           },
//           text: 'Watch & Earn',
//           iconData: Icons.remove_red_eye,
//           color: Colors.green,
//           textStyle: const TextStyle(color: Colors.white),
//           iconColor: Colors.white,
//         ),
//       ]);
// }
}
