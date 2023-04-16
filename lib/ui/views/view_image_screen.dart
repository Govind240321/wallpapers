import 'dart:async';
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
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:wallpapers/ui/constant/constants.dart';
import 'package:wallpapers/ui/controller/home_controller.dart';
import 'package:wallpapers/ui/controller/view_image_controller.dart';
import 'package:wallpapers/ui/helpers/app_extension.dart';

import '../constant/ads_id_constant.dart';

class ViewImageScreen extends StatefulWidget {
  const ViewImageScreen({Key? key}) : super(key: key);

  @override
  State<ViewImageScreen> createState() => _ViewImageScreenState();
}

class _ViewImageScreenState extends State<ViewImageScreen> {
  ViewImageController viewImageController = Get.put(ViewImageController());
  HomeController homeController = Get.find<HomeController>();
  late DownloaderUtils options;
  late DownloaderCore core;
  late final String path;
  late final String tempPath;
  bool permissionGranted = false;
  ProgressDialog? pr;

  static const AdRequest request = AdRequest(
    nonPersonalizedAds: true,
  );

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;
  AppOpenAd? myAppOpenAd;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _createInterstitialAd();
  }

  Future<void> initPlatformState() async {
    _setPath();
    _setTempPath();
    if (!mounted) return;
  }

  @override
  void dispose() {
    super.dispose();
    _interstitialAd?.dispose();
  }

  void _setPath() async {
    path = Directory('/storage/emulated/0/Download').path;
  }

  void _setTempPath() async {
    tempPath = (await getExternalStorageDirectory())!.path;
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdsConstant.INTERSTITIAL_ID,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd(int isFrom) {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();

        if (isFrom == 0) {
          shareButtonClicked();
        } else if (isFrom == 1) {
          downloadButtonClicked();
        } else {
          setWallpaperClicked();
        }
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  loadAppOpenAd(int isFrom) {
    AppOpenAd.load(
        adUnitId: AdsConstant.OPEN_APP_ID,
        //Your ad Id from admob
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
            onAdLoaded: (ad) {
              myAppOpenAd = ad;
              myAppOpenAd!.show();

              if (isFrom == 0) {
                shareButtonClicked();
              } else if (isFrom == 1) {
                downloadButtonClicked();
              } else {
                setWallpaperClicked();
              }
            },
            onAdFailedToLoad: (error) {}),
        orientation: AppOpenAd.orientationPortrait);
  }

  Future<void> downloadButtonClicked() async {
    await pr?.show();
    options = DownloaderUtils(
      progressCallback: (current, total) {
        final progress = (current / total) * 100;
      },
      file: File('$path/${DateTime.now().millisecondsSinceEpoch}.png'),
      progress: ProgressImplementation(),
      onDone: () async {
        await pr?.hide();

        // ignore: use_build_context_synchronously
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
        viewImageController.imageObject?.imageUrl ?? "", options);
  }

  Future<void> shareButtonClicked() async {
    await pr?.show();
    options = DownloaderUtils(
      progressCallback: (current, total) async {
        final progress = (current / total) * 100;
        PackageInfo packageInfo = await PackageInfo.fromPlatform();

        if (progress == 100) {
          await FlutterShare.shareFile(
              title: Constants.appName,
              text:
                  "Make your phone beautiful with our latest selective wallpapers.\n Click here to get app: https://play.google.com/store/apps/details?id=${packageInfo.packageName}",
              filePath:
                  '$tempPath/${Constants.appName}${viewImageController.imageObject?.id ?? ""}.png');
        }
      },
      file: File(
          '$tempPath/${Constants.appName}${viewImageController.imageObject?.id ?? ""}.png'),
      progress: ProgressImplementation(),
      onDone: () async => {await pr?.hide()},
      deleteOnCancel: true,
    );
    core = await Flowder.download(
        viewImageController.imageObject?.imageUrl ?? "", options);
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

  setWallpaperClicked() {
    Dialogs.bottomMaterialDialog(
        customView: ListView(
          primary: true,
          shrinkWrap: true,
          children: [
            InkWell(
                onTap: () {
                  Get.back();
                  AsyncWallpaper.setWallpaper(
                      url: viewImageController.imageObject?.imageUrl ?? "",
                      wallpaperLocation: AsyncWallpaper.HOME_SCREEN);
                  _showWallpaperSetDialog();
                },
                child: const ListTile(title: Text("Set as Home screen"))),
            InkWell(
                onTap: () {
                  Get.back();
                  AsyncWallpaper.setWallpaper(
                      url: viewImageController.imageObject?.imageUrl ?? "",
                      wallpaperLocation: AsyncWallpaper.LOCK_SCREEN);
                  _showWallpaperSetDialog();
                },
                child: const ListTile(title: Text("Set as Lock screen"))),
            InkWell(
                onTap: () {
                  Get.back();
                  AsyncWallpaper.setWallpaper(
                      url: viewImageController.imageObject?.imageUrl ?? "",
                      wallpaperLocation: AsyncWallpaper.BOTH_SCREENS);
                  _showWallpaperSetDialog();
                },
                child: const ListTile(title: Text("Set as Both"))),
          ],
        ),
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context,
        type: ProgressDialogType.download,
        isDismissible: false,
        showLogs: false);
    pr?.style(
        message: 'Downloading file...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: const CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0);

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
            Obx(() => homeController.isLoggedIn.value
                ? Positioned(
                    top: 10,
                    right: 10,
                    child: Hero(
                      tag: "favIcon${viewImageController.imageObject?.id}",
                      child: Material(
                        color: Colors.white,
                        clipBehavior: Clip.antiAlias,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: IconButton(
                            onPressed: () {
                              if (viewImageController.isFavorite.value) {
                                viewImageController.removeFromFavorite();
                              } else {
                                viewImageController.addToFavorite();
                              }
                              viewImageController.isFavorite(
                                  !viewImageController.isFavorite.value);
                            },
                            icon: Icon(
                              viewImageController.isFavorite.value
                                  ? CupertinoIcons.heart_fill
                                  : CupertinoIcons.heart,
                              color: viewImageController.isFavorite.value
                                  ? Colors.red
                                  : Colors.black,
                            )),
                      ),
                    ))
                : Container()),
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _renderActionButton(CupertinoIcons.share, () {
                      _getStoragePermission().then((value) {
                        if (permissionGranted) {
                          // if (viewImageController.imageObject!.streakPoint! >
                          //     0) {
                          //   shareButtonClicked();
                          // } else {
                          //   _showInterstitialAd(0);
                          // }
                        } else {
                          _getStoragePermission();
                        }
                      });
                    }),
                    _renderActionButton(CupertinoIcons.arrow_down_circle, () {
                      _getStoragePermission().then((value) {
                        if (permissionGranted) {
                          // if (viewImageController.imageObject!.streakPoint! >
                          //     0) {
                          //   downloadButtonClicked();
                          // } else {
                          //   loadAppOpenAd(1);
                          // }
                        } else {
                          _getStoragePermission();
                        }
                      });
                    }),
                    _renderActionButton(CupertinoIcons.arrow_down_left_square,
                        () {
                      // if (viewImageController.imageObject!.streakPoint! > 0) {
                      //   setWallpaperClicked();
                      // } else {
                      //   loadAppOpenAd(2);
                      // }
                    }),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 6,
                          blurRadius: 7,
                          offset:
                              const Offset(5, 5), // changes position of shadow
                        ),
                      ],
                    ),
                    child: DeviceFrame(
                      device: Platform.isAndroid
                          ? Devices.android.onePlus8Pro
                          : Devices.ios.iPhone13,
                      isFrameVisible: true,
                      orientation: Orientation.portrait,
                      screen: Hero(
                        tag: viewImageController.imageObject!.id!,
                        child: Stack(
                          children: [
                            Image.network(
                              viewImageController.imageObject!.imageUrl!,
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
                  ),
                ],
              ),
            )
          ],
        ),
      ),
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

  _showWatchAdDialog(int isFrom) {
    Dialogs.materialDialog(
        color: Colors.white,
        msg: 'Watch an Ad and avail for free',
        title: 'Watch Ad',
        titleStyle: GoogleFonts.openSansCondensed(
            fontWeight: FontWeight.bold, fontSize: 20),
        context: context,
        actions: [
          IconsButton(
            onPressed: () {
              Get.back();
              loadAppOpenAd(isFrom);
            },
            text: 'Watch Ad',
            iconData: Icons.remove_red_eye,
            color: Colors.blue,
            textStyle: const TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
  }
}

Widget _renderActionButton(IconData iconData, void Function()? onPressed) {
  return Material(
    color: Colors.white,
    clipBehavior: Clip.antiAlias,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))),
    child: IconButton(onPressed: onPressed, iconSize: 30, icon: Icon(iconData)),
  );
}

class TimeInHourAndMinute extends StatefulWidget {
  const TimeInHourAndMinute({Key? key}) : super(key: key);

  @override
  State<TimeInHourAndMinute> createState() => _TimeInHourAndMinuteState();
}

class _TimeInHourAndMinuteState extends State<TimeInHourAndMinute> {
  TimeOfDay _timeOfDay = TimeOfDay.now();
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeOfDay.minute != TimeOfDay.now().minute) {
        setState(() {
          _timeOfDay = TimeOfDay.now();
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    String period = _timeOfDay.period == DayPeriod.am ? "AM" : "PM";
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("${_retrieveHour()}:${_retrieveMinutes()}",
            style: Theme.of(context).textTheme.headline2),
        const SizedBox(width: 5),
        RotatedBox(
            quarterTurns: 3,
            child: Opacity(
              opacity: 0.7,
              child: Text(
                period,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ))
      ],
    );
  }

  String _retrieveMinutes() {
    var minutes = "${_timeOfDay.minute}";
    if (_timeOfDay.minute < 10) {
      minutes = "0$minutes";
    }
    return minutes;
  }

  String _retrieveHour() {
    var hour = "${_timeOfDay.hourOfPeriod}";
    if (_timeOfDay.hourOfPeriod < 10) {
      hour = "0$hour";
    }
    return hour;
  }
}
