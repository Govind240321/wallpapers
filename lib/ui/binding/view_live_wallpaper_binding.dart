
import 'package:get/get.dart';
import 'package:wallpapers/ui/controller/view_image_controller.dart';
import 'package:wallpapers/ui/controller/view_live_wallpaper_controller.dart';

class ViewLiveWallpaperScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViewLiveWallpaperController>(
          () => ViewLiveWallpaperController(),
    );
  }
}