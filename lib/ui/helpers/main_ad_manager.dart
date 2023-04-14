import 'package:easy_ads_flutter/easy_ads_flutter.dart';

class AdsIdManager extends IAdIdManager {
  //Test Ids
  @override
  AppAdIds? get admobAdIds => const AppAdIds(
      appId: 'ca-app-pub-7382000787674138~7000297666',
      appOpenId: 'ca-app-pub-3940256099942544/3419835294',
      interstitialId: 'ca-app-pub-3940256099942544/1033173712');

  //Production
  // @override
  // AppAdIds? get admobAdIds => const AppAdIds(
  //     appId: 'ca-app-pub-7382000787674138~7000297666',
  //     appOpenId: 'ca-app-pub-7382000787674138/2854821482',
  //     interstitialId: 'ca-app-pub-7382000787674138/8977376706'
  // );

  @override
  AppAdIds? get appLovinAdIds => null;

  @override
  AppAdIds? get fbAdIds => null;

  @override
  AppAdIds? get unityAdIds => null;
}
