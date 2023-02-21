import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:wallpapers/ui/controller/home_controller.dart';
import 'package:wallpapers/ui/models/image_data.dart';

import '../../constant/constants.dart';
import '../../helpers/navigation_utils.dart';
import '../streak_premium.dart';
import '../view_image_screen.dart';

class ImageRailItem extends StatelessWidget {
  final ImageData imageData;
  final bool isCategoryImageList;
  HomeController homeController = Get.find<HomeController>();

  ImageRailItem(
      {Key? key, required this.imageData, this.isCategoryImageList = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (imageData.streakPoint != null && imageData.streakPoint! > 0) {
          if (homeController.isLoggedIn.value) {
            if (imageData.streakPoint! <=
                homeController.userData.value!.streaksPoint!) {
              _showAvailDialog(imageData, context);
            } else {
              _showEarnStreaksDialog(context);
            }
          } else {
            _showLoggedInDialog(context);
          }
        } else {
          _navigateToViewImageScreen(imageData);
        }
      },
      child: Hero(
        tag: "${imageData.id}",
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: imageData.imageUrl!,
                  placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(color: Colors.black)),
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                ),
              ),
            ),
            (imageData.streakPoint?.toInt() ?? 0) > 0
                ? Positioned(
              top: 5,
              right: 5,
              child: Container(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 3, bottom: 3),
                  decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius:
                      BorderRadius.all(Radius.circular(30))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DefaultTextStyle(
                        style: GoogleFonts.sancreek(
                            textStyle: const TextStyle(fontSize: 10)),
                        child: const Text(Constants.streakIcon),
                      ),
                      Text("${imageData.streakPoint}",
                                style: GoogleFonts.anton(
                                    textStyle: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300)))
                          ],
                  )),
            )
                : Container()
          ],
        ),
      ),
    );
  }

  _navigateToViewImageScreen(ImageData photoItem) {
    var args = {'imageObject': photoItem};
    Go.to(() => const ViewImageScreen(), arguments: args);
  }

  _showAvailDialog(ImageData photosData, BuildContext context) {
    Dialogs.materialDialog(
        msg: '${Constants.streakIcon}${photosData.streakPoint}',
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
              homeController.updateStreaks(-(photosData.streakPoint!.toInt()));
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

  _showLoggedInDialog(BuildContext context) {
    Dialogs.materialDialog(
        msg: 'Please login first to avail this.',
        title: "Login to Avail",
        color: Colors.white,
        context: context,
        msgStyle: GoogleFonts.openSansCondensed(
            fontSize: 20, fontWeight: FontWeight.bold),
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
              homeController.goToLogin(false);
              homeController.goToLogin(true);
              if (isCategoryImageList) {
                Get.back();
              }
            },
            text: 'Login Page',
            iconData: Icons.done,
            color: Colors.green,
            textStyle: const TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
  }

  _showEarnStreaksDialog(BuildContext context) {
    Dialogs.materialDialog(
        msg: 'Watch Ads and Earn \n upto 25 Streaks per Ad',
        title: "Insufficient Streaks${Constants.streakIcon}",
        color: Colors.white,
        context: context,
        msgStyle: GoogleFonts.openSansCondensed(
            fontSize: 16, fontWeight: FontWeight.bold),
        msgAlign: TextAlign.center,
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
            iconData: Icons.remove_red_eye,
            color: Colors.green,
            textStyle: const TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
  }
}
