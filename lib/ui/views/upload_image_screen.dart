import 'dart:io';

import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:wallpapers/ui/controller/profile_controller.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({Key? key}) : super(key: key);

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];
  ProfileController profileController = Get.find<ProfileController>();
  late ProgressDialog pr;

  @override
  void initState() {
    super.initState();
    // profileController.uploading.listen((isUploading) {
    //   if (isUploading) {
    //     pr.show();
    //   } else {
    //     pr.hide();
    //     Get.back();
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context, isDismissible: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text("Upload Image"),
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
      body: Stack(
        children: [
          _renderImagesListUi(),
          Positioned(
            bottom: imageFileList.isNotEmpty == true ? 80 : 30,
            right: 30,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: IconButton(
                icon: const Icon(
                  CupertinoIcons.plus,
                  color: Colors.white,
                ),
                onPressed: () {
                  selectImages();
                },
              ),
            ),
          ),
          imageFileList.isNotEmpty == true
              ? Positioned(
                  bottom: 20,
                  left: 30,
                  right: 30,
                  child: TextButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.black),
                          foregroundColor:
                              MaterialStatePropertyAll(Colors.white)),
                      onPressed: () {
                        // profileController.makeMultipleRequests(imageFileList);
                      },
                      child: Text(
                        "Upload",
                        style: GoogleFonts.openSans(),
                      )))
              : Container(
                  padding: const EdgeInsets.all(50),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      EmptyWidget(
                          image: null, packageImage: PackageImage.Image_2),
                      const SizedBox(height: 30),
                      Text("No any image added",
                          style: GoogleFonts.anton(
                              textStyle: const TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w300)))
                    ],
                  ),
                )
        ],
      ),
    );
  }

  void selectImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList.addAll(selectedImages);
    }
    print("Image List Length:${imageFileList.toSet()}");
    setState(() {});
  }

  _renderImagesListUi() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: StaggeredGridView.countBuilder(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 12,
          itemCount: imageFileList.length,
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              child: Image.file(
                File(imageFileList[index].path),
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
              ),
            );
          },
          staggeredTileBuilder: (index) {
            return const StaggeredTile.count(1, 1.2);
          }),
    );
  }
}
