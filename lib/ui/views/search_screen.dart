import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () {
            Get.back();
          },
          iconSize: 24,
        ),
        iconTheme: const IconThemeData.fallback(),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              style: GoogleFonts.openSans(
                  textStyle: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500)),
              decoration: InputDecoration(
                focusColor: Colors.black45,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                labelText: 'Search',
                hintText: 'Whatsapp status, Animal, Anime, Nature....etc.',
              ),
            ),
          )
        ],
      ),
    );
  }
}
