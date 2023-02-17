import 'dart:io';

import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:device_frame/device_frame.dart';
import 'package:flowder/flowder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:wallpapers/ui/constant/constants.dart';
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
  late DownloaderUtils options;
  late DownloaderCore core;
  late final String path;
  late final String tempPath;
  bool permissionGranted = false;
  late ProgressDialog pr;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    _setPath();
    _setTempPath();
    if (!mounted) return;
  }

  void _setPath() async {
    path = Directory('/storage/emulated/0/Download').path;
  }

  void _setTempPath() async {
    tempPath = (await getExternalStorageDirectory())!.path;
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context,
        type: ProgressDialogType.normal, isDismissible: false, showLogs: false);
    pr.style(
        message: 'Downloading file...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: const CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut);

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
                      _renderActionButton(CupertinoIcons.arrow_down_left_square,
                          () {
                        Dialogs.bottomMaterialDialog(
                            customView: ListView(
                              primary: true,
                              shrinkWrap: true,
                              children: [
                                InkWell(
                                    onTap: () {
                                      Get.back();
                                      _getStoragePermission().then((value) {
                                        if (permissionGranted) {
                                          _setGifAsWallpaper(true);
                                        } else {
                                          _getStoragePermission();
                                        }
                                      });
                                    },
                                    child: const ListTile(
                                        title: Text("Set as Home screen"))),
                                InkWell(
                                    onTap: () {},
                                    child: const ListTile(
                                        title: Text("Set as Lock screen"))),
                                InkWell(
                                    onTap: () {},
                                    child: const ListTile(
                                        title: Text("Set as Both"))),
                              ],
                            ),
                            context: context);
                      }),
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

  _setGifAsWallpaper(bool isLeft) async {
    await pr.show();
    options = DownloaderUtils(
      progressCallback: (current, total) {
        final progress = (current / total) * 100;
        // pr.update(
        //   progress: progress.roundToDouble(),
        //   message: "Please wait...",
        //   progressWidget: Container(
        //       padding: const EdgeInsets.all(8.0),
        //       child: const CircularProgressIndicator()),
        //   maxProgress: 100.0,
        //   progressTextStyle: const TextStyle(
        //       color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        //   messageTextStyle: const TextStyle(
        //       color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
        // );
        print("Progress =======>>>>>> $progress");
        if (progress == 100) {
          AsyncWallpaper.setLiveWallpaper(
              filePath:
                  '$tempPath/${Constants.appName}${widget.dualWallpaperData.id}.mp4');
        }
      },
      file: File(
          '$tempPath/${Constants.appName}${widget.dualWallpaperData.id}.mp4'),
      progress: ProgressImplementation(),
      onDone: () async => {await pr.hide()},
      deleteOnCancel: true,
    );
    core = await Flowder.download(
        isLeft
            ? widget.dualWallpaperData.leftImage?.imageUrl ?? ""
            : widget.dualWallpaperData.rightImage?.imageUrl ?? "",
        options);
  }

  Future _getStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      setState(() {
        permissionGranted = true;
      });
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      setState(() {
        permissionGranted = false;
      });
    }
  }

  _showWallpaperSetDialog() {
    Dialogs.materialDialog(
        color: Colors.white,
        msg: 'Wallpaper set successfully!',
        title: 'Hurray!',
        lottieBuilder: Lottie.asset(
          'assets/congratulations.json',
          fit: BoxFit.contain,
        ),
        titleStyle: GoogleFonts.openSansCondensed(
            fontWeight: FontWeight.bold, fontSize: 36),
        context: context,
        barrierDismissible: false,
        actions: [
          IconsButton(
            onPressed: () {
              Get.back();
            },
            text: 'Dismiss',
            iconData: Icons.done,
            color: Colors.blue,
            textStyle: const TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
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
