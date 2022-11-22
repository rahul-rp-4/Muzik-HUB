import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:muzik_hub/themes/theme_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'database/songs_adapter.dart';
import 'songs_cotroller/notification.dart';
import 'splashScreen/screen_splash_selector.dart';
import 'songs_cotroller/list_allsongs.dart';

void main() async {
  await Hive.initFlutter();
  await NotificationUser.init();
  Hive.registerAdapter(AllSongsModelAdapter());
  await Hive.openBox("songs");
  final OnAudioQuery onAudioQuery = OnAudioQuery();
  final allSongsController = AllSongsController();
  try {
    if (!kIsWeb) {
      bool permissionStatus = await onAudioQuery.permissionsStatus();
      if (!permissionStatus) {
        await allSongsController.fetchDatas();
        await onAudioQuery.permissionsRequest();
      }
    }
  } catch (e) {
    const CircularProgressIndicator();
  }
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(ChangeNotifierProvider<ThemeProvider>(
      create: (context) => ThemeProvider()..initialize(),
      child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, provider, child) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: provider.themeMode,
        home: const ScreenSplashSelector(),
      );
    });
  }
}
