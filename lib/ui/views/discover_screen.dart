
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DiscoverScreen extends StatefulWidget{

  @override
  _DiscoverScreen createState() => _DiscoverScreen();
}

class _DiscoverScreen extends State<DiscoverScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: const Text("Discover Screen"));
  }
}