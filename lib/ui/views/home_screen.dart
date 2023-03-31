import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallpapers/ui/constant/constants.dart';
import 'package:wallpapers/ui/controller/home_controller.dart';
import 'package:wallpapers/ui/helpers/app_extension.dart';
import 'package:wallpapers/ui/helpers/navigation_utils.dart';
import 'package:wallpapers/ui/views/bottom_tabs/discover_screen.dart';
import 'package:wallpapers/ui/views/bottom_tabs/dual_wallpaper_screen.dart';
import 'package:wallpapers/ui/views/bottom_tabs/popular_screen.dart';
import 'package:wallpapers/ui/views/bottom_tabs/profile/profile_screen.dart';
import 'package:wallpapers/ui/views/bottom_tabs/videos_screen.dart';
import 'package:wallpapers/ui/views/login_screen.dart';
import 'package:wallpapers/ui/views/streak_premium.dart';

import '../constant/ads_id_constant.dart';

AppOpenAd? myAppOpenAd;

loadAppOpenAd() {
  AppOpenAd.load(
      adUnitId: AdsConstant.OPEN_APP_ID,
      //Your ad Id from admob
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            myAppOpenAd = ad;
            myAppOpenAd!.show();
          },
          onAdFailedToLoad: (error) {}),
      orientation: AppOpenAd.orientationPortrait);
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  var _currentIndex = 0;
  HomeController homeController = Get.put(HomeController());
  var getStorage = GetStorage();

  @override
  void initState() {
    super.initState();
    loadAppOpenAd();
    homeController.goToLogin.listen((shouldGo) {
      if (shouldGo) {
        setState(() {
          _currentIndex = 4;
        });
      }
    });

    homeController.appHasUpdate.listen((hasUpdate) async {
      if (hasUpdate) {
        appUpdateDialog();
      } else {
        checkAndShowAppReviewDialog();
      }
    });
  }

  checkAndShowAppReviewDialog([iconClick = false]) {
    int appVisit = getStorage.read("appVisit") ?? 0;
    bool hasRated = getStorage.read("hasRated") ?? false;
    if (iconClick || (appVisit >= 2 && !hasRated)) {
      Dialogs.materialDialog(
          color: Colors.white,
          msg:
              'Tell us what you think! Your feedback is important to us. Please rate our app on the Play Store and help us improve. Thank you for your support!',
          title: 'Rate Us on Play Store!',
          lottieBuilder: Lottie.asset(
            'assets/rating.json',
            fit: BoxFit.contain,
          ),
          barrierDismissible: false,
          context: context,
          actions: [
            IconsButton(
              onPressed: () {
                Get.back();
              },
              text: 'Not now 😔',
              color: Colors.blue,
              textStyle: const TextStyle(color: Colors.white),
              iconColor: Colors.white,
            ),
            IconsButton(
              onPressed: () async {
                Get.back();
                getStorage.write("appVisit", 0);
                getStorage.write("hasRated", true);
                PackageInfo packageInfo = await PackageInfo.fromPlatform();
                final Uri _url =
                    Uri.parse('market://details?id=${packageInfo.packageName}');
                if (!await launchUrl(_url)) {
                  throw Exception('Could not launch $_url');
                }
              },
              text: 'Rate Us 🤩',
              color: Colors.blue,
              textStyle: const TextStyle(color: Colors.white),
              iconColor: Colors.white,
            ),
          ]);
    }
  }

  appUpdateDialog() {
    Dialogs.materialDialog(
        msg: 'We are coming up with something new in this update.',
        title: "Update Available",
        color: Colors.white,
        context: context,
        barrierDismissible: !homeController.isForceUpdate.value,
        titleStyle: GoogleFonts.openSansCondensed(
            fontSize: 20, fontWeight: FontWeight.bold),
        actions: [
          !homeController.isForceUpdate.value
              ? IconsOutlineButton(
                  onPressed: () {
                    Get.back();
                  },
                  text: 'Cancel',
                  textStyle: const TextStyle(color: Colors.grey),
                  iconColor: Colors.grey,
                )
              : Container(),
          IconsButton(
            onPressed: () async {
              if (!homeController.isForceUpdate.value) {
                Get.back();
              }
              PackageInfo packageInfo = await PackageInfo.fromPlatform();
              final Uri _url =
                  Uri.parse('market://details?id=${packageInfo.packageName}');
              if (!await launchUrl(_url)) {
                throw Exception('Could not launch $_url');
              }
            },
            text: 'Update',
            color: Colors.green,
            textStyle: const TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex != 3
          ? AppBar(
              title: Row(
                children: [
                  Image.asset("assets/icon.png", height: 35, width: 35),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(Constants.appName,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.sancreek(
                          textStyle: const TextStyle(
                              fontSize: 28, color: Colors.black))),
                ],
              ).fadeAnimation(0.6),
              centerTitle: false,
              elevation: 0,
              actions: [
                GestureDetector(
                  onTap: () {
                    checkAndShowAppReviewDialog(true);
                  },
                  child: Lottie.asset(
                    'assets/rate_us.json',
                    fit: BoxFit.contain,
                  ),
                ),
                Obx(
                  () => homeController.isLoggedIn.value
                      ? _renderStreaksIcon().fadeAnimation(0.5)
                      : Container(),
                )
              ],
              backgroundColor: Colors.white,
            )
          : null,
      body: _renderScreen(_currentIndex),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: SalomonBottomBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: [
            /// Home
            SalomonBottomBarItem(
              icon: const Icon(Icons.explore),
              title: Text("Discover",
                  style: GoogleFonts.anton(
                      textStyle: const TextStyle(fontWeight: FontWeight.w300))),
              selectedColor: Colors.purple,
            ),

            /// Likes
            SalomonBottomBarItem(
              icon: Image.asset("assets/popular.webp", width: 24, height: 24),
              title: Text("Popular",
                  style: GoogleFonts.anton(
                      textStyle: const TextStyle(fontWeight: FontWeight.w300))),
              selectedColor: Colors.pink,
            ),

            /// Dual Wallpaper
            SalomonBottomBarItem(
              icon: Image.asset("assets/dual.png", width: 24, height: 24),
              title: Text("Dual",
                  style: GoogleFonts.anton(
                      textStyle: const TextStyle(fontWeight: FontWeight.w300))),
              selectedColor: Colors.red,
            ),

            /// Videos
            SalomonBottomBarItem(
              icon: const Icon(Icons.slow_motion_video),
              title: Text("Videos",
                  style: GoogleFonts.anton(
                      textStyle: const TextStyle(fontWeight: FontWeight.w300))),
              selectedColor: Colors.orange,
            ),

            /// Profile
            SalomonBottomBarItem(
              icon: const Icon(CupertinoIcons.person),
              title: Text("Profile",
                  style: GoogleFonts.anton(
                      textStyle: const TextStyle(fontWeight: FontWeight.w300))),
              selectedColor: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderScreen(int currentIndex) {
    Widget widget = Container();

    switch (_currentIndex) {
      case 0:
        widget = DiscoverScreen();
        break;

      case 1:
        widget = const PopularScreen();
        break;

      case 2:
        widget = const DualWallpaperScreen();
        break;

      case 3:
        widget = const VideosScreen();
        break;

      case 4:
        widget = Obx(() => homeController.isLoggedIn.value
            ? const ProfileScreen()
            : const LoginScreen());
        break;
    }

    return widget;
  }

  logOutUser() {
    homeController.logOutUser();
    print("User Sign Out");
  }

  Widget _renderStreaksIcon() {
    return Center(
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Go.to(const StreakPremiumScreen());
            },
            child: Wrap(
              children: [
                Container(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 3, bottom: 3),
                    decoration: const BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(Constants.streakIcon,
                            style: GoogleFonts.sancreek(
                                textStyle: const TextStyle(fontSize: 14))),
                        Obx(() => homeController.userData.value?.streakPoint !=
                                null
                            ? Text(
                                "${homeController.userData.value?.streakPoint}",
                                style: GoogleFonts.anton(
                                    textStyle: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300)))
                            : const SizedBox(
                                width: 1,
                                height: 1,
                              ))
                      ],
                    ))
              ],
            ),
          ),
          IconButton(
            icon: Image.asset("assets/log_out.webp", width: 24, height: 24),
            onPressed: () {
              _showLogOutDialog();
            },
            iconSize: 10,
          )
        ],
      ),
    );
  }

  Future<void> _showLogOutDialog() async {
    return showDialog<void>(
      context: context, barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log out'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure, you want to logout?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                logOutUser();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
