import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:wallpapers/ui/constant/constants.dart';
import 'package:wallpapers/ui/controller/home_controller.dart';
import 'package:wallpapers/ui/helpers/app_extension.dart';
import 'package:wallpapers/ui/helpers/navigation_utils.dart';
import 'package:wallpapers/ui/views/bottom_tabs/discover_screen.dart';
import 'package:wallpapers/ui/views/bottom_tabs/favorite_screen.dart';
import 'package:wallpapers/ui/views/bottom_tabs/live_wallpaper_screen.dart';
import 'package:wallpapers/ui/views/bottom_tabs/profile/profile_screen.dart';
import 'package:wallpapers/ui/views/login_screen.dart';
import 'package:wallpapers/ui/views/search_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  var _currentIndex = 0;
  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.appName,
                textAlign: TextAlign.center,
                style: GoogleFonts.sancreek(
                    textStyle:
                        const TextStyle(fontSize: 28, color: Colors.black)))
            .fadeAnimation(0.6),
        centerTitle: false,
        elevation: 0,
        actions: [
          Center(
            child: IconButton(
              iconSize: 24,
              icon: const Icon(
                CupertinoIcons.search,
                color: Colors.black,
              ),
              onPressed: () {
                Go.to(const SearchScreen());
              },
            ),
          ).fadeAnimation(0.5),
          Obx(
            () => homeController.isLoggedIn.value
                ? _renderStreaksIcon().fadeAnimation(0.5)
                : Container(),
          )
        ],
        backgroundColor: Colors.white,
      ),
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
              title: Text("Discover", style: GoogleFonts.openSans()),
              selectedColor: Colors.purple,
            ),

            /// Likes
            SalomonBottomBarItem(
              icon: const Icon(Icons.favorite_border),
              title: Text("Favorites", style: GoogleFonts.openSans()),
              selectedColor: Colors.pink,
            ),

            /// Search
            SalomonBottomBarItem(
              icon: const Icon(Icons.slow_motion_video),
              title: Text("Live wallpaper", style: GoogleFonts.openSans()),
              selectedColor: Colors.orange,
            ),

            /// Profile
            SalomonBottomBarItem(
              icon: const Icon(CupertinoIcons.person),
              title: Text("Profile", style: GoogleFonts.openSans()),
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
        widget = Obx(() => homeController.isLoggedIn.value
            ? const FavoriteScreen()
            : const LoginScreen());
        break;

      case 2:
        widget = const LiveWallpaperScreen();
        break;

      case 3:
        widget = Obx(() => homeController.isLoggedIn.value
            ? const ProfileScreen()
            : const LoginScreen());
        break;
    }

    return widget;
  }

  _doLogin() {
    homeController.signInWithGoogle().then((User? user) {
      print(user);
    }).catchError((e) => print(e));
  }

  logOutUser() {
    homeController.logOutUser();
    print("User Sign Out");
  }

  Widget _renderStreaksIcon() {
    return Center(
      child: Row(
        children: [
          Wrap(
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
                      Obx(() => homeController.userData.value?.streaksPoint !=
                              null
                          ? Text(
                              "${homeController.userData.value?.streaksPoint}",
                              style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600)))
                          : Container(width: 1,height: 1,))
                    ],
                  ))
            ],
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
