import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallpapers/ui/controller/profile_controller.dart';
import 'package:wallpapers/ui/helpers/app_extension.dart';
import 'package:wallpapers/ui/views/bottom_tabs/profile/favorite_screen.dart';
import 'package:wallpapers/ui/views/bottom_tabs/profile/my_images.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [_userDetailRow(context), _renderTabsUi(context)],
      ).fadeAnimation(0.5),
    );
  }

  _renderTabsUi(BuildContext context) {
    return const DefaultTabController(
      length: 2,
      child: Expanded(
          child: Scaffold(
        backgroundColor: Colors.white,
        appBar: TabBar(
          labelColor: Colors.black45,
          indicatorColor: Colors.black45,
          tabs: [
            Tab(
                icon: Icon(
                  CupertinoIcons.photo,
                  color: Colors.black45,
                ),
                text: "Images"),
            Tab(
                icon: Icon(
                  CupertinoIcons.heart,
                  color: Colors.black45,
                ),
                text: "Favorites"),
          ],
        ),
        body: TabBarView(
          children: [MyImagesScreen(), FavoriteScreen()],
        ),
      )),
    );
  }

  Widget _userDetailRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/avatar.png", width: 70, height: 70),
          const SizedBox(
            width: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profileController.user!.displayName!,
                style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600)),
              ),
              Text(
                profileController.user!.email!,
                style: GoogleFonts.openSans(
                    textStyle: const TextStyle(fontSize: 14)),
              )
            ],
          )
        ],
      ),
    );
  }
}
