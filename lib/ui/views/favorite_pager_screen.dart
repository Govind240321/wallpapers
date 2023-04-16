import 'dart:io';

import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_downloader/image_downloader.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../constant/ads_id_constant.dart';
import '../controller/favorite_controller.dart';
import '../controller/popular_controller.dart';
import '../models/image_data.dart';

class FavoriteImagePagerScreen extends StatefulWidget {
  final FavoriteController? favoriteController;
  final int imageIndex;

  const FavoriteImagePagerScreen(
      {Key? key, this.favoriteController, required this.imageIndex})
      : super(key: key);

  @override
  State<FavoriteImagePagerScreen> createState() =>
      _FavoriteImagePagerScreenState();
}

class _FavoriteImagePagerScreenState extends State<FavoriteImagePagerScreen> {
  late ImageData currentImageData;
  bool permissionGranted = false;
  final getStorage = GetStorage();

  @override
  void initState() {
    super.initState();
    currentImageData =
        (widget.favoriteController?.imagesList[widget.imageIndex])!;
  }

  showAppReviewDialog() async {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("Rate it now"),
      onPressed: () {
        Get.back();
        getStorage.write("appVisit", 0);
        final InAppReview inAppReview = InAppReview.instance;
        inAppReview.openStoreListing();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Rating"),
      content: const Text(
          "If you enjoying our app, would you mind taking a moment to rate it? It won't take more than a minute. Thanks for your support!"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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

  downloadSuccessDialog(BuildContext context, String path) {
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
            color: Colors.black,
            textStyle: const TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
  }

  Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      directory = Directory('/storage/emulated/0/Download');
      // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
      // ignore: avoid_slow_async_io
      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
      }
    } catch (err, stack) {
      print("Cannot get download folder path");
    }
    return directory?.path;
  }

  setWallpaperClicked(BuildContext context) {
    Dialogs.bottomMaterialDialog(
        customView: ListView(
          primary: true,
          shrinkWrap: true,
          children: [
            InkWell(
                onTap: () async {
                  Get.back();
                  try {
                    var file = await DefaultCacheManager()
                        .getSingleFile(currentImageData.imageUrl ?? '');
                    AsyncWallpaper.setWallpaperFromFile(
                        toastDetails: ToastDetails(
                            message: "Wallpaper set successfully!"),
                        wallpaperLocation: AsyncWallpaper.HOME_SCREEN,
                        filePath: file.path);
                  } catch (e) {
                    print(e);
                  }
                },
                child: const ListTile(title: Text("Set as Home screen"))),
            InkWell(
                onTap: () async {
                  Get.back();
                  var file = await DefaultCacheManager()
                      .getSingleFile(currentImageData.imageUrl ?? '');
                  AsyncWallpaper.setWallpaperFromFile(
                      toastDetails:
                          ToastDetails(message: "Wallpaper set successfully!"),
                      wallpaperLocation: AsyncWallpaper.LOCK_SCREEN,
                      filePath: file.path);
                },
                child: const ListTile(title: Text("Set as Lock screen"))),
            InkWell(
                onTap: () async {
                  Get.back();
                  var file = await DefaultCacheManager()
                      .getSingleFile(currentImageData.imageUrl ?? '');
                  AsyncWallpaper.setWallpaperFromFile(
                      toastDetails:
                          ToastDetails(message: "Wallpaper set successfully!"),
                      wallpaperLocation: AsyncWallpaper.BOTH_SCREENS,
                      filePath: file.path);
                },
                child: const ListTile(title: Text("Set as Both"))),
            InkWell(
                onTap: () async {
                  Get.back();
                  // Only check for storage < Android 13
                  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
                  if (androidInfo.version.sdkInt >= 33) {
                    _getStoragePermission().then((value) async {
                      if (permissionGranted) {
                        http.Response response = await http
                            .get(Uri.parse(currentImageData.imageUrl ?? ''));
                        final directory = await getDownloadPath();
                        final path = directory ?? "";
                        final file = File('$path/${currentImageData.id}.png');
                        await file.writeAsBytes(response.bodyBytes);
                        // ignore: use_build_context_synchronously
                        downloadSuccessDialog(context, path);
                      } else {
                        _getStoragePermission();
                      }
                    });
                  } else {
                    var imageId = await ImageDownloader.downloadImage(
                        currentImageData.imageUrl ?? '',
                        destination: AndroidDestinationType.directoryDownloads);
                    var path = await ImageDownloader.findPath(imageId ?? '');
                    if (path != null) {
                      // ignore: use_build_context_synchronously
                      downloadSuccessDialog(context, path);
                    }
                  }
                },
                child: const ListTile(title: Text("Save to files"))),
            InkWell(
                onTap: () async {
                  Get.back();
                  var file = await DefaultCacheManager()
                      .getSingleFile(currentImageData.imageUrl ?? '');
                  await Share.shareXFiles([XFile(file.path)],
                      subject: "Sloopy HD Images",
                      text:
                          "Make your screen beautiful with our latest HD Images.\n Click here to get app: https://play.google.com/store/apps/details?id=com.sloopy.wallpaper");
                },
                child: const ListTile(title: Text("Share"))),
          ],
        ),
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: Colors.black,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            onPressed: () async {
              setWallpaperClicked(context);
            },
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(50)),
              child: const Center(
                  child: Icon(CupertinoIcons.arrow_down_left_square)),
            ),
          ),
          body: Center(
            child: CarouselSlider(
                items: List.generate(
                    widget.favoriteController?.imagesList.length ?? 0, (index) {
                  var item = widget.favoriteController?.imagesList[index];

                  return Stack(
                    children: [
                      Hero(
                        tag: item?.id ?? '',
                        child: CachedNetworkImage(
                            imageUrl: item?.imageUrl ?? '',
                            height: double.infinity,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                                    color: Colors.black))),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            widget.favoriteController?.removeFavorite(widget
                                    .favoriteController?.imagesList[index].id ??
                                '');
                            try {
                              PopularController? popularController =
                                  Get.find<PopularController>();
                              int imageIndex = popularController.imagesList
                                  .indexWhere((element) =>
                                      element.imageUrl ==
                                      widget.favoriteController
                                          ?.imagesList[index].imageUrl);
                              ImageData? findItem =
                                  popularController.imagesList[imageIndex];
                              popularController.imagesList[imageIndex] =
                                  findItem.copyWith(isFavorite: false);
                            } catch (e) {
                              print(e);
                            }
                            widget.favoriteController?.imagesList.remove(
                                widget.favoriteController?.imagesList[index]);

                            var clickCount = getStorage.read("clickCount") ?? 0;
                            if (clickCount == AdsConstant.CLICK_COUNT) {
                              EasyAds.instance.showAd(AdUnitType.appOpen);
                              EasyAds.instance.onEvent.listen((event) {
                                if (event.adUnitType == AdUnitType.appOpen &&
                                    event.type == AdEventType.adDismissed) {
                                  getStorage.write('clickCount', 0);
                                }
                              });
                            } else {
                              getStorage.write('clickCount', clickCount + 1);
                            }
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(50))),
                            child: const Align(
                                alignment: Alignment.bottomRight,
                                child: Icon(CupertinoIcons.heart_fill,
                                    color: Colors.black)),
                          ),
                        ),
                      )
                    ],
                  );
                }),
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * 0.7,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.7,
                  initialPage: widget.imageIndex,
                  enableInfiniteScroll: false,
                  reverse: false,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.3,
                  onPageChanged: (index, pageChangedReason) {
                    currentImageData =
                        (widget.favoriteController?.imagesList[index])!;

                    final getStorage = GetStorage();
                    var clickCount = getStorage.read("clickCount") ?? 0;
                    if (clickCount == AdsConstant.CLICK_COUNT) {
                      EasyAds.instance.showAd(AdUnitType.interstitial);
                      getStorage.write('clickCount', 0);
                    } else {
                      getStorage.write('clickCount', clickCount + 1);
                    }
                  },
                  scrollDirection: Axis.horizontal,
                )),
          ),
        ));
  }
}
