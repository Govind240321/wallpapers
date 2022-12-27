
import 'package:get/get.dart';
import 'package:wallpapers/ui/models/photos_data.dart';
import 'package:wallpapers/ui/views/bottom_tabs/discover_screen.dart';

class ViewImageController extends GetxController{
  PhotoItem? imageObject;
  @override
  void onInit() {
    super.onInit();
    imageObject = Get.arguments['imageObject'];
  }
}