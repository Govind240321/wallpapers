import 'dart:async';

import 'package:card_swiper/card_swiper.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:wallpapers/ui/controller/videos_controller.dart';

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
              return YoutubeVideoContentScreen(
                src: videosController.videosList[index].videoId,
              );
            },
            itemCount: videosController.videosList.length,
            scrollDirection: Axis.vertical,
          ));
  }
}

class YoutubeVideoContentScreen extends StatefulWidget {
  final String? src;

  const YoutubeVideoContentScreen({Key? key, this.src}) : super(key: key);

  @override
  State<YoutubeVideoContentScreen> createState() =>
      _YoutubeVideoContentScreenState();
}

class _YoutubeVideoContentScreenState extends State<YoutubeVideoContentScreen> {
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
    _chewieController!.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text('Loading...')
                  ],
                ),
              ),
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
