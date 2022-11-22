import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muzik_hub/screen_all_songs.dart';
import 'package:muzik_hub/songs_cotroller/list_allsongs.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'database/box_instance.dart';
import 'database/songs_adapter.dart';
import 'recents and mostplayed/mostplayed.dart';
import 'recents and mostplayed/recents.dart';
import 'screen_main.dart';
import 'screen_nowplaying.dart';
import 'songs_cotroller/audio_controller.dart';

class ScreenSearch extends StatefulWidget {
  const ScreenSearch({super.key});

  @override
  State<ScreenSearch> createState() => _ScreenSearchState();
}

class _ScreenSearchState extends State<ScreenSearch> {
  final _allSongsController = Get.put(AllSongsController());
  List<Audio> songList = [];
  final _audioController = AudioController();

  final myBox = Boxes.getInstance();
  var search = ValueNotifier([]);
  List<AllSongsModel> allSongs = [];

  @override
  Widget build(BuildContext context) {
    List keys = myBox.keys.toList();
    if (keys.where((element) => element == "recent").isNotEmpty) {
      recent.value = myBox.get("recent");
    }
    if (keys.where((element) => element == "mostplayed").isNotEmpty) {
      mostplayed.value = myBox.get("mostplayed");
    }
    List list = myBox.get("allSongs");
    allSongs = list.cast<AllSongsModel>();
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : Colors.black,
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.black,
        foregroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.black
            : Colors.white,
        elevation: 0,
        centerTitle: true,
        title: TextFormField(
          onChanged: (value) {
            _allSongsController.searchItem = value;
            _allSongsController.update(["search"]);
          },
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
            ),
            hintText: "Songs",
            filled: true,
            // focusColor: Color.fromARGB(255, 214, 0, 0),
            enabled: true,
            fillColor: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Colors.black,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: const BorderSide(
                width: 0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: const BorderSide(
                  width: 0, color: Color.fromARGB(0, 244, 67, 54)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide:
                  const BorderSide(width: 0, color: Color.fromARGB(0, 0, 0, 0)),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: GetBuilder<AllSongsController>(
            id: "search",
            builder: (_) {
              search.value = _allSongsController.searchItem.isEmpty
                  ? allSongs
                  : allSongs
                      .where((element) => element.title.toLowerCase().contains(
                          _allSongsController.searchItem.toLowerCase()))
                      .toList();
              return search.value.isNotEmpty
                  ? ListView.separated(
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final result = search.value.cast<AllSongsModel>();
                        return showBanner(context, result, index);
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 10,
                        );
                      },
                      itemCount: search.value.length,
                    )
                  : Center(
                      child: Text('No songs available'),
                    );
            }),
      ),
    );
  }

  Widget showBanner(
      BuildContext context, List<AllSongsModel> result, int index) {
    return ListTile(
      leading: Hero(
        tag: index,
        child: Container(
          decoration: BoxDecoration(color: layer2),
          width: 45,
          height: 45,
          child: QueryArtworkWidget(
            artworkBorder: BorderRadius.circular(2),
            artworkHeight: 50,
            artworkWidth: 50,
            id: result[index].id,
            type: ArtworkType.AUDIO,
            nullArtworkWidget: Image(
              image: Theme.of(context).brightness == Brightness.light
                  ? AssetImage("assets/images/songi.png")
                  : AssetImage("assets/images/songidark.png"),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
      title: Text(
        result[index].title,
        maxLines: 1,
        style: songTitle,
      ),
      subtitle: Text(
        result[index].artist.toString(),
        maxLines: 1,
        style: songSubtitle,
      ),
      onTap: () async {
        var indx =
            allSongs.indexWhere((element) => element.id == result[index].id);
        songList = _audioController.converterToAudio(allSongs);
        await _audioController.openToPlayingScreen(songList, indx);
        addSongstoRecents(index, _allSongsController.hiveList, recent);
        addSongstoMostPlayed(index, _allSongsController.hiveList, mostplayed);
        isPressed = true;
        ispressedshuffle = false;
        ispressedrepeat = false;
        await Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ScreenNowplaying()));
      },
    );
  }
}
