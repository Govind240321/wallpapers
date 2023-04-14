import 'dart:convert';
import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../constant/api_constants.dart';
import '../models/category_data.dart';
import '../models/image_data.dart';

class ImagesController extends GetxController {
  var isDataLoading = true.obs;
  RxList<ImageData> imagesList = (List<ImageData>.of([])).obs;
  CategoryData? categoryItem;
  var mStart = 0;
  var paginationEnded = false;

  ImagesController(this.categoryItem);

  @override
  Future<void> onInit() async {
    super.onInit();
    await getAllImagesByCategoryId();
  }

  getAllImagesByCategoryId() async {
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
          ApiConstant.baseUrl,
          ApiConstant.categoryWiseImages
              .replaceAll(":id", categoryItem?.id ?? ""),
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
