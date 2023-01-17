import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:wallpapers/ui/models/category_data.dart';
import 'package:wallpapers/ui/models/images_data_api.dart';

class ImagesListController extends GetxController {
  CategoryItem? categoryItem;
  var isDataLoading = false.obs;
  ImagesDataApi? imagesDataApi;
  var mPage = 1;

  @override
  void onInit() {
    super.onInit();
    categoryItem = Get.arguments['categoryItem'];
    fetchImages();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  void onClose() {}

  fetchImages() async {
    try {
      if (mPage == 1) {
        isDataLoading(true);
      }
      http.Response response = await http.get(
          Uri.tryParse(
              'https://api.pexels.com/v1/search?query=${categoryItem!.name}&page=$mPage&per_page=50&orientation=portrait')!,
          headers: {
            'Authorization':
                '563492ad6f9170000100000161570a288a2d4602a2167ce1b055fd4a'
          });
      if (response.statusCode == 200) {
        ///data successfully
        var result = jsonDecode(response.body);
        if (mPage > 1) {
          var tempImageData = imagesDataApi;
          tempImageData?.photos?.addAll(ImagesDataApi.fromJson(result)
              .photos!
              .take(ImagesDataApi.fromJson(result).photos!.length));
          imagesDataApi = tempImageData;
        } else {
          imagesDataApi = ImagesDataApi.fromJson(result);
        }
      } else {
        ///error
        print('Error while getting data is =============>>>>>>>>> ${response.statusCode}');
      }
    } catch (e) {
      log('Error while getting data is $e');
      print('Error while getting data is $e');
    } finally {
      isDataLoading(false);
    }
  }
}
