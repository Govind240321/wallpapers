import 'package:get/get.dart';
import 'package:wallpapers/ui/models/live_wallpaper_data.dart';
import 'package:wallpapers/ui/models/photos_data.dart';

class ViewLiveWallpaperController extends GetxController {
  LiveWallpaperItem? imageObject;

  @override
  void onInit() {
    super.onInit();
    imageObject = Get.arguments['imageObject'];
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  void onClose() {}
}
