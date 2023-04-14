import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wallpapers/ui/helpers/app_extension.dart';
import 'package:wallpapers/ui/views/components/image_rail_item.dart';

import '../constant/ads_id_constant.dart';
import '../constant/api_constants.dart';
import '../controller/home_controller.dart';
import '../controller/images_list_controller.dart';
import '../models/category_data.dart';
import 'components/skeleton.dart';

class ImagesListScreen extends StatefulWidget {
  final CategoryData categoryItem;

  const ImagesListScreen({Key? key, required this.categoryItem})
      : super(key: key);

  @override
  State<ImagesListScreen> createState() => _ImagesListScreenState();
}

class _ImagesListScreenState extends State<ImagesListScreen> {
  late ImagesController imagesController;
  HomeController homeController = Get.find<HomeController>();
  final ScrollController _scrollController = ScrollController();

  final getStorage = GetStorage();

  static const AdRequest request = AdRequest(
    nonPersonalizedAds: true,
  );

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;

  @override
  void initState() {
    super.initState();
    _createInterstitialAd();
    imagesController = Get.put(ImagesController(widget.categoryItem),
        tag: widget.categoryItem.id);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => imagesController.isDataLoading.value
          ? renderSkeletonView()
          : Container(
              color: Colors.white,
              child: StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  controller: _scrollController,
                  itemCount: imagesController.imagesList.length,
                  itemBuilder: (context, index) {
                    return ImageRailItem(
                        imageIndex: index,
                        isFromPopular: false,
                        imagesController: imagesController,
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
                    return const StaggeredTile.fit(1);
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
