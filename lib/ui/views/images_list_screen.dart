import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wallpapers/ui/helpers/app_extension.dart';
import 'package:wallpapers/ui/views/components/image_rail_item.dart';

import '../constant/ads_id_constant.dart';
import '../constant/api_constants.dart';
import '../controller/home_controller.dart';
import '../controller/images_list_controller.dart';
import 'components/skeleton.dart';

class ImagesListScreen extends StatefulWidget {
  const ImagesListScreen({Key? key}) : super(key: key);

  @override
  State<ImagesListScreen> createState() => _ImagesListScreenState();
}

class _ImagesListScreenState extends State<ImagesListScreen> {
  ImagesController imagesController = Get.put(ImagesController());
  HomeController homeController = Get.find<HomeController>();
  final ScrollController _scrollController = ScrollController();

  final getStorage = GetStorage();

  static const AdRequest request = AdRequest(
    nonPersonalizedAds: true,
  );

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;

  // AppOpenAd? myAppOpenAd;

  @override
  void initState() {
    super.initState();
    _createInterstitialAd();
    _scrollController.addListener(() {
      if (_scrollController.isLoadMore && !imagesController.paginationEnded) {
        imagesController.mStart += ApiConstant.limit;
        imagesController.getAllImagesByCategoryId();
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

  void _showInterstitialAd() {
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

  // loadAppOpenAd() {
  //   AppOpenAd.load(
  //       adUnitId: AdsConstant.OPEN_APP_ID,
  //       //Your ad Id from admob
  //       request: const AdRequest(),
  //       adLoadCallback: AppOpenAdLoadCallback(
  //           onAdLoaded: (ad) {
  //             myAppOpenAd = ad;
  //             myAppOpenAd!.show();
  //
  //             getStorage.write('clickCount', 0);
  //           },
  //           onAdFailedToLoad: (error) {}),
  //       orientation: AppOpenAd.orientationPortrait);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(imagesController.categoryItem!.name!),
        titleTextStyle: GoogleFonts.openSans(
            textStyle: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () {
            Get.back();
          },
          iconSize: 24,
        ),
        iconTheme: const IconThemeData.fallback(),
      ),
      body: Obx(() => imagesController.isDataLoading.value
          ? renderSkeletonView()
          : Container(
              color: Colors.white,
              padding: const EdgeInsets.all(12),
              child: StaggeredGridView.countBuilder(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 12,
                  controller: _scrollController,
                  itemCount: imagesController.imagesList.length,
                  itemBuilder: (context, index) {
                    return ImageRailItem(
                        imageData: imagesController.imagesList[index],
                        isCategoryImageList: true,
                        callback: () {
                          var clickCount = getStorage.read("clickCount") ?? 0;
                          if (clickCount == AdsConstant.CLICK_COUNT) {
                            _showInterstitialAd();
                          }
                        },
                        getStorage: getStorage);
                  },
                  staggeredTileBuilder: (index) {
                    return StaggeredTile.count(1, index.isEven ? 1.2 : 1.8);
                  }),
            ).fadeAnimation(0.6)),
    );
  }

  renderSkeletonView() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: StaggeredGridView.countBuilder(
          crossAxisCount: 2,
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
}
