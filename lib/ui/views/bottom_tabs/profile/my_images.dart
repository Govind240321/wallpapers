import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wallpapers/ui/helpers/navigation_utils.dart';
import 'package:wallpapers/ui/models/photos_data.dart';
import 'package:wallpapers/ui/views/view_image_screen.dart';

class MyImagesScreen extends StatefulWidget {
  const MyImagesScreen({Key? key}) : super(key: key);

  @override
  State<MyImagesScreen> createState() => _MyImagesScreenState();
}

class _MyImagesScreenState extends State<MyImagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        photosList.isNotEmpty
            ? Container(
                color: Colors.white,
                padding: const EdgeInsets.all(12),
                child: StaggeredGridView.countBuilder(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 12,
                    itemCount: photosList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () =>
                            {_navigateToViewImageScreen(photosList[index])},
                        child: Hero(
                          tag: photosList[index].id!,
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
                                image: photosList[index].imageUrl!,
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
                  title: 'No Images',
                  titleTextStyle: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                          color: Color(0xff9da9c7), fontSize: 14)),
                ),
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

  _navigateToViewImageScreen(PhotosData photoItem) {
    var args = {'imageObject': photoItem};
    Go.to(() => const ViewImageScreen(), arguments: args);
  }
}
