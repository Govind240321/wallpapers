import 'dart:io';

import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:device_frame/device_frame.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flowder/flowder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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

import '../constant/ads_id_constant.dart';

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

  static const AdRequest request = AdRequest(
    nonPersonalizedAds: true,
  );

  int maxFailedLoadAttempts = 3;

  RewardedInterstitialAd? _rewardedInterstitialAd;
  int _numRewardedInterstitialLoadAttempts = 0;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _createRewardedInterstitialAd();
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
  void dispose() {
    super.dispose();
    _rewardedInterstitialAd?.dispose();
  }

  void _createRewardedInterstitialAd() {
    RewardedInterstitialAd.load(
        adUnitId: AdsConstant.REWARED_INTERSTITIAL_ID,
        request: request,
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (RewardedInterstitialAd ad) {
            print('$ad loaded.');
            _rewardedInterstitialAd = ad;
            _numRewardedInterstitialLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedInterstitialAd failed to load: $error');
            _rewardedInterstitialAd = null;
            _numRewardedInterstitialLoadAttempts += 1;
            if (_numRewardedInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createRewardedInterstitialAd();
            }
          },
        ));
  }

  void _showRewardedInterstitialAd(int isFrom, bool isLeft) {
    if (_rewardedInterstitialAd == null) {
      print('Warning: attempt to show rewarded interstitial before loaded.');
      return;
    }
    _rewardedInterstitialAd!.fullScreenContentCallback =
        FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedInterstitialAd ad) =>
          print('$ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createRewardedInterstitialAd();
      },
      onAdFailedToShowFullScreenContent:
          (RewardedInterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createRewardedInterstitialAd();
      },
    );

    _rewardedInterstitialAd!.setImmersiveMode(true);
    _rewardedInterstitialAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      if (isFrom == 0) {
        shareButtonClicked(isLeft);
      } else if (isFrom == 1) {
        downloadButtonClicked(isLeft);
      } else {
        if (isLeft) {
          setLeftDualWallpaper();
        } else {
          setRightDualWallpaper();
        }
      }
    });
    _rewardedInterstitialAd = null;
  }

  Future<void> downloadButtonClicked(bool isLeft) async {
    await pr.show();
    options = DownloaderUtils(
      progressCallback: (current, total) {
        final progress = (current / total) * 100;
      },
      file: File(
          '$path/${Constants.appName}${isLeft ? widget.dualWallpaperData.leftImage?.id : widget.dualWallpaperData.rightImage?.id}.${widget.dualWallpaperData.leftImage?.fileType == "mp4" ? "mp4" : "png"}'),
      progress: ProgressImplementation(),
      onDone: () async {
        await pr.hide();
        Dialogs.materialDialog(
            color: Colors.white,
            msg: 'File saved to this directory: $path',
            title: 'File Saved!',
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
      },
      deleteOnCancel: true,
    );
    core = await Flowder.download(
        isLeft
            ? widget.dualWallpaperData.leftImage?.fileUrl
                    ?.replaceAll(".gif", ".mp4") ??
                ""
            : widget.dualWallpaperData.rightImage?.fileUrl
                    ?.replaceAll(".gif", ".mp4") ??
                "",
        options);
  }

  Future<void> shareButtonClicked(bool isLeft) async {
    await pr.show();
    options = DownloaderUtils(
      progressCallback: (current, total) async {
        final progress = (current / total) * 100;
      },
      file: File(
          '$tempPath/${Constants.appName}${isLeft ? widget.dualWallpaperData.leftImage?.id : widget.dualWallpaperData.rightImage?.id}.${widget.dualWallpaperData.leftImage?.fileType == "mp4" ? "mp4" : "png"}'),
      progress: ProgressImplementation(),
      onDone: () async {
        await pr.hide();
        await FlutterShare.shareFile(
            title: Constants.appName,
            text:
                "Make your phone beautiful with our latest selective wallpapers.\n Click here to get app: https://play.google.com/store/apps/details?id=com.app.wallpaper",
            filePath:
                '$tempPath/${Constants.appName}${isLeft ? widget.dualWallpaperData.leftImage?.id : widget.dualWallpaperData.rightImage?.id}.${widget.dualWallpaperData.leftImage?.fileType == "mp4" ? "mp4" : "png"}');
      },
      deleteOnCancel: true,
    );
    core = await Flowder.download(
        isLeft
            ? widget.dualWallpaperData.leftImage?.fileUrl
                    ?.replaceAll(".gif", ".mp4") ??
                ""
            : widget.dualWallpaperData.rightImage?.fileUrl
                    ?.replaceAll(".gif", ".mp4") ??
                "",
        options);
  }

  setLeftDualWallpaper() {
    if ((widget.dualWallpaperData.leftImage?.fileType ?? "jpg") == "mp4" ||
        (widget.dualWallpaperData.leftImage?.fileType ?? "jpg") == "gif") {
      _setGifOrVideoAsWallpaper(true);
    } else {
      AsyncWallpaper.setWallpaperNative(
          url: widget.dualWallpaperData.leftImage?.fileUrl ?? "");
      _showWallpaperSetDialog();
    }
  }

  setRightDualWallpaper() {
    if ((widget.dualWallpaperData.rightImage?.fileType ?? "jpg") == "mp4" ||
        (widget.dualWallpaperData.rightImage?.fileType ?? "jpg") == "gif") {
      _setGifOrVideoAsWallpaper(false);
    } else {
      AsyncWallpaper.setWallpaperNative(
          url: widget.dualWallpaperData.rightImage?.fileUrl ?? "");
      _showWallpaperSetDialog();
    }
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
                      _renderActionButton(CupertinoIcons.share, () {
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
                                          if (widget.dualWallpaperData
                                                  .streakPoint! >
                                              0) {
                                            shareButtonClicked(true);
                                          } else {
                                            _showRewardedInterstitialAd(
                                                0, true);
                                          }
                                        } else {
                                          _getStoragePermission();
                                        }
                                      });
                                    },
                                    child: const ListTile(
                                        title: Text("Share Left Wallpaper"))),
                                InkWell(
                                    onTap: () {
                                      Get.back();
                                      _getStoragePermission().then((value) {
                                        if (permissionGranted) {
                                          if (widget.dualWallpaperData
                                                  .streakPoint! >
                                              0) {
                                            shareButtonClicked(false);
                                          } else {
                                            _showRewardedInterstitialAd(
                                                0, false);
                                          }
                                        } else {
                                          _getStoragePermission();
                                        }
                                      });
                                    },
                                    child: const ListTile(
                                        title: Text("Share Right Wallpaper")))
                              ],
                            ),
                            context: context);
                      }),
                      _renderActionButton(CupertinoIcons.arrow_down_circle, () {
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
                                          if (widget.dualWallpaperData
                                                  .streakPoint! >
                                              0) {
                                            downloadButtonClicked(true);
                                          } else {
                                            _showRewardedInterstitialAd(
                                                1, true);
                                          }
                                        } else {
                                          _getStoragePermission();
                                        }
                                      });
                                    },
                                    child: const ListTile(
                                        title:
                                            Text("Download Left Wallpaper"))),
                                InkWell(
                                    onTap: () {
                                      Get.back();
                                      _getStoragePermission().then((value) {
                                        if (permissionGranted) {
                                          if (widget.dualWallpaperData
                                                  .streakPoint! >
                                              0) {
                                            downloadButtonClicked(false);
                                          } else {
                                            _showRewardedInterstitialAd(
                                                1, false);
                                          }
                                        } else {
                                          _getStoragePermission();
                                        }
                                      });
                                    },
                                    child: const ListTile(
                                        title:
                                            Text("Download Right Wallpaper")))
                              ],
                            ),
                            context: context);
                      }),
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
                                          if (widget.dualWallpaperData
                                                  .streakPoint! >
                                              0) {
                                            setLeftDualWallpaper();
                                          } else {
                                            _showRewardedInterstitialAd(
                                                2, true);
                                          }
                                        } else {
                                          _getStoragePermission();
                                        }
                                      });
                                    },
                                    child: const ListTile(
                                        title: Text("Set Left as Wallpaper"))),
                                InkWell(
                                    onTap: () {
                                      Get.back();
                                      _getStoragePermission().then((value) {
                                        if (permissionGranted) {
                                          if (widget.dualWallpaperData
                                                  .streakPoint! >
                                              0) {
                                            setRightDualWallpaper();
                                          } else {
                                            _showRewardedInterstitialAd(
                                                2, false);
                                          }
                                        } else {
                                          _getStoragePermission();
                                        }
                                      });
                                    },
                                    child: const ListTile(
                                        title: Text("Set Right as Wallpaper")))
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
                      widget.dualWallpaperData.leftImage?.fileUrl ?? "",
                      widget.dualWallpaperData.leftImage?.fileType ?? "jpg"),
                  renderDeviceFrame(
                      widget.dualWallpaperData.rightImage?.fileUrl ?? "",
                      widget.dualWallpaperData.rightImage?.fileType ?? "jpg"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _setGifOrVideoAsWallpaper(bool isLeft) async {
    await pr.show();
    options = DownloaderUtils(
      progressCallback: (current, total) {
        final progress = (current / total) * 100;
        if (progress == 100) {
          AsyncWallpaper.setLiveWallpaper(
              filePath:
                  '$tempPath/${Constants.appName}${isLeft ? widget.dualWallpaperData.leftImage?.id : widget.dualWallpaperData.rightImage?.id}.mp4');
        }
      },
      file: File(
          '$tempPath/${Constants.appName}${isLeft ? widget.dualWallpaperData.leftImage?.id : widget.dualWallpaperData.rightImage?.id}.mp4'),
      progress: ProgressImplementation(),
      onDone: () async => {await pr.hide()},
      deleteOnCancel: true,
    );
    core = await Flowder.download(
        isLeft
            ? widget.dualWallpaperData.leftImage?.fileUrl
                    ?.replaceAll(".gif", ".mp4") ??
                ""
            : widget.dualWallpaperData.rightImage?.fileUrl
                    ?.replaceAll(".gif", ".mp4") ??
                "",
        options);
  }

  Future _getStoragePermission() async {
    bool storage = true;
    bool videos = true;
    bool photos = true;

    // Only check for storage < Android 13
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (androidInfo.version.sdkInt >= 33) {
      videos = await Permission.videos.request().isGranted;
      photos = await Permission.photos.request().isGranted;
    } else {
      storage = await Permission.storage.request().isGranted;
    }

    if (storage && photos && videos) {
      setState(() {
        permissionGranted = true;
      });
    } else if (!storage || !photos || !videos) {
      setState(() {
        permissionGranted = false;
      });
      await openAppSettings();
    } else if (!storage || !photos || !videos) {
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

  renderDeviceFrame(String imageUrl, String fileType) {
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
                  imageUrl.replaceAll(".mp4", ".gif"),
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
