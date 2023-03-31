
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashController extends GetxController {
  final localStorage = GetStorage();

  bool get isFirstTime => localStorage.read('isFirstTime') ?? true;
  final splashVideoUrl = Rxn<String?>("");

  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Future<void> onInit() async {
    super.onInit();
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
}