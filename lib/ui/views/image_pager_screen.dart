import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:wallpapers/ui/models/image_data.dart';

import '../constant/ads_id_constant.dart';
import '../constant/api_constants.dart';
import '../controller/images_list_controller.dart';
import '../controller/popular_controller.dart';

class ImagePagerScreen extends StatefulWidget {
  final ImagesController? imagesController;
  final PopularController? popularController;
  final int imageIndex;
  final bool
      isFromPopular; // 0 for ImageListScreen, 1 for Popular, 2 for Favorites

  const ImagePagerScreen(
      {Key? key,
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

  @override
  void initState() {
    super.initState();
    currentImageData = (widget.isFromPopular
        ? widget.popularController?.imagesList[widget.imageIndex]
        : widget.imagesController?.imagesList[widget.imageIndex])!;
  }

  setWallpaperClicked() {
    Dialogs.bottomMaterialDialog(
        customView: ListView(
          primary: true,
          shrinkWrap: true,
          children: [
            InkWell(
                onTap: () async {
                  Get.back();
                  var file = await DefaultCacheManager()
                      .getSingleFile(currentImageData.imageUrl ?? '');
                  AsyncWallpaper.setWallpaperFromFile(
                      toastDetails:
                          ToastDetails(message: "Wallpaper set successfully!"),
                      wallpaperLocation: AsyncWallpaper.HOME_SCREEN,
                      filePath: file.path);
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
          ],
        ),
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: Colors.black,
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              setWallpaperClicked();
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

                  return Hero(
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
