import 'dart:convert';
import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:wallpapers/ui/models/dual_wallpaper_data.dart';

import '../constant/api_constants.dart';

class DualWallpaperController extends GetxController {
  var isDataLoading = true.obs;
  RxList<DualWallpaperData> dualWallpaperList =
      (List<DualWallpaperData>.of([])).obs;
  var mStart = 0;
  var paginationEnded = false;

  @override
  void onInit() {
    super.onInit();
    getAllDualWallpaper();
  }

  getAllDualWallpaper() async {
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
      var url = Uri.http(ApiConstant.baseUrl, ApiConstant.getAllDualWallpaper,
          queryParameters);
      var response = await http.get(url);
      print('Request url: ${response.request?.url}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        ///data successfully
        List<dynamic> result = jsonDecode(response.body);
        paginationEnded = result.isEmpty;

        if (mStart == 0) {
          dualWallpaperList(
              result.map((e) => DualWallpaperData.fromJson(e)).toList());
        } else {
          dualWallpaperList.addAll(
              result.map((e) => DualWallpaperData.fromJson(e)).toList());
        }
      }
      isDataLoading(false);
    } catch (ex) {
      log('Error while getting data is $ex');
      print('Error while getting data is $ex');
      isDataLoading(false);
    }
  }
}
