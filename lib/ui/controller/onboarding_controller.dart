
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OnBoardingController extends GetxController {
  final localStorage = GetStorage();
  bool get isFirstTime => localStorage.read('isFirstTime') ?? true;

  void markAsVisited(bool val) => localStorage.write('isFirstTime', val);
}