import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:wallpapers/ui/controller/favorite_controller.dart';
import 'package:wallpapers/ui/models/image_data.dart';

class ViewImageController extends GetxController {
  ImageData? imageObject;
  FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user; // Firebase user
  late FavoriteController favoriteController;
  var isFavorite = false.obs;

  @override
  void onInit() {
    super.onInit();
    imageObject = Get.arguments['imageObject'];
    _user = _auth.currentUser;

    initFavController();
    checkFavorite();
  }

  initFavController() async {
    try {
      favoriteController = Get.find<FavoriteController>();
    } catch (e) {
      favoriteController = Get.put(FavoriteController());
    }
  }

  checkFavorite() {
    if (_user == null) {
      return;
    }
    final docRef = db
        .collection("users")
        .doc(_user!.uid)
        .collection("favorites")
        .doc(imageObject!.id);
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data();
        isFavorite(data != null);
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  addToFavorite() {
    // db
    //     .collection("users")
    //     .doc(_user!.uid)
    //     .collection("favorites")
    //     .doc(imageObject!.id)
    //     .set(imageObject!.toJson())
    //     .then(
    //   (doc) {
    //     print("Document added");
    //     favoriteController.getFavorites();
    //   },
    //   onError: (e) => print("Error updating document $e"),
    // );
  }

  removeFromFavorite() {
    // db
    //     .collection("users")
    //     .doc(_user!.uid)
    //     .collection("favorites")
    //     .doc(imageObject!.id)
    //     .delete()
    //     .then(
    //   (doc) {
    //     print("Document deleted");
    //     favoriteController.getFavorites();
    //   },
    //   onError: (e) => print("Error updating document $e"),
    // );
  }
}
