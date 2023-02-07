import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallpapers/ui/controller/dual_wallpaper_controller.dart';
import 'package:wallpapers/ui/helpers/app_extension.dart';
import 'package:wallpapers/ui/views/components/skeleton.dart';

import '../view_image_screen.dart';

class DualWallpaperScreen extends StatefulWidget {
  const DualWallpaperScreen({Key? key}) : super(key: key);

  @override
  State<DualWallpaperScreen> createState() => _DualWallpaperScreenState();
}

class _DualWallpaperScreenState extends State<DualWallpaperScreen> {
  DualWallpaperController dualWallpaperController =
      Get.put(DualWallpaperController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => dualWallpaperController.isDataLoading.value
        ? renderSkeletonView()
        : ListView.builder(
            itemCount: dualWallpaperController.dualWallpaperList.length,
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
                    renderDeviceFrame(
                        dualWallpaperController
                                .dualWallpaperList[index].leftImage?.imageUrl ??
                            "",
                        false),
                    renderDeviceFrame(
                        dualWallpaperController.dualWallpaperList[index]
                                .rightImage?.imageUrl ??
                            "",
                        false),
                  ],
                ),
              );
            }).fadeAnimation(0.5));
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
                  renderDeviceFrame("", true),
                  renderDeviceFrame("", true),
                ],
              ),
            );
          }).fadeAnimation(0.5),
    );
  }

  renderDeviceFrame(String imageUrl, bool skeleton) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
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
                      Image.network(
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
