import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wallpapers/ui/helpers/navigation_utils.dart';
import 'package:wallpapers/ui/models/live_wallpaper_data.dart';
import 'package:wallpapers/ui/views/view_live_wallpaper_screen.dart';

class MyLiveWallpaper extends StatefulWidget {
  const MyLiveWallpaper({Key? key}) : super(key: key);

  @override
  State<MyLiveWallpaper> createState() => _MyLiveWallpaperState();
}

class _MyLiveWallpaperState extends State<MyLiveWallpaper> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        liveWallpaperList.isNotEmpty
            ? Container(
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
                          _navigateToViewLiveWallpaperScreen(
                              liveWallpaperList[index])
                        },
                        child: Hero(
                          tag: liveWallpaperList[index].heroId,
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.transparent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16)),
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
              )
            : Container(
                padding: const EdgeInsets.all(50),
                alignment: Alignment.center,
                child: EmptyWidget(
                    image: null,
                    packageImage: PackageImage.Image_1,
                    title: 'No Live wallpapers',
                    titleTextStyle: GoogleFonts.openSans(
                        textStyle: const TextStyle(
                            color: Color(0xff9da9c7), fontSize: 14))),
              ),
        Positioned(
          bottom: 20,
          right: 20,
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: IconButton(
              icon: const Icon(
                CupertinoIcons.plus,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ),
        )
      ],
    );
  }

  _navigateToViewLiveWallpaperScreen(LiveWallpaperItem photoItem) {
    var args = {'imageObject': photoItem};
    Go.to(() => const ViewLiveWallpaperScreen(), arguments: args);
  }
}
