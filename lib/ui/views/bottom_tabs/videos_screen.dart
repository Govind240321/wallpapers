import 'dart:async';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallpapers/ui/controller/videos_controller.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({Key? key}) : super(key: key);

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  final List<String> ids = [
    'f-4bH_tkwlI',
    'VCD7JnZw0K4',
    'lX_7LUMgfl8',
    'xtg6gvBYrVM',
    'to3GWu2ptvk'
  ];
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
  late YoutubePlayerController _controller;

  bool _isPlayerReady = false;
  bool _isPlaying = true;
  bool _onTouch = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.src!,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: true,
        isLive: false,
        forceHD: false,
        hideControls: true,
        enableCaption: false,
      ),
    );
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {});
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _onTouch = !_onTouch;
            });
          },
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: YoutubePlayer(
              controller: _controller,
              aspectRatio: 16 / 9,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.blueAccent,
              onReady: () {
                _isPlayerReady = true;
              },
              onEnded: (data) {},
            ),
          ),
        ), // Add a play or pause button overlay
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
                  _isPlaying ? _controller.pause() : _controller.play();

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
