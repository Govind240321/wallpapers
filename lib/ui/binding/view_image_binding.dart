
import 'package:get/get.dart';
import 'package:wallpapers/ui/controller/view_image_controller.dart';

class ViewImageScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViewImageController>(
          () => ViewImageController(),
    );
  }
}