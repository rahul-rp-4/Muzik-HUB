import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:muzik_hub/Screen_drawer.dart';
import 'package:muzik_hub/playlist/create_playlist.dart';
import 'package:muzik_hub/recents%20and%20mostplayed/recents.dart';
import 'package:muzik_hub/screen_favorites.dart';
import 'package:muzik_hub/screen_main.dart';
import 'package:muzik_hub/screen_nowplaying.dart';
import 'package:muzik_hub/playlist/screen_playlists.dart';
import 'package:muzik_hub/screen_search.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'database/box_instance.dart';
import 'database/songs_adapter.dart';
import 'playlist/playlist_songs.dart';
import 'playlist/songs_add_to playlist.dart';
import 'recents and mostplayed/mostplayed.dart';
import 'songs_cotroller/audio_controller.dart';
import 'songs_cotroller/list_allsongs.dart';

bool isPressed = true;
bool ispressedshuffle = false;
bool ispressedrepeat = false;
bool bottomplayon = false;
double deviceheight = 0;
double devicewidth = 0;
final recent = ValueNotifier([]);
final mostplayed = ValueNotifier([]);

AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer.withId("0");

previousSong() async {
  await assetsAudioPlayer.previous();
}

nextSong() async {
  await assetsAudioPlayer.next();
}

// appbar 1
appbar1(context) {
  context = context;
  return AppBar(
    centerTitle: true,
    title: Text(
      'MUZIK HUB',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
    ),
    actions: [
      IconButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const ScreenSearch()),
          );
        },
        icon: Icon(Icons.search_rounded),
        iconSize: 28,
      )
    ],
    backgroundColor: Theme.of(context).brightness == Brightness.light
        ? Colors.white
        : Colors.black,
    foregroundColor: Theme.of(context).brightness == Brightness.light
        ? Colors.black
        : Colors.white,
    elevation: 0,
  );
}

appBar2(context) {
  context = context;
  return AppBar(
    centerTitle: true,
    title: Text(
      'MUZIK HUB',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
    ),
    backgroundColor: Theme.of(context).brightness == Brightness.light
        ? Colors.white
        : Colors.black,
    foregroundColor: Theme.of(context).brightness == Brightness.light
        ? Colors.black
        : Colors.white,
    elevation: 0,
  );
}

// --------------------------main page-------------------------

class AllSongs extends StatefulWidget {
  const AllSongs({Key? key}) : super(key: key);

  @override
  State<AllSongs> createState() => _AllSongsState();
}

class _AllSongsState extends State<AllSongs> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission();
    //
  }

  void requestPermission() {
    Permission.storage.request();
  }

// audios
  final AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer.withId("0");
  final OnAudioQuery onAudioQuery = OnAudioQuery();
  final playlist = ValueNotifier([]);
  final allSongsController = AllSongsController();
  final _audioController = AudioController();
  final box = Boxes.getInstance();
  List<Audio> songList = [];
  final allSongs = ValueNotifier(<AllSongsModel>[]);
  final favorites = ValueNotifier([]);
  var isLoading = ValueNotifier(true);
  final _allSongsController = Get.put(AllSongsController());

  List<AllSongsModel> allSongslist = [];
  List allPlaylist = [];

// end
  @override
  Widget build(BuildContext context) {
    List allList = box.get("allSongs");
    deviceheight = MediaQuery.of(context).size.height;
    devicewidth = MediaQuery.of(context).size.width;
    allSongslist = allList.cast<AllSongsModel>();
    isLoading.value = false;
    List _keys = box.keys.toList();
    if (_keys.where((element) => element == "allSongs").isNotEmpty) {
      List list = box.get("allSongs");
      allSongs.value = list.cast<AllSongsModel>();
    }
    if (_keys.where((element) => element == "fav").isNotEmpty) {
      favorites.value = box.get("fav");
    }
    if (_keys.where((element) => element == "recent").isNotEmpty) {
      recent.value = box.get("recent");
    }
    if (_keys.where((element) => element == "mostplayed").isNotEmpty) {
      mostplayed.value = box.get("mostplayed");
    }

    return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.black,
        appBar: appbar1(context),
        drawer: DrawerScreen(),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Container(
                    height: deviceheight * 0.045,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your Playlists',
                          style: headdingText,
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => ScreenPlaylists()));
                            },
                            icon: Icon(Icons.arrow_forward_ios_outlined))
                      ],
                    )),
              ),
              SizedBox(
                height: deviceheight * 0.06,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => ScreenFavorites()));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? layer2
                                  : layer2D,
                              borderRadius: BorderRadius.circular(10)),
                          height: deviceheight * 0.06,
                          width: devicewidth * 0.45,
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                              Text(
                                'Favorites',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              )
                            ],
                          )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (ctx) => CreatePlaylist());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? layer2
                                  : layer2D,
                              borderRadius: BorderRadius.circular(10)),
                          height: deviceheight * 0.06,
                          width: devicewidth * 0.45,
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                              ),
                              Text(
                                'New Playlist',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              )
                            ],
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: deviceheight * 0.009,
              ),
              //  playlists
              ValueListenableBuilder(
                  valueListenable: box.listenable(),
                  builder: (BuildContext context, Box newPlayList, _) {
                    final allkeys = box.keys.toList();
                    allkeys.remove("allSongs");
                    allkeys.remove("fav");
                    allkeys.remove("recent");
                    allkeys.remove("mostplayed");
                    allPlaylist = allkeys.toList();
                    return allPlaylist.isNotEmpty
                        ? SizedBox(
                            height: deviceheight * 0.05,
                            child: Padding(
                              padding:
                                  EdgeInsets.only(left: 10, top: 0, right: 0),
                              child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent:
                                              deviceheight * 0.06,
                                          mainAxisExtent: deviceheight * 0.108),
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (
                                    context,
                                    index,
                                  ) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? layer2
                                              : layer2D,
                                        ),
                                        child: InkWell(
                                          onTap: () async {
                                            await Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  ScreenPlaylistSongs(
                                                      titlePlaylist:
                                                          allPlaylist[index]),
                                            ));
                                          },
                                          child: GridTile(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.light
                                                      ? layer2
                                                      : layer2D,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Center(
                                                  child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.queue_music_outlined,
                                                  ),
                                                  Text(
                                                    allPlaylist[index]
                                                        .toString()
                                                        .toUpperCase(),
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12),
                                                  )
                                                ],
                                              )),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: allPlaylist.length),
                            ),
                          )
                        : Container();
                  }),
              //  playlist
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Container(
                    height: deviceheight * 0.045,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Songs',
                      style: headdingText,
                    )),
              ),
              Expanded(
                child: GetBuilder<AllSongsController>(
                    id: "home",
                    builder: (_) {
                      print('object');
                      return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return listtile(
                                context, _allSongsController.hiveList, index);
                          },
                          itemCount: _allSongsController.hiveList.length);
                    }),
              ),
            ],
          ),
        ));
  }

  Widget listtile(
    BuildContext context,
    List<AllSongsModel> newList,
    int index,
  ) {
    deviceheight = MediaQuery.of(context).size.height;
    devicewidth = MediaQuery.of(context).size.width;
    return ListTile(
      visualDensity: VisualDensity(vertical: -3),
      leading: Hero(
        tag: index,
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                  ? layer2
                  : layer2D),
          width: 45,
          height: 45,
          // width: devicewidth * 0.11,
          // height: deviceheight * 0.055,
          child: QueryArtworkWidget(
            artworkBorder: BorderRadius.circular(2),
            artworkHeight: deviceheight * 0.055,
            artworkWidth: deviceheight * 0.055,
            id: newList[index].id,
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
        newList[index].title,
        maxLines: 1,
        style: songTitle,
      ),
      subtitle: Text(
        newList[index].artist.toString(),
        maxLines: 1,
        style: songSubtitle,
      ),
      trailing: PopupMenuButton(
        icon: Icon(Icons.more_vert_outlined),
        itemBuilder: (context) => [
          PopupMenuItem(
            child: ValueListenableBuilder(
                valueListenable: favorites,
                builder: (context, List<dynamic> newHive, _) {
                  return favorites.value
                          .where((element) =>
                              element.id.toString() ==
                              newList[index].id.toString())
                          .isEmpty
                      ? Center(
                          child: IconButton(
                            icon: Icon(Icons.favorite_border_outlined),
                            onPressed: () async {
                              favorites.value.add(newList[index]);
                              await box.put("fav", favorites.value);
                              favorites.notifyListeners();
                              Navigator.of(context).pop();
                            },
                          ),
                        )
                      : Center(
                          child: IconButton(
                            onPressed: () async {
                              favorites.value.removeWhere((element) =>
                                  element.id.toString() ==
                                  newList[index].id.toString());
                              await box.put("fav", favorites.value);
                              favorites.notifyListeners();
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.favorite, color: Colors.red),
                          ),
                        );
                }),
          ),
          PopupMenuItem(
              child: Center(
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return ScreenSongsAddToPlaylist(index: index);
                      });
                },
                icon: Icon(Icons.playlist_add)),
          ))
        ],
      ),
      onTap: () async {
        bottomplayon = true;
        try {
          songList = _audioController.converterToAudio(newList);
          await _audioController.openToPlayingScreen(songList, index);
          addSongstoRecents(index, newList, recent);
          addSongstoMostPlayed(index, newList, mostplayed);
          isPressed = true;
          ispressedrepeat = false;

          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const ScreenNowplaying()),
          );
        } catch (err) {
          bottomplayon = false;
          await Get.defaultDialog(
              backgroundColor: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : layer2D,
              content: const Text(
                'Error Playing song !!',
              ),
              cancel: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                    ),
                  )));
        }
      },
    );
  }
}
