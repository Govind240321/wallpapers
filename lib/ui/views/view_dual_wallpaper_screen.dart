import 'package:device_frame/device_frame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallpapers/ui/helpers/app_extension.dart';
import 'package:wallpapers/ui/models/dual_wallpaper_data.dart';
import 'package:wallpapers/ui/views/view_image_screen.dart';

class ViewDualWallpaperScreen extends StatefulWidget {
  final DualWallpaperData dualWallpaperData;

  const ViewDualWallpaperScreen({Key? key, required this.dualWallpaperData})
      : super(key: key);

  @override
  State<ViewDualWallpaperScreen> createState() =>
      _ViewDualWallpaperScreenState();
}

class _ViewDualWallpaperScreenState extends State<ViewDualWallpaperScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
                top: 10,
                left: 10,
                child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      CupertinoIcons.back,
                      color: Colors.black,
                    ))),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.only(bottom: 50),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 6,
                      blurRadius: 7,
                      offset:
                          const Offset(10, -5), // changes position of shadow
                    ),
                  ],
                ),
                height: MediaQuery.of(context).size.height * 0.5,
                child: Hero(
                  tag: '${widget.dualWallpaperData.id}',
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _renderActionButton(CupertinoIcons.share, () {}),
                      _renderActionButton(
                          CupertinoIcons.arrow_down_circle, () {}),
                      _renderActionButton(
                          CupertinoIcons.arrow_down_left_square, () {}),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 120,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  renderDeviceFrame(
                      widget.dualWallpaperData.leftImage?.imageUrl ?? ""),
                  renderDeviceFrame(
                      widget.dualWallpaperData.rightImage?.imageUrl ?? ""),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _renderActionButton(IconData iconData, void Function()? onPressed) {
    return Material(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child:
          IconButton(onPressed: onPressed, iconSize: 30, icon: Icon(iconData)),
    );
  }

  renderDeviceFrame(String imageUrl) {
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
            screen: Stack(
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
