import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wallpapers/ui/helpers/app_extension.dart';
import 'package:wallpapers/ui/helpers/navigation_utils.dart';
import 'package:wallpapers/ui/models/live_wallpaper_data.dart';
import 'package:wallpapers/ui/views/view_live_wallpaper_screen.dart';

class LiveWallpaperScreen extends StatefulWidget {
  const LiveWallpaperScreen({Key? key}) : super(key: key);

  @override
  State<LiveWallpaperScreen> createState() => _LiveWallpaperScreenState();
}

class _LiveWallpaperScreenState extends State<LiveWallpaperScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: StaggeredGridView.countBuilder(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 12,
          itemCount: liveWallpaperList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => {
                _navigateToViewLiveWallpaperScreen(liveWallpaperList[index])
              },
              child: Hero(
                tag: liveWallpaperList[index].heroId,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: liveWallpaperList[index].videoUrl,
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
              ),
            );
          },
          staggeredTileBuilder: (index) {
            return StaggeredTile.count(1, index.isEven ? 1.2 : 1.8);
          }),
    ).fadeAnimation(0.6);
  }

  _navigateToViewLiveWallpaperScreen(LiveWallpaperItem photoItem) {
    var args = {'imageObject': photoItem};
    Go.to(() => const ViewLiveWallpaperScreen(), arguments: args);
  }
}
