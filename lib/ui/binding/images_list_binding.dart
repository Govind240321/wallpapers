import 'package:get/get.dart';
import 'package:wallpapers/ui/controller/images_list_controller.dart';

class ImagesListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImagesListController>(
      () => ImagesListController(),
    );
  }
}
