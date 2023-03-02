import 'dart:async';
import 'dart:io';

import 'package:card_swiper/card_swiper.dart';
import 'package:chewie/chewie.dart';
import 'package:flowder/flowder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_native_mobile_ads/google_native_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:video_player/video_player.dart';
import 'package:wallpapers/ui/constant/ads_id_constant.dart';
import 'package:wallpapers/ui/constant/api_constants.dart';
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
            onIndexChanged: (index) {
              if (index == (videosController.videosList.length - 3)) {
                videosController.mStart += ApiConstant.limit;
                videosController.getVideos();
              }
            },
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
  static const AdRequest request = AdRequest(
    nonPersonalizedAds: true,
  );

  int maxFailedLoadAttempts = 3;

  RewardedInterstitialAd? _rewardedInterstitialAd;
  int _numRewardedInterstitialLoadAttempts = 0;

  bool _isPlaying = true;
  bool _onTouch = false;
  Timer? _timer;

  late DownloaderUtils options;
  late DownloaderCore core;
  late final String path;
  bool permissionGranted = false;
  ProgressDialog? pr;

  @override
  void initState() {
    super.initState();
    initializePlayer();
    initPlatformState();
    _createRewardedInterstitialAd();
  }

  Future<void> initPlatformState() async {
    _setPath();
    if (!mounted) return;
  }

  void _setPath() async {
    path = Directory('/storage/emulated/0/Download').path;
  }

  Future<void> downloadButtonClicked() async {
    await pr?.show();
    options = DownloaderUtils(
      progressCallback: (current, total) {
        final progress = (current / total) * 100;
      },
      file: File('$path/${DateTime.now().millisecondsSinceEpoch}.mp4'),
      progress: ProgressImplementation(),
      onDone: () async {
        await pr?.hide();
        Dialogs.materialDialog(
            color: Colors.white,
            msg: 'File saved to this directory: $path',
            title: 'File Saved!',
            lottieBuilder: Lottie.asset(
              'assets/congratulations.json',
              fit: BoxFit.contain,
            ),
            titleStyle: GoogleFonts.openSansCondensed(
                fontWeight: FontWeight.bold, fontSize: 36),
            context: context,
            barrierDismissible: false,
            actions: [
              IconsButton(
                onPressed: () {
                  Get.back();
                },
                text: 'Dismiss',
                iconData: Icons.done,
                color: Colors.blue,
                textStyle: const TextStyle(color: Colors.white),
                iconColor: Colors.white,
              ),
            ]);
      },
      deleteOnCancel: true,
    );
    core = await Flowder.download(widget.src ?? "", options);
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

  void _createRewardedInterstitialAd() {
    RewardedInterstitialAd.load(
        adUnitId: AdsConstant.REWARED_INTERSTITIAL_ID,
        request: request,
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (RewardedInterstitialAd ad) {
            print('$ad loaded.');
            _rewardedInterstitialAd = ad;
            _numRewardedInterstitialLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedInterstitialAd failed to load: $error');
            _rewardedInterstitialAd = null;
            _numRewardedInterstitialLoadAttempts += 1;
            if (_numRewardedInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createRewardedInterstitialAd();
            }
          },
        ));
  }

  void _showRewardedInterstitialAd() {
    if (_rewardedInterstitialAd == null) {
      print('Warning: attempt to show rewarded interstitial before loaded.');
      return;
    }
    _rewardedInterstitialAd!.fullScreenContentCallback =
        FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedInterstitialAd ad) =>
          print('$ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createRewardedInterstitialAd();
      },
      onAdFailedToShowFullScreenContent:
          (RewardedInterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createRewardedInterstitialAd();
      },
    );

    _rewardedInterstitialAd!.setImmersiveMode(true);
    _rewardedInterstitialAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      downloadButtonClicked();
    });
    _rewardedInterstitialAd = null;
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    _rewardedInterstitialAd?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future _getStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      setState(() {
        permissionGranted = true;
      });
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      setState(() {
        permissionGranted = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context,
        type: ProgressDialogType.download,
        isDismissible: false,
        showLogs: false);
    pr?.style(
        message: 'Downloading file...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: const CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0);

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
                image: widget.src!
                    .replaceAll(".mp4", ".jpg")
                    .replaceAll(".mov", ".jpg"),
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
                  onPressed: () {
                    _getStoragePermission().then((value) {
                      if (permissionGranted) {
                        _showRewardedInterstitialAd();
                      } else {
                        _getStoragePermission();
                      }
                    });
                  },
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
