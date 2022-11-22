import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muzik_hub/screen_all_songs.dart';
import 'package:muzik_hub/screen_main.dart';
import 'package:muzik_hub/screen_nowplaying.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../database/box_instance.dart';
import '../database/songs_adapter.dart';
import '../recents and mostplayed/mostplayed.dart';
import '../recents and mostplayed/recents.dart';
import '../songs_cotroller/audio_controller.dart';
import '../songs_cotroller/list_allsongs.dart';

class ScreenPlaylistSongs extends StatefulWidget {
  String titlePlaylist;
  ScreenPlaylistSongs({Key? key, required this.titlePlaylist})
      : super(key: key);

  @override
  State<ScreenPlaylistSongs> createState() => _ScreenPlaylistSongsState();
}

class _ScreenPlaylistSongsState extends State<ScreenPlaylistSongs> {
  final _allSongsController = Get.put(AllSongsController());
  final _box = Boxes.getInstance();
  final _audioController = AudioController();
  ValueNotifier<List<AllSongsModel>> allSongs =
      ValueNotifier(<AllSongsModel>[]);
  final list = ValueNotifier([]);
  List<Audio> songList = [];
  @override
  Widget build(BuildContext context) {
    List keys = _box.keys.toList();
    if (keys.where((element) => element == "recent").isNotEmpty) {
      recent.value = _box.get("recent");
    }
    if (keys.where((element) => element == "mostplayed").isNotEmpty) {
      mostplayed.value = _box.get("mostplayed");
    }
    List allList = _box.get("allSongs");
    allSongs.value = allList.cast<AllSongsModel>();
    list.value = _box.get(widget.titlePlaylist);
    deviceheight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.black,
        appBar: appBar2(context),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 10, right: 10),
              child: Container(
                  height: deviceheight * 0.05,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.titlePlaylist.toUpperCase(),
                        style: headdingText,
                      ),
                      IconButton(
                          onPressed: () {
                            showModalBottomSheet<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return addsong(context);
                                });
                          },
                          icon: const Icon(
                            Icons.add,
                            size: 20,
                          ))
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, top: 10, right: 20, bottom: 10),
              child: Container(
                  height: deviceheight * 0.78,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).brightness == Brightness.light
                        ? layer2
                        : layer2D,
                  ),
                  // child: allSongs.value.isNotEmpty
                  child: list.value.isNotEmpty
                      ? ValueListenableBuilder(
                          valueListenable: list,
                          builder:
                              (BuildContext context, List newPlalistSongs, _) {
                            List newPlaylist = newPlalistSongs.toList();
                            return Padding(
                              padding: const EdgeInsets.all(15),
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    onTap: () async {
                                      songList = _audioController
                                          .converterToAudio(newPlaylist);
                                      await _audioController
                                          .openToPlayingScreen(songList, index);
                                      addSongstoRecents(index,
                                          _allSongsController.hiveList, recent);
                                      addSongstoMostPlayed(
                                          index,
                                          _allSongsController.hiveList,
                                          mostplayed);
                                      ispressedshuffle = false;
                                      ispressedrepeat = false;
                                      isPressed = true;
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ScreenNowplaying()));
                                    },
                                    leading: Hero(
                                      tag: index,
                                      child: SizedBox(
                                        width: devicewidth * 0.1,
                                        height: deviceheight * 0.045,
                                        child: QueryArtworkWidget(
                                          artworkBorder:
                                              BorderRadius.circular(0),
                                          id: newPlaylist[index].id,
                                          type: ArtworkType.AUDIO,
                                          nullArtworkWidget: Image(
                                            image: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.light
                                                ? AssetImage(
                                                    "assets/images/songi.png")
                                                : AssetImage(
                                                    "assets/images/songidark.png"),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      newPlaylist[index].title,
                                      maxLines: 2,
                                      style: songTitle,
                                    ),
                                    subtitle: Text(
                                      newPlaylist[index].artist,
                                      style: songSubtitle,
                                      maxLines: 1,
                                    ),
                                    trailing: IconButton(
                                        onPressed: () async {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                deleteFromPlaylist(index),
                                          );
                                        },
                                        icon: Icon(Icons.delete)),
                                  );
                                },
                                itemCount: newPlaylist.length,
                              ),
                            );
                          },
                        )
                      : ValueListenableBuilder(
                          valueListenable: list,
                          builder:
                              (BuildContext context, List newPlalistSongs, _) {
                            return Center(
                              child: Text(
                                "No Songs Added.",
                              ),
                            );
                          },
                        )),
            ),
            SizedBox(
              height: deviceheight * 0.01,
            )
          ],
        ));
  }

  addsong(BuildContext context) {
    return Container(
      color: Theme.of(context).brightness == Brightness.light
          ? layer1
          : appbarColorD,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ValueListenableBuilder(
          valueListenable: allSongs,
          builder: (BuildContext context, List allSongsList, _) {
            return ListView.builder(
                itemBuilder: (context, index) {
                  return songs(context, allSongsList, index);
                },
                itemCount: allSongsList.length);
          },
        ),
      ),
    );
  }

  songs(BuildContext context, List newList, int index) {
    deviceheight = MediaQuery.of(context).size.height;
    devicewidth = MediaQuery.of(context).size.width;

    return ListTile(
      visualDensity: VisualDensity(vertical: -3),
      leading: Hero(
          tag: index,
          child: SizedBox(
            width: devicewidth * 0.11,
            height: deviceheight * 0.055,
            child: QueryArtworkWidget(
              artworkBorder: BorderRadius.circular(0),
              id: newList[index].id,
              type: ArtworkType.AUDIO,
              nullArtworkWidget: Image(
                image: Theme.of(context).brightness == Brightness.light
                    ? AssetImage("assets/images/songi.png")
                    : AssetImage("assets/images/songidark.png"),
                fit: BoxFit.cover,
              ),
            ),
          )),
      title: Text(newList[index].title, maxLines: 1, style: songTitle),
      subtitle: Text(
        newList[index].artist.toString(),
        style: songSubtitle,
      ),
      trailing: ValueListenableBuilder(
        valueListenable: list,
        builder: (BuildContext context, List playlistSongs, _) {
          return list.value
                  .where((element) => element.id == allSongs.value[index].id)
                  .isEmpty
              ? IconButton(
                  onPressed: () async {
                    list.value.add(newList[index]);
                    await _box.put(widget.titlePlaylist, list.value);
                    setState(() {
                      list.notifyListeners();
                    });
                    // list.notifyListeners();
                  },
                  icon: Icon(Icons.add))
              : IconButton(
                  onPressed: () async {
                    list.value.removeWhere((element) =>
                        element.id.toString() ==
                        allSongs.value[index].id.toString());
                    await _box.put(widget.titlePlaylist, list.value);
                    setState(() {
                      list.notifyListeners();
                    });
                    // list.notifyListeners();
                  },
                  icon: Icon(Icons.remove));
        },
      ),
    );
  }

  deleteFromPlaylist(int index) {
    return SimpleDialog(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : layer2D,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 10, top: 10),
              child: Text(
                'Delete This Song ?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Center(
                    child: Text("Cancel",
                        style: TextStyle(
                            fontSize: 18,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white)),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    list.value.remove(list.value[index]);
                    await _box.put(widget.titlePlaylist, list.value);
                    setState(() {
                      list.notifyListeners();
                    });
                    // list.notifyListeners();
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10), color: layer2),
                    height: 40,
                    width: 100,
                    child: Center(
                      child: Text("Delete",
                          style: TextStyle(fontSize: 18, color: Colors.black)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
