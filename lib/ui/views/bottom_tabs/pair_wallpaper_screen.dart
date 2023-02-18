import 'package:carousel_slider/carousel_slider.dart';
import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wallpapers/ui/controller/dual_wallpaper_controller.dart';
import 'package:wallpapers/ui/helpers/app_extension.dart';

import '../../constant/constants.dart';
import '../../controller/home_controller.dart';
import '../../helpers/navigation_utils.dart';
import '../../models/dual_wallpaper_data.dart';
import '../components/skeleton.dart';
import '../streak_premium.dart';
import '../view_dual_wallpaper_screen.dart';
import '../view_image_screen.dart';

class PairWallpaperScreen extends StatefulWidget {
  const PairWallpaperScreen({Key? key}) : super(key: key);

  @override
  State<PairWallpaperScreen> createState() => _PairWallpaperScreenState();
}

class _PairWallpaperScreenState extends State<PairWallpaperScreen> {
  DualWallpaperController dualWallpaperController =
      Get.put(DualWallpaperController());
  HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Obx(() => dualWallpaperController.isDataLoading.value
            ? renderSkeletonView()
            : CarouselSlider(
                options: CarouselOptions(
                  autoPlay: false,
                  enlargeCenterPage: true,
                  viewportFraction: 0.8,
                  aspectRatio: 1,
                  initialPage: 0,
                ),
                items: dualWallpaperController.dualWallpaperList.map((item) {
                  return Builder(
                    builder: (BuildContext context) {
                      return InkWell(
                        onTap: () {
                          if (item.points != null && item.points! > 0) {
                            if (homeController.isLoggedIn.value) {
                              if (item.points! <=
                                  homeController
                                      .userData.value!.streaksPoint!) {
                                _showAvailDialog(item);
                              } else {
                                _showEarnStreaksDialog();
                              }
                            } else {
                              _showLoggedInDialog();
                            }
                          } else {
                            _navigateToViewDualWallpaperScreen(item);
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: Stack(
                            children: [
                              Center(
                                child: Hero(
                                  tag: '${item.id}',
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      renderDeviceFrame(
                                          item.leftImage?.imageUrl ?? "",
                                          item.leftImage?.fileType ?? "jpg",
                                          false),
                                      renderDeviceFrame(
                                          item.rightImage?.imageUrl ?? "",
                                          item.rightImage?.fileType ?? "jpg",
                                          false),
                                    ],
                                  ),
                                ),
                              ),
                              (item.points ?? 0) > 0
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
                                                      textStyle:
                                                          const TextStyle(
                                                              fontSize: 12))),
                                              Text("${item.points ?? 0}",
                                                  style: GoogleFonts.anton(
                                                      textStyle:
                                                          const TextStyle(
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300)))
                                            ],
                                          )),
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ).fadeAnimation(0.5)));
  }

  renderSkeletonView() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 0.7,
          aspectRatio: 3,
          initialPage: 0,
        ),
        items: [
          0,
          1,
          2,
          3,
          4,
          5,
        ].map((item) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Stack(
                  children: [
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          renderDeviceFrame("", "jpg", true),
                          renderDeviceFrame("", "jpg", true),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        }).toList(),
      ).fadeAnimation(0.5),
    );
  }

  _showAvailDialog(DualWallpaperData dualWallpaperData) {
    Dialogs.materialDialog(
        msg: '${Constants.streakIcon}${dualWallpaperData.points}',
        title: "Confirm to Avail",
        color: Colors.white,
        context: context,
        msgStyle: GoogleFonts.openSansCondensed(
            fontSize: 24, fontWeight: FontWeight.bold),
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
              homeController
                  .updateStreaks(-(dualWallpaperData.points!.toInt()));
              _navigateToViewDualWallpaperScreen(dualWallpaperData);
            },
            text: 'Confirm',
            iconData: Icons.done,
            color: Colors.green,
            textStyle: const TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
  }

  _showLoggedInDialog() {
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
            },
            text: 'Login Page',
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

  renderDeviceFrame(String imageUrl, String fileType, bool skeleton) {
    VideoPlayerController? controller;
    if (fileType == "mp4" || fileType == "gif") {
      controller = VideoPlayerController.network(
          imageUrl.replaceAll(".gif", ".mp4"),
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true))
        ..initialize().then((_) {
          // Once the video has been loaded we play the video and set looping to true.
          // controller?.play();
          controller?.setLooping(true);
          // Ensure the first frame is shown after the video is initialized.
          // setState(() {});
        });
    }

    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.35,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 6,
                blurRadius: 7,
                offset: const Offset(5, 5), // changes position of shadow
              ),
            ],
          ),
          child: DeviceFrame(
            device: Devices.ios.iPhone13,
            isFrameVisible: true,
            orientation: Orientation.portrait,
            screen: skeleton
                ? const Skeleton()
                : Stack(
                    children: [
                      fileType == "mp4" || fileType == "gif"
                          ? VisibilityDetector(
                              key: Key(imageUrl),
                              onVisibilityChanged: (visibilityInfo) {
                                var visiblePercentage =
                                    visibilityInfo.visibleFraction * 100;
                                debugPrint(
                                    'Widget ${visibilityInfo.key} is ${visiblePercentage}% visible');
                                if (visiblePercentage < 100) {
                                  if (visiblePercentage == 0) {
                                    controller?.dispose();
                                    controller = null;
                                  } else {
                                    if (controller != null) {
                                      controller?.pause();
                                    } else {
                                      controller =
                                          VideoPlayerController.network(
                                              imageUrl.replaceAll(
                                                  ".gif", ".mp4"),
                                              videoPlayerOptions:
                                                  VideoPlayerOptions(
                                                      mixWithOthers: true))
                                            ..initialize().then((_) {
                                              // Once the video has been loaded we play the video and set looping to true.
                                              controller?.play();
                                              controller?.setLooping(true);
                                              // Ensure the first frame is shown after the video is initialized.
                                              setState(() {});
                                            });
                                    }
                                  }
                                } else {
                                  if (controller == null) {
                                    controller = VideoPlayerController.network(
                                        imageUrl.replaceAll(".gif", ".mp4"),
                                        videoPlayerOptions: VideoPlayerOptions(
                                            mixWithOthers: true))
                                      ..initialize().then((_) {
                                        // Once the video has been loaded we play the video and set looping to true.
                                        controller?.play();
                                        controller?.setLooping(true);
                                        // Ensure the first frame is shown after the video is initialized.
                                        setState(() {});
                                      });
                                  } else {
                                    controller?.play();
                                  }
                                }
                              },
                              child: VideoPlayer(controller!),
                            )
                          : Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                              alignment: Alignment.center,
                            ),
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      _lockScreenTimeWidget(context).fadeAnimation(0.5)
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  _navigateToViewDualWallpaperScreen(DualWallpaperData dualWallpaperData) {
    Go.to(() => ViewDualWallpaperScreen(dualWallpaperData: dualWallpaperData));
  }

  Widget _lockScreenTimeWidget(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(height: (MediaQuery.of(context).size.height * 0.12)),
          Text("Kolkata, India | IST",
              style: Theme.of(context).textTheme.bodyText1),
          const TimeInHourAndMinute()
        ],
      ),
    );
  }
}
