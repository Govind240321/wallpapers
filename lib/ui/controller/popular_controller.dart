import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:platform_device_id/platform_device_id.dart';
import 'package:wallpapers/ui/models/image_data.dart';

import '../constant/api_constants.dart';

class PopularController extends GetxController {
  var isDataLoading = false.obs;
  RxList<ImageData> imagesList = (List<ImageData>.of([])).obs;
  var mStart = 0;
  var paginationEnded = false;
  var getStorage = GetStorage();
  String? deviceId;

  @override
  Future<void> onInit() async {
    super.onInit();
    deviceId = await PlatformDeviceId.getDeviceId;
    getAllImages();
    int appVisit = getStorage.read("appVisit") ?? 0;
    getStorage.write("appVisit", appVisit + 1);
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

      final queryParameters = {
        'start': mStart.toString(),
        'limit': ApiConstant.limit.toString(),
        'deviceId': deviceId
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

  addToFavorite(String imageId) async {
    try {
      var url = Uri.http(ApiConstant.baseUrl, ApiConstant.addToFavorites);
      var response =
          await http.put(url, body: {"imageId": imageId, "deviceId": deviceId});
      print('Request url: ${response.request?.url}');
      print('Request params: Device Id ${deviceId}');
      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
      }
    } catch (ex) {
      log('Error while getting data is $ex');
      print('Error while getting data is $ex');
    }
  }

  removeFavorite(String imageId) async {
    try {
      var url = Uri.http(ApiConstant.baseUrl, ApiConstant.removeFavorites);
      var response =
          await http.put(url, body: {"imageId": imageId, "deviceId": deviceId});
      print('Request url: ${response.request?.url}');
      print('Request params: Device Id ${deviceId}');
      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
      }
    } catch (ex) {
      log('Error while getting data is $ex');
      print('Error while getting data is $ex');
    }
  }
}
