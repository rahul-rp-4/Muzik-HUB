import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:muzik_hub/screen_all_songs.dart';
import 'package:muzik_hub/screen_main.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'database/box_instance.dart';
import 'screen_nowplaying.dart';
import 'songs_cotroller/audio_controller.dart';

class ScreenFavorites extends StatefulWidget {
  const ScreenFavorites({super.key});
  @override
  State<ScreenFavorites> createState() => _ScreenFavoritesState();
}

class _ScreenFavoritesState extends State<ScreenFavorites> {
  final _box = Boxes.getInstance();
  final favorites = ValueNotifier([]);
  final _audioController = AudioController();
  List<Audio> songList = [];
  @override
  Widget build(BuildContext context) {
    deviceheight = MediaQuery.of(context).size.height;
    List keys = _box.keys.toList();
    if (keys.where((element) => element == "fav").isNotEmpty) {
      favorites.value = _box.get("fav");
    }
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10, right: 10),
            child: Container(
                height: deviceheight * 0.05,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Favorites',
                  style: headdingText,
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, top: 0, right: 20, bottom: 10),
            child: Container(
                height: deviceheight * 0.78,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).brightness == Brightness.light
                      ? layer2
                      : layer2D,
                ),
                child: favorites.value.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ValueListenableBuilder(
                          valueListenable: favorites,
                          builder: (BuildContext context,
                              List<dynamic> newFavourites, _) {
                            return ListView.separated(
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) =>
                                    tile(context, newFavourites, index),
                                separatorBuilder: (ctx, indx) => SizedBox(
                                      height: 0,
                                    ),
                                itemCount: newFavourites.length);
                          },
                        ),
                      )
                    : ValueListenableBuilder(
                        valueListenable: favorites,
                        builder: (BuildContext context, List<dynamic> list, _) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "No Favorites Songs Added.",
                                )
                              ],
                            ),
                          );
                        },
                      )),
          ),
          SizedBox(
            height: deviceheight * 0.01,
          )
        ],
      ),
    );
  }

  tile(BuildContext context, List newFavourites, int index) {
    deviceheight = MediaQuery.of(context).size.height;
    return ListTile(
      onTap: () async {
        songList = _audioController.converterToAudio(newFavourites);
        await _audioController.openToPlayingScreen(songList, index);
        isPressed = true;
        ispressedshuffle = false;
        ispressedrepeat = false;
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ScreenNowplaying(),
        ));
      },
      leading: SizedBox(
        width: devicewidth * 0.1,
        height: deviceheight * 0.045,
        child: QueryArtworkWidget(
            artworkBorder: BorderRadius.circular(0),
            id: favorites.value[index].id,
            type: ArtworkType.AUDIO,
            nullArtworkWidget: ClipRRect(
              child: Image(
                image: Theme.of(context).brightness == Brightness.light
                    ? AssetImage("assets/images/songi.png")
                    : AssetImage("assets/images/songidark.png"),
              ),
            )),
      ),
      title: Text(
        newFavourites[index].title,
        maxLines: 2,
        style: songTitle,
      ),
      subtitle: Text(newFavourites[index].artist, style: songSubtitle),
      trailing: IconButton(
          tooltip: 'Remove',
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => SimpleDialog(
                insetPadding: const EdgeInsets.symmetric(horizontal: 90),
                backgroundColor:
                    Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : layer2D,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Center(
                      child: Text(
                        'Remove from favorites ? ',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: deviceheight * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                              ))),
                      TextButton(
                          onPressed: () async {
                            // remove from playlist function
                            setState(() {
                              favorites.value.removeWhere((element) =>
                                  element.id.toString() ==
                                  newFavourites[index].id.toString());
                              _box.put("fav", favorites.value);

                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                  width: 200,
                                  padding: EdgeInsets.all(15),
                                  content: Text('Removed from Favourites'),
                                ),
                              );
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: layer2),
                            height: deviceheight * 0.04,
                            width: deviceheight * 0.1,
                            child: const Center(
                              child: Text('Remove',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black)),
                            ),
                          ))
                    ],
                  )
                ],
              ),
            );
          },
          icon: const Icon(
            Icons.delete,
          )),
    );
  }
}
