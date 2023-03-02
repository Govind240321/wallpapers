import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:wallpapers/ui/constant/constants.dart';
import 'package:wallpapers/ui/controller/home_controller.dart';
import 'package:wallpapers/ui/helpers/app_extension.dart';

import '../constant/ads_id_constant.dart';

class StreakPremiumScreen extends StatefulWidget {
  const StreakPremiumScreen({Key? key}) : super(key: key);

  @override
  State<StreakPremiumScreen> createState() => _StreakPremiumScreenState();
}

class _StreakPremiumScreenState extends State<StreakPremiumScreen> {
  HomeController homeController = Get.find<HomeController>();

  static const AdRequest request = AdRequest(
    nonPersonalizedAds: true,
  );

  int maxFailedLoadAttempts = 3;
  RewardedInterstitialAd? _rewardedInterstitialAd;
  int _numRewardedInterstitialLoadAttempts = 0;

  @override
  void initState() {
    _createRewardedInterstitialAd();
    super.initState();
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
            setState(() {});
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedInterstitialAd failed to load: $error');
            _rewardedInterstitialAd = null;
            setState(() {});
            _numRewardedInterstitialLoadAttempts += 1;
            if (_numRewardedInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createRewardedInterstitialAd();
            }
          },
        ));
  }

  void _showRewardedInterstitialAd() {
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
      int rewardAmount = RandomInt.generate(max: 15);
      Dialogs.materialDialog(
          color: Colors.white,
          msg: 'Congratulations, you won $rewardAmount Streaks',
          title: '${Constants.streakIcon}$rewardAmount',
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
                homeController.updateStreaks(rewardAmount);
                Get.back();
              },
              text: 'Claim',
              iconData: Icons.done,
              color: Colors.blue,
              textStyle: const TextStyle(color: Colors.white),
              iconColor: Colors.white,
            ),
          ]);
    });
    _rewardedInterstitialAd = null;
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuerySize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Stack(
          children: [
            Image.asset("assets/streak_bg.gif",
                fit: BoxFit.fill,
                width: mediaQuerySize.width,
                height: mediaQuerySize.height),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Constants.streakIcon,
                    style: GoogleFonts.sancreek(fontSize: 150),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Obx(() => Text(
                    "${Constants.streakIcon}${homeController.userData.value?.streakPoint}",
                        style: GoogleFonts.sancreek(
                            textStyle: const TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      if (_rewardedInterstitialAd != null) {
                        _showRewardedInterstitialAd();
                      } else {
                        _createRewardedInterstitialAd();
                      }
                    },
                    child: _rewardedInterstitialAd != null
                        ? Container(
                            width: mediaQuerySize.width * 0.7,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            child: Center(
                              child: Text(
                                "Click here to Watch Ads",
                                style: GoogleFonts.openSansCondensed(
                                    textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                        fontSize: 14)),
                              ),
                            ),
                          )
                        : const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Watch Ads and Earn \n upto 25 Streaks per Ad",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.anton(
                        textStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w300)),
                  )
                ],
              ),
            ),
            Positioned(
                top: 16,
                left: 8,
                child: IconButton(
                  icon: const Icon(
                    CupertinoIcons.back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  iconSize: 24,
                ))
          ],
        ),
      ),
    );
  }
}
