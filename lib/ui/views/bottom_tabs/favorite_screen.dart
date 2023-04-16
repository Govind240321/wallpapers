import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallpapers/ui/helpers/app_extension.dart';
import 'package:wallpapers/ui/models/image_data.dart';

import '../../constant/ads_id_constant.dart';
import '../../constant/api_constants.dart';
import '../../controller/favorite_controller.dart';
import '../../controller/popular_controller.dart';
import '../../helpers/navigation_utils.dart';
import '../components/skeleton.dart';
import '../favorite_pager_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  FavoriteController favoriteController = Get.put(FavoriteController());
  final ScrollController _scrollController = ScrollController();
  static const AdRequest request = AdRequest(
    nonPersonalizedAds: true,
  );

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;
  final getStorage = GetStorage();

  @override
  void initState() {
    super.initState();
    _createInterstitialAd();

    favoriteController.mStart = 0;
    favoriteController.getAllFavoriteImages();

    _scrollController.addListener(() {
      if (_scrollController.isLoadMore && !favoriteController.paginationEnded) {
        favoriteController.mStart =
            favoriteController.imagesList.length + ApiConstant.limit;
        favoriteController.getAllFavoriteImages();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _interstitialAd?.dispose();
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

  void _showInterstitialAd(int imageIndex) {
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

        getStorage.write('clickCount', 0);
        _navigateToViewImageScreen(imageIndex);
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

  Widget _errorWidget() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      alignment: Alignment.center,
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/icon/icon.png",
            height: 50,
            width: 50,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Failed to load Image",
            style: GoogleFonts.anton(fontSize: 6, color: Colors.white),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Obx(() => favoriteController.isDataLoading.value
          ? renderSkeletonView()
          : favoriteController.imagesList.isNotEmpty
              ? StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  controller: _scrollController,
                  itemCount: favoriteController.imagesList.length,
                  itemBuilder: (context, index) {
                    var imageData = favoriteController.imagesList[index];

                    return GestureDetector(
                      onTap: () => {checkAdsCountAndNavigation(index)},
                      child: Hero(
                        tag: "${imageData.id}",
                        child: Stack(
                          children: [
                            AspectRatio(
                              aspectRatio: 9 / 16,
                              child: CachedNetworkImage(
                                  imageUrl: imageData.imageUrl!,
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
                                  favoriteController.removeFavorite(
                                      favoriteController.imagesList[index].id ??
                                          '');
                                  try {
                                    PopularController? popularController =
                                        Get.find<PopularController>();
                                    int imageIndex = popularController
                                        .imagesList
                                        .indexWhere((element) =>
                                            element.imageUrl ==
                                            favoriteController
                                                .imagesList[index].imageUrl);
                                    ImageData? findItem = popularController
                                        .imagesList[imageIndex];
                                    popularController.imagesList[imageIndex] =
                                        findItem.copyWith(isFavorite: false);
                                  } catch (e) {
                                    print(e);
                                  }
                                  favoriteController.imagesList.remove(
                                      favoriteController.imagesList[index]);

                                  var clickCount =
                                      getStorage.read("clickCount") ?? 0;
                                  if (clickCount == AdsConstant.CLICK_COUNT) {
                                    EasyAds.instance.showAd(AdUnitType.appOpen);
                                    EasyAds.instance.onEvent.listen((event) {
                                      if (event.adUnitType ==
                                              AdUnitType.appOpen &&
                                          event.type ==
                                              AdEventType.adDismissed) {
                                        getStorage.write('clickCount', 0);
                                      }
                                    });
                                  } else {
                                    getStorage.write(
                                        'clickCount', clickCount + 1);
                                  }
                                },
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(50))),
                                  child: const Align(
                                      alignment: Alignment.bottomRight,
                                      child: Icon(CupertinoIcons.heart_fill,
                                          color: Colors.white)),
                                ),
                              ),
                            )
                            // (imageData.streakPoint?.toInt() ?? 0) > 0
                            //     ? Positioned(
                            //         top: 5,
                            //         right: 5,
                            //         child: Container(
                            //             padding: const EdgeInsets.only(
                            //                 left: 10, right: 10, top: 3, bottom: 3),
                            //             decoration: const BoxDecoration(
                            //                 color: Colors.black,
                            //                 borderRadius:
                            //                     BorderRadius.all(Radius.circular(30))),
                            //             child: Row(
                            //               crossAxisAlignment: CrossAxisAlignment.center,
                            //               children: [
                            //                 DefaultTextStyle(
                            //                   style: GoogleFonts.sancreek(
                            //                       textStyle: const TextStyle(fontSize: 10)),
                            //                   child: const Text(Constants.streakIcon),
                            //                 ),
                            //                 Text("${imageData.streakPoint}",
                            //                     style: GoogleFonts.anton(
                            //                         textStyle: const TextStyle(
                            //                             fontSize: 10,
                            //                             color: Colors.white,
                            //                             fontWeight: FontWeight.w300)))
                            //               ],
                            //             )),
                            //       )
                            //     : Container()
                          ],
                ),
              ),
            );
          },
          staggeredTileBuilder: (index) {
            return const StaggeredTile.fit(1);
                  })
          : Container(
        padding: const EdgeInsets.all(50),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmptyWidget(
                image: null, packageImage: PackageImage.Image_2),
            const SizedBox(height: 30),
            Text("No any image added to favorites",
                style: GoogleFonts.anton(
                    textStyle: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w300)))
          ],
        ),
      )),
    ).fadeAnimation(0.6);
  }

  renderSkeletonView() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: StaggeredGridView.countBuilder(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 12,
          itemCount: 10,
          itemBuilder: (context, index) {
            return const Skeleton();
          },
          staggeredTileBuilder: (index) {
            return StaggeredTile.count(1, index.isEven ? 1.2 : 1.8);
          }),
    );
  }

  _navigateToViewImageScreen(int imageIndex) {
    Go.to(() => FavoriteImagePagerScreen(
        favoriteController: favoriteController, imageIndex: imageIndex));
  }

  checkAdsCountAndNavigation(int imageIndex) {
    var clickCount = getStorage.read("clickCount") ?? 0;
    if (clickCount < AdsConstant.CLICK_COUNT) {
      getStorage.write('clickCount', clickCount + 1);
      _navigateToViewImageScreen(imageIndex);
    } else {
      _showInterstitialAd(imageIndex);
    }
  }
}
