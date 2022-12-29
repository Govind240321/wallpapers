import 'package:get/get.dart';
import 'package:wallpapers/ui/models/photos_data.dart';

class ViewImageController extends GetxController {
  PhotoItem? imageObject;

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