import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:platform_device_id/platform_device_id.dart';

import '../constant/api_constants.dart';

class SplashController extends GetxController {
  final localStorage = GetStorage();

  bool get isFirstTime => localStorage.read('isFirstTime') ?? true;
  final splashVideoUrl = Rxn<String?>("");
  String? deviceId;

  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Future<void> onInit() async {
    super.onInit();
    deviceId = await PlatformDeviceId.getDeviceId;
    createDeviceOnServer();
    getSplashVideoUrl();
  }

  getSplashVideoUrl() async {
    final docRef = db.collection("splash_config").doc("DdeyZziwFeIUpfQauRJN");
    docRef.get().then(
          (DocumentSnapshot doc) async {
        if (doc.data() != null) {
          final data = doc.data() as Map<String, dynamic>;
          splashVideoUrl(data['splashVideoUrl']);
        } else {
          splashVideoUrl(null);
        }
      },
      onError: (e) {
        splashVideoUrl(null);
        print("Error getting document: $e");
      },
    );
  }

  createDeviceOnServer() async {
    try {
      var firebaseToken = '';
      await FirebaseMessaging.instance
          .getToken()
          .then((token) => {firebaseToken = token ?? ''});
      var url = Uri.http(ApiConstant.baseUrl, ApiConstant.addDeviceId);
      var response = await http
          .post(url, body: {"deviceId": deviceId, "token": firebaseToken});
      print('Request url: ${response.request?.url}');
      print(
          'Request params: Device Id $deviceId Firebase token: $firebaseToken');
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