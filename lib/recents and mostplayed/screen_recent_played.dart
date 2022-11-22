import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muzik_hub/screen_main.dart';
import 'package:muzik_hub/screen_nowplaying.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../Screen_drawer.dart';
import '../database/box_instance.dart';
import '../screen_all_songs.dart';
import '../songs_cotroller/audio_controller.dart';
import '../songs_cotroller/list_allsongs.dart';
import 'mostplayed.dart';
import 'recents.dart';

class RecentPlayed extends StatefulWidget {
  const RecentPlayed({super.key});

  @override
  State<RecentPlayed> createState() => _RecentPlayedState();
}

class _RecentPlayedState extends State<RecentPlayed> {
  final _box = Boxes.getInstance();
  final recent = ValueNotifier([]);
  final _audioController = AudioController();
  List<Audio> songList = [];
  final _allSongsController = Get.put(AllSongsController());
  @override
  Widget build(BuildContext context) {
    List keys = _box.keys.toList();
    if (keys.where((element) => element == "recent").isNotEmpty) {
      recent.value = _box.get("recent");
    }
    if (keys.where((element) => element == "mostplayed").isNotEmpty) {
      mostplayed.value = _box.get("mostplayed");
    }
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : Colors.black,
      appBar: appBar2(context),
      drawer: const DrawerScreen(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Container(
                  height: 50,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Recently Played',
                    style: headdingText,
                  )),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: recent,
                builder: (context, List<dynamic> newrecent, child) {
                  return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: newrecent.length,
                      itemBuilder: (BuildContext context, int index) {
                        return recentTile(context, newrecent, index);
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  recentTile(BuildContext context, List newrecent, int index) {
    deviceheight = MediaQuery.of(context).size.height;
    return ListTile(
      onTap: () async {
        songList = _audioController.converterToAudio(newrecent);
        await _audioController.openToPlayingScreen(songList, index);
        addSongstoRecents(index, _allSongsController.hiveList, recent);
        addSongstoMostPlayed(index, _allSongsController.hiveList, mostplayed);
        ispressedrepeat = false;
        isPressed = true;
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const ScreenNowplaying(),
        ));
      },
      visualDensity: const VisualDensity(vertical: -3),
      leading: SizedBox(
        width: devicewidth * 0.11,
        height: deviceheight * 0.05,
        child: QueryArtworkWidget(
            artworkBorder: BorderRadius.circular(2),
            id: recent.value[index].id,
            type: ArtworkType.AUDIO,
            nullArtworkWidget: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: Image(
                  image: Theme.of(context).brightness == Brightness.light
                      ? AssetImage("assets/images/songi.png")
                      : AssetImage("assets/images/songidark.png"),
                ))),
      ),
      title: Text(
        newrecent[index].title,
        style: songTitle,
        maxLines: 1,
      ),
      subtitle: Text(
        newrecent[index].artist,
        style: songSubtitle,
        maxLines: 1,
      ),
    );
  }
}
