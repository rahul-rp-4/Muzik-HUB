import 'package:flutter/material.dart';
import 'package:muzik_hub/screen_main.dart';
import 'package:video_player/video_player.dart';

class ScreenSplashDark extends StatefulWidget {
  const ScreenSplashDark({super.key});

  @override
  State<ScreenSplashDark> createState() => _ScreenSplashDarkState();
}

class _ScreenSplashDarkState extends State<ScreenSplashDark> {
  VideoPlayerController controller =
      VideoPlayerController.asset("assets/videos/MuzikHub_Dark.mp4");
  @override
  void initState() {
    delay();
    super.initState();
    controller = VideoPlayerController.asset("assets/videos/MuzikHub_Dark.mp4")
      ..initialize().then((_) {
        controller.play();
        controller.setLooping(false);
        setState(() {});
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
            width: controller.value.size.width,
            height: controller.value.size.height,
            child: VideoPlayer(controller)),
      ),
    ));
  }

  Future<void> delay() async {
    await Future.delayed(const Duration(milliseconds: 2200));

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => const ScreenMain()));
  }
}
