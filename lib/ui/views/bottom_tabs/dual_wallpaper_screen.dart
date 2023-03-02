import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:wallpapers/ui/controller/dual_wallpaper_controller.dart';
import 'package:wallpapers/ui/controller/home_controller.dart';
import 'package:wallpapers/ui/helpers/app_extension.dart';
import 'package:wallpapers/ui/models/dual_wallpaper_data.dart';
import 'package:wallpapers/ui/views/components/skeleton.dart';
import 'package:wallpapers/ui/views/view_dual_wallpaper_screen.dart';

import '../../constant/api_constants.dart';
import '../../constant/constants.dart';
import '../../helpers/navigation_utils.dart';
import '../streak_premium.dart';
import '../view_image_screen.dart';

class DualWallpaperScreen extends StatefulWidget {
  const DualWallpaperScreen({Key? key}) : super(key: key);

  @override
  State<DualWallpaperScreen> createState() => _DualWallpaperScreenState();
}

class _DualWallpaperScreenState extends State<DualWallpaperScreen> {
  DualWallpaperController dualWallpaperController =
      Get.put(DualWallpaperController());
  HomeController homeController = Get.find<HomeController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.isLoadMore &&
          !dualWallpaperController.paginationEnded) {
        dualWallpaperController.mStart += ApiConstant.limit;
        dualWallpaperController.getAllDualWallpaper();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => dualWallpaperController.isDataLoading.value
        ? renderSkeletonView()
        : ListView.builder(
            controller: _scrollController,
            itemCount: dualWallpaperController.dualWallpaperList.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () async {
                  var item = dualWallpaperController.dualWallpaperList[index];
                  if (item.streakPoint != null && item.streakPoint! > 0) {
                    if (homeController.isLoggedIn.value) {
                      var checkAvail =
                          await homeController.checkAvailDualWallpaper(item);
                      if ((item.streakPoint! <=
                              homeController.userData.value!.streakPoint!) ||
                          checkAvail) {
                        if (checkAvail) {
                          _navigateToViewDualWallpaperScreen(item);
                        } else {
                          _showAvailDialog(item);
                        }
                      } else {
                        _showEarnStreaksDialog();
                      }
                      // if (item.streakPoint! <=
                      //     homeController.userData.value!.streakPoint!) {
                      //   _showAvailDialog(item);
                      // } else {
                      //   _showEarnStreaksDialog();
                      // }
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
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Stack(
                    children: [
                      Center(
                        child: Hero(
                          tag:
                              '${dualWallpaperController.dualWallpaperList[index].id}',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              renderDeviceFrame(
                                  dualWallpaperController
                                          .dualWallpaperList[index]
                                          .leftImage
                                          ?.fileUrl ??
                                      "",
                                  dualWallpaperController
                                          .dualWallpaperList[index]
                                          .leftImage
                                          ?.fileType ??
                                      "jpg",
                                  false),
                              renderDeviceFrame(
                                  dualWallpaperController
                                          .dualWallpaperList[index]
                                          .rightImage
                                          ?.fileUrl ??
                                      "",
                                  dualWallpaperController
                                          .dualWallpaperList[index]
                                          .rightImage
                                          ?.fileType ??
                                      "jpg",
                                  false),
                            ],
                          ),
                        ),
                      ),
                      (dualWallpaperController
                                      .dualWallpaperList[index].streakPoint ??
                                  0) >
                              0
                          ? Positioned(
                              top: 5,
                              right: 5,
                              child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 3, bottom: 3),
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
                                          "${dualWallpaperController.dualWallpaperList[index].streakPoint ?? 0}",
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
            }).fadeAnimation(0.5));
  }

  _navigateToViewDualWallpaperScreen(DualWallpaperData dualWallpaperData) {
    Go.to(() => ViewDualWallpaperScreen(dualWallpaperData: dualWallpaperData));
  }

  renderSkeletonView() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  renderDeviceFrame("", "jpg", true),
                  renderDeviceFrame("", "jpg", true),
                ],
              ),
            );
          }).fadeAnimation(0.5),
    );
  }

  _showAvailDialog(DualWallpaperData dualWallpaperData) {
    Dialogs.materialDialog(
        msg: '${Constants.streakIcon}${dualWallpaperData.streakPoint}',
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
            onPressed: () async {
              Get.back();
              // homeController.updateStreaks(-(dualWallpaperData.streakPoint!.toInt()));

              var availed =
                  await homeController.availDualWallpaper(dualWallpaperData);
              if (availed) {
                homeController.checkUserOnServer();
                _navigateToViewDualWallpaperScreen(dualWallpaperData);
              }
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
    // VideoPlayerController? controller;
    // if (fileType == "mp4" || fileType == "gif") {
    //   controller = VideoPlayerController.network(
    //       imageUrl.replaceAll(".gif", ".mp4"),
    //       videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true))
    //     ..initialize().then((_) {
    //       // Once the video has been loaded we play the video and set looping to true.
    //       // controller?.play();
    //       controller?.setLooping(true);
    //       // Ensure the first frame is shown after the video is initialized.
    //       // setState(() {});
    //     });
    // }

    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
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
                      CachedNetworkImage(
                        imageUrl: imageUrl.replaceAll(".mp4", ".gif"),
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                        repeat: ImageRepeat.repeat,
                        placeholder: (context, url) => const Center(
                            child:
                                CircularProgressIndicator(color: Colors.black)),
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
