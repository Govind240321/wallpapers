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
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wallpapers/ui/models/image_data.dart';
import 'package:wallpapers/ui/views/rating_screen.dart';

import '../constant/ads_id_constant.dart';
import '../constant/api_constants.dart';
import '../controller/images_list_controller.dart';
import '../controller/popular_controller.dart';
import '../helpers/navigation_utils.dart';

class ImagePagerScreen extends StatefulWidget {
  final ImagesController? imagesController;
  final PopularController? popularController;
  final int imageIndex;
  final bool
  isFromPopular; // 0 for ImageListScreen, 1 for Popular, 2 for Favorites

  const ImagePagerScreen({Key? key,
    this.imagesController,
    required this.imageIndex,
    required this.isFromPopular,
    this.popularController})
      : super(key: key);

  @override
  State<ImagePagerScreen> createState() => _ImagePagerScreenState();
}

class _ImagePagerScreenState extends State<ImagePagerScreen> {
  late ImageData currentImageData;
  bool permissionGranted = false;
  final getStorage = GetStorage();

  @override
  void initState() {
    super.initState();
    currentImageData = (widget.isFromPopular
        ? widget.popularController?.imagesList[widget.imageIndex]
        : widget.imagesController?.imagesList[widget.imageIndex])!;
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
              openReviewScreen();
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

  openReviewScreen() {
    int optionClick = getStorage.read("optionClick") ?? 0;
    if (optionClick != 0 && optionClick % 5 == 0) {
      Go.to(const RatingScreen());
    }
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
                    openReviewScreen();
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
                  openReviewScreen();
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
                  openReviewScreen();
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

                  openReviewScreen();
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
              int optionClick = getStorage.read("optionClick") ?? 0;
              if (optionClick != 0 && optionClick % 3 == 0) {
                EasyAds.instance.showAd(AdUnitType.appOpen);
              } else {
                setWallpaperClicked(context);
              }
              getStorage.write("optionClick", optionClick + 1);
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
                widget.isFromPopular
                    ? widget.popularController?.imagesList.length ?? 0
                    : widget.imagesController?.imagesList.length ?? 0,
                    (index) {
                  String heroId = widget.isFromPopular
                      ? widget.popularController?.imagesList[index].id ?? ''
                      : widget.imagesController?.imagesList[index].id ?? '';

                  return Stack(
                    children: [
                      Hero(
                        tag: heroId,
                        child: CachedNetworkImage(
                            imageUrl: widget.isFromPopular
                                ? widget.popularController?.imagesList[index]
                                        .imageUrl ??
                                    ""
                                : widget.imagesController?.imagesList[index]
                                        .imageUrl ??
                                    "",
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
                            var isFav = widget.isFromPopular
                                ? (widget.popularController?.imagesList[index]
                                        .isFavorite ??
                                    false)
                                : (widget.imagesController?.imagesList[index]
                                        .isFavorite ??
                                    false);

                            if (isFav) {
                              if (widget.isFromPopular) {
                                widget.popularController?.removeFavorite(widget
                                        .popularController
                                        ?.imagesList[index]
                                        .id ??
                                    '');
                              } else {
                                widget.imagesController?.removeFavorite(widget
                                        .imagesController
                                        ?.imagesList[index]
                                        .id ??
                                    '');
                              }
                            } else {
                              if (widget.isFromPopular) {
                                widget.popularController?.addToFavorite(widget
                                        .popularController
                                        ?.imagesList[index]
                                        .id ??
                                    '');
                              } else {
                                widget.imagesController?.addToFavorite(widget
                                        .imagesController
                                        ?.imagesList[index]
                                        .id ??
                                    '');
                              }
                            }

                            if (widget.isFromPopular) {
                              var tempObject = widget
                                  .popularController?.imagesList[index]
                                  .copyWith(isFavorite: !isFav);
                              if (tempObject != null) {
                                widget.popularController?.imagesList[index] =
                                    tempObject;
                              }
                            } else {
                              var tempObject = widget
                                  .imagesController?.imagesList[index]
                                  .copyWith(isFavorite: !isFav);
                              if (tempObject != null) {
                                widget.imagesController?.imagesList[index] =
                                    tempObject;
                              }
                            }

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
                            child: Align(
                                alignment: Alignment.bottomRight,
                                child: Icon(
                                    (widget.isFromPopular
                                            ? (widget
                                                    .popularController
                                                    ?.imagesList[index]
                                                    .isFavorite ??
                                                false)
                                            : (widget
                                                    .imagesController
                                                    ?.imagesList[index]
                                                    .isFavorite ??
                                                false))
                                        ? CupertinoIcons.heart_fill
                                        : CupertinoIcons.heart,
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
                currentImageData = (widget.isFromPopular
                    ? widget.popularController?.imagesList[index]
                    : widget.imagesController?.imagesList[index])!;

                final getStorage = GetStorage();
                var clickCount = getStorage.read("clickCount") ?? 0;
                if (clickCount == AdsConstant.CLICK_COUNT) {
                  EasyAds.instance.showAd(AdUnitType.interstitial);
                  getStorage.write('clickCount', 0);
                } else {
                  getStorage.write('clickCount', clickCount + 1);
                }

                if (widget.isFromPopular) {
                  if (index >=
                      ((widget.popularController?.imagesList.length ?? 0) -
                          3)) {
                    if (widget.popularController?.paginationEnded ==
                        false) {
                      widget.popularController?.mStart =
                          widget.popularController?.imagesList.length ??
                              0 + ApiConstant.limit;
                      widget.popularController?.getAllImages();
                    }
                  }
                } else {
                  if (index >=
                      ((widget.imagesController?.imagesList.length ?? 0) -
                          3)) {
                    if (widget.imagesController?.paginationEnded == false) {
                      widget.imagesController?.mStart =
                          widget.imagesController?.imagesList.length ??
                              0 + ApiConstant.limit;
                      widget.imagesController?.getAllImagesByCategoryId();
                    }
                  }
                }
              },
              scrollDirection: Axis.horizontal,
            )),
      ),
    ));
  }
}
