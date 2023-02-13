import 'dart:async';

import 'package:card_swiper/card_swiper.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_native_mobile_ads/google_native_mobile_ads.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:video_player/video_player.dart';
import 'package:wallpapers/ui/constant/ads_id_constant.dart';
import 'package:wallpapers/ui/controller/videos_controller.dart';

import '../components/get_ad_widget.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({Key? key}) : super(key: key);

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  VideosController videosController = Get.put(VideosController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => videosController.isDataLoading.value
        ? Container(color: Colors.white)
        : Swiper(
            loop: false,
            itemBuilder: (BuildContext context, int index) {
              var item = videosController.videosList[index];
              return item.type == "ad"
                  ? const FullScreenNativeAdScreen()
                  : VideoContentScreen(
                      src: item.videoUrl,
                    );
            },
            itemCount: videosController.videosList.length,
            scrollDirection: Axis.vertical,
          ));
  }
}

class VideoContentScreen extends StatefulWidget {
  final String? src;

  const VideoContentScreen({Key? key, this.src}) : super(key: key);

  @override
  State<VideoContentScreen> createState() => _VideoContentScreenState();
}

class _VideoContentScreenState extends State<VideoContentScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  bool _isPlaying = true;
  bool _onTouch = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.src!);
    await Future.wait([_videoPlayerController.initialize()]);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      showControls: false,
      aspectRatio: 9 / 16,
      looping: true,
    );
    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          _chewieController != null &&
                  _chewieController!.videoPlayerController.value.isInitialized
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _onTouch = !_onTouch;
                    });
                  },
                  child: Chewie(
                    controller: _chewieController!,
                  ),
                )
              : Stack(
                  children: [
                    FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: widget.src!.replaceAll(".mp4", ".jpg"),
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                      alignment: Alignment.center,
                    ),
                    const Center(child: CircularProgressIndicator())
                  ],
                ),
          Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                  onPressed: () {},
                  child: const Icon(
                    Icons.downloading_sharp,
                    size: 35,
                  ))),
          // Add a play or pause button overlay
          Visibility(
            visible: _onTouch,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _onTouch = !_onTouch;
                });
                resetTimer();
              },
              child: Container(
                color: Colors.black.withOpacity(0.5),
                alignment: Alignment.center,
                child: TextButton(
                  child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white, size: 50),
                  onPressed: () {
                    _isPlaying
                        ? _videoPlayerController.pause()
                        : _videoPlayerController.play();

                    // pause while video is playing, play while video is pausing
                    setState(() {
                      _isPlaying = !_isPlaying;
                    });
                    // Auto dismiss overlay after 1 second
                    resetTimer();
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void resetTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 3000), (_) {
      setState(() {
        _onTouch = false;
      });
    });
  }
}

class FullScreenNativeAdScreen extends StatefulWidget {
  const FullScreenNativeAdScreen({Key? key}) : super(key: key);

  @override
  State<FullScreenNativeAdScreen> createState() =>
      _FullScreenNativeAdScreenState();
}

class _FullScreenNativeAdScreenState extends State<FullScreenNativeAdScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Sponsored',
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GetNativeAdWidget(
        adUnitId: AdsConstant.NATIVE_ADVANCED,
        customOptions:
            NativeAdCustomOptions.defaultConfig(NativeAdSize.fullScreen).toMap,
      ),
    );
  }
}
