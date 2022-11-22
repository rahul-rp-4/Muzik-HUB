import 'package:flutter/material.dart';
import 'package:muzik_hub/screen_main.dart';
import 'package:video_player/video_player.dart';

class ScreenSplashLight extends StatefulWidget {
  const ScreenSplashLight({super.key});

  @override
  State<ScreenSplashLight> createState() => _ScreenSplashLightState();
}

class _ScreenSplashLightState extends State<ScreenSplashLight> {
  VideoPlayerController controller =
      VideoPlayerController.asset("assets/videos/MuzikHub.mp4");
  @override
  void initState() {
    delay();
    super.initState();
    controller = VideoPlayerController.asset("assets/videos/MuzikHub.mp4")
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
    await Future.delayed(const Duration(milliseconds: 2100));

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => const ScreenMain()));
  }
}
