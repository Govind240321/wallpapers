import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wallpapers/ui/constant/constants.dart';
import 'package:wallpapers/ui/helpers/app_extension.dart';
import 'package:wallpapers/ui/views/view_image_screen.dart';

import '../controller/images_list_controller.dart';
import '../helpers/navigation_utils.dart';
import '../models/image_data.dart';
import '../models/photos_data.dart';
import 'components/skeleton.dart';

class ImagesListScreen extends StatefulWidget {
  const ImagesListScreen({Key? key}) : super(key: key);

  @override
  State<ImagesListScreen> createState() => _ImagesListScreenState();
}

class _ImagesListScreenState extends State<ImagesListScreen> {
  ImagesController imagesController = Get.put(ImagesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(imagesController.categoryItem!.name),
        titleTextStyle: GoogleFonts.openSans(
            textStyle: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () {
            Get.back();
          },
          iconSize: 24,
        ),
        iconTheme: const IconThemeData.fallback(),
      ),
      body: Obx(() => imagesController.isDataLoading.value
          ? renderSkeletonView()
          : Container(
              color: Colors.white,
              padding: const EdgeInsets.all(12),
              child: StaggeredGridView.countBuilder(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 12,
                  itemCount: imagesController.imagesList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => {
                        _showAvailDialog(imagesController.imagesList[index])
                      },
                      child: Hero(
                        tag: "${imagesController.imagesList[index].id}",
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
                              image:
                                  imagesController.imagesList[index].imageUrl!,
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
            ).fadeAnimation(0.6)),
    );
  }

  renderSkeletonView() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: StaggeredGridView.countBuilder(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 12,
          itemCount: 10,
          itemBuilder: (context, index) {
            return const Skeleton();
          },
          staggeredTileBuilder: (index) {
            return StaggeredTile.count(1, index.isEven ? 1.2 : 1.8);
          }),
    );
  }

  _navigateToViewImageScreen(ImageData imageData) {
    var args = {
      'imageObject': PhotosData(id: imageData.id, imageUrl: imageData.imageUrl)
    };
    Go.to(() => const ViewImageScreen(), arguments: args);
  }

  _showAvailDialog(ImageData imageData) {
    Dialogs.materialDialog(
        msg: '${Constants.streakIcon}25',
        title: "Confirm to Avail",
        color: Colors.white,
        context: context,
        msgStyle: GoogleFonts.openSansCondensed(
            fontSize: 24, fontWeight: FontWeight.bold),
        actions: [
          IconsOutlineButton(
            onPressed: () {
              Get.back();
            },
            text: 'Cancel',
            iconData: Icons.cancel_rounded,
            textStyle: const TextStyle(color: Colors.grey),
            iconColor: Colors.grey,
          ),
          IconsButton(
            onPressed: () {
              Get.back();
              _navigateToViewImageScreen(imageData);
            },
            text: 'Confirm',
            iconData: Icons.done,
            color: Colors.green,
            textStyle: const TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
  }
}
