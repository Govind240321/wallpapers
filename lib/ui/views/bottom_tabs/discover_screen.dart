import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wallpapers/ui/constant/constants.dart';
import 'package:wallpapers/ui/helpers/app_extension.dart';

class CategoryItem {
  final String name;
  final String imageUrl;

  CategoryItem(this.name, this.imageUrl);
}

final List<CategoryItem> bannerList = [
  CategoryItem("Love",
      "https://images.pexels.com/photos/704748/pexels-photo-704748.jpeg?auto=compress&cs=tinysrgb&w=1600"),
  CategoryItem("Office",
      "https://images.pexels.com/photos/37347/office-sitting-room-executive-sitting.jpg?auto=compress&cs=tinysrgb&w=1600"),
  CategoryItem("Dark",
      "https://images.pexels.com/photos/2449600/pexels-photo-2449600.png?auto=compress&cs=tinysrgb&w=1600"),
  CategoryItem("Nature",
      "https://images.pexels.com/photos/15286/pexels-photo.jpg?auto=compress&cs=tinysrgb&w=1600"),
  CategoryItem("Winter",
      "https://images.pexels.com/photos/235621/pexels-photo-235621.jpeg?auto=compress&cs=tinysrgb&w=1600"),
  CategoryItem("Food",
      "https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=1600"),
  CategoryItem("Sky",
      "https://images.pexels.com/photos/2114014/pexels-photo-2114014.jpeg?auto=compress&cs=tinysrgb&w=1600"),
  CategoryItem("Animal",
      "https://images.pexels.com/photos/247502/pexels-photo-247502.jpeg?auto=compress&cs=tinysrgb&w=1600"),
  CategoryItem("Texture",
      "https://images.pexels.com/photos/1629236/pexels-photo-1629236.jpeg?auto=compress&cs=tinysrgb&w=1600"),
  CategoryItem("Technology",
      "https://images.pexels.com/photos/3861969/pexels-photo-3861969.jpeg?auto=compress&cs=tinysrgb&w=1600"),
  CategoryItem("Dog",
      "https://images.pexels.com/photos/1108099/pexels-photo-1108099.jpeg?auto=compress&cs=tinysrgb&w=1600"),
  CategoryItem("Cat",
      "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?auto=compress&cs=tinysrgb&w=1600"),
  CategoryItem("Car",
      "https://images.pexels.com/photos/1545743/pexels-photo-1545743.jpeg?auto=compress&cs=tinysrgb&w=1600"),
];

class DiscoverScreen extends StatefulWidget {
  @override
  _DiscoverScreen createState() => _DiscoverScreen();
}

class _DiscoverScreen extends State<DiscoverScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.7,
                  aspectRatio: 3,
                  initialPage: 0,
                ),
                items: bannerList.map((item) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(16)),
                                child: Image.network(
                                  item.imageUrl,
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: const BoxDecoration(
                                    color: Colors.black45,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(16))),
                              ),
                              Center(
                                  child: Text(
                                item.name,
                                style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                        color: Colors.white, fontSize: 25)),
                              ))
                            ],
                          ));
                    },
                  );
                }).toList(),
              ).fadeAnimation(0.2),
              const SizedBox(height: 30),
              SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: const Divider(color: Colors.black45))
                  .fadeAnimation(0.3),
              Text(
                "Popular Categories",
                style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600)),
              ).fadeAnimation(0.4),
              SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: const Divider(color: Colors.black45))
                  .fadeAnimation(0.5),
              Container(
                margin: const EdgeInsets.all(12),
                child: StaggeredGridView.countBuilder(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    itemCount: bannerList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => {},
                        child: Hero(
                          tag: "imageItem$index",
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.transparent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(16)),
                                  child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: bannerList[index].imageUrl,
                                    fit: BoxFit.cover,
                                    height: double.infinity,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: const BoxDecoration(
                                      color: Colors.black45,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16))),
                                ),
                                Center(
                                    child: Text(
                                  bannerList[index].name,
                                  style: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 25)),
                                ))
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    staggeredTileBuilder: (index) {
                      return StaggeredTile.count(
                          1, index.isEven ? 1.2 : 1.8);
                    }),
              ).fadeAnimation(0.6)
            ],
          ),
        ));
  }
}
