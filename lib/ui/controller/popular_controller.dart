import 'dart:convert';
import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:wallpapers/ui/models/image_data.dart';

import '../constant/api_constants.dart';

class PopularController extends GetxController {
  var isDataLoading = false.obs;
  RxList<ImageData> imagesList = (List<ImageData>.of([])).obs;
  var mStart = 0;
  var paginationEnded = false;

  @override
  void onInit() {
    super.onInit();
    getAllImages();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  void onClose() {}

  getAllImages() async {
    try {
      if (mStart == 0) {
        isDataLoading(true);
      }
      var androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
      final queryParameters = {
        'start': mStart.toString(),
        'limit': ApiConstant.limit.toString(),
        'deviceId': androidDeviceInfo.id
      };
      var url = Uri.http(
          ApiConstant.baseUrl, ApiConstant.getAllImages, queryParameters);
      var response = await http.get(url);
      print('Request url: ${response.request?.url}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        ///data successfully
        List<dynamic> result = jsonDecode(response.body);
        paginationEnded = result.isEmpty;

        if (mStart == 0) {
          imagesList(result.map((e) => ImageData.fromJson(e)).toList());
        } else {
          imagesList.addAll(result.map((e) => ImageData.fromJson(e)).toList());
        }
        imagesList(imagesList.toSet().toList());
      }
      isDataLoading(false);
    } catch (ex) {
      log('Error while getting data is $ex');
      print('Error while getting data is $ex');
      isDataLoading(false);
    }
  }
}
