import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:wallpapers/ui/constant/constants.dart';
import 'package:wallpapers/ui/views/components/wallart_logo.dart';
import 'package:wallpapers/ui/views/discover_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.appName,
            textAlign: TextAlign.center,
            style: GoogleFonts.sancreek(
                textStyle: const TextStyle(fontSize: 28, color: Colors.black))),
        centerTitle: false,
        elevation: 0,
        actions: [_renderStreaksIcon()],
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
              title: Text("Discover",style: GoogleFonts.openSans()),
              selectedColor: Colors.purple,
            ),

            /// Likes
            SalomonBottomBarItem(
              icon: const Icon(Icons.favorite_border),
              title: Text("Favorites",style: GoogleFonts.openSans()),
              selectedColor: Colors.pink,
            ),

            /// Search
            SalomonBottomBarItem(
              icon: const Icon(Icons.slow_motion_video),
              title: Text("Live wallpaper",style: GoogleFonts.openSans()),
              selectedColor: Colors.orange,
            ),

            /// Profile
            SalomonBottomBarItem(
              icon: const Icon(Icons.settings),
              title: Text("Settings",style: GoogleFonts.openSans()),
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
        widget = const Text("Like Screen");
        break;

      case 2:
        widget = const Text("Search Screen");
        break;

      case 3:
        widget = const Text("Profile Screen");
        break;
    }

    return widget;
  }
}

Widget _renderStreaksIcon() {
  return Center(
    child: Wrap(
      children: [
        Container(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
            margin: const EdgeInsets.only(right: 10),
            decoration: const BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.all(Radius.circular(30))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(Constants.streakIcon,
                    style: GoogleFonts.sancreek(
                        textStyle: const TextStyle(fontSize: 14))),
                Text("11",
                    style: GoogleFonts.openSans(
                        textStyle: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w600)))
              ],
            ))
      ],
    ),
  );
}
