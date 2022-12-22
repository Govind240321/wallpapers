import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:wallpapers/ui/views/components/wallart_logo.dart';
import 'package:wallpapers/ui/views/discover_screen.dart';

class HomeScreen extends StatefulWidget{
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WallArt",style: GoogleFonts.sancreek(textStyle: const TextStyle(fontSize: 25,color: Colors.black))),
        centerTitle: false,
        elevation: 0,
        actions: [
          _renderStreaksIcon()
        ],
        backgroundColor: Colors.white,
      ),
      body: _renderScreen(_currentIndex),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: const Icon(Icons.explore),
            title: const Text("Discover"),
            selectedColor: Colors.purple,
          ),

          /// Likes
          SalomonBottomBarItem(
            icon: const Icon(Icons.favorite_border),
            title: const Text("Favorites"),
            selectedColor: Colors.pink,
          ),

          /// Search
          SalomonBottomBarItem(
            icon: const Icon(Icons.slow_motion_video),
            title: const Text("Live wallpaper"),
            selectedColor: Colors.orange,
          ),

          /// Profile
          SalomonBottomBarItem(
            icon: const Icon(Icons.settings),
            title: const Text("Settings"),
            selectedColor: Colors.teal,
          ),
        ],
      ),
    );
  }

  Widget _renderScreen(int currentIndex) {
    Widget widget = Container();

    switch(_currentIndex){
      case 0 :
      widget = DiscoverScreen();
      break;

      case 1 :
      widget = const Text("Like Screen");
      break;

      case 2 :
      widget = const Text("Search Screen");
      break;

      case 3 :
      widget = const Text("Profile Screen");
      break;
    }

    return widget;
  }
}

Widget _renderStreaksIcon() {
  return Container();
}