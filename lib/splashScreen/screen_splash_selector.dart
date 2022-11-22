import 'package:flutter/material.dart';
import 'package:muzik_hub/splashScreen/screen_splash_dark.dart';
import 'package:muzik_hub/splashScreen/screen_splash_light.dart';

class ScreenSplashSelector extends StatefulWidget {
  const ScreenSplashSelector({super.key});

  @override
  State<ScreenSplashSelector> createState() => _ScreenSplashSelectorState();
}

class _ScreenSplashSelectorState extends State<ScreenSplashSelector> {
  @override
  Widget build(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const ScreenSplashDark()
        : const ScreenSplashLight();
  }
}
