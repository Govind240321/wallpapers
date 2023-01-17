import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:wallpapers/ui/helpers/navigation_utils.dart';
import 'package:wallpapers/ui/models/live_wallpaper_data.dart';
import 'package:wallpapers/ui/views/bottom_tabs/content_screen.dart';
import 'package:wallpapers/ui/views/view_live_wallpaper_screen.dart';

class LiveWallpaperScreen extends StatefulWidget {
  const LiveWallpaperScreen({Key? key}) : super(key: key);

  @override
  State<LiveWallpaperScreen> createState() => _LiveWallpaperScreenState();
}

class _LiveWallpaperScreenState extends State<LiveWallpaperScreen> {
  final List<String> videos = [
    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-mother-with-her-little-daughter-eating-a-marshmallow-in-nature-39764-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-girl-in-neon-sign-1232-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-winter-fashion-cold-looking-woman-concept-video-39874-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-womans-feet-splashing-in-the-pool-1261-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4'
  ];

  @override
  Widget build(BuildContext context) {
    return Swiper(
      loop: false,
      itemBuilder: (BuildContext context, int index) {
        return ContentScreen(
          src: videos[index],
        );
      },
      itemCount: videos.length,
      scrollDirection: Axis.vertical,
    );
  }

  _navigateToViewLiveWallpaperScreen(LiveWallpaperItem photoItem) {
    var args = {'imageObject': photoItem};
    Go.to(() => const ViewLiveWallpaperScreen(), arguments: args);
  }
}
