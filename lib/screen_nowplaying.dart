import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:get/get.dart';
import 'package:muzik_hub/screen_all_songs.dart';
import 'package:muzik_hub/screen_main.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'database/box_instance.dart';
import 'database/songs_adapter.dart';
import 'playlist/songs_add_to playlist.dart';
import 'songs_cotroller/list_allsongs.dart';

bool ispressedprev = false;
bool ispressednxt = false;

// play pause
Offset distance = isPressed ? Offset(2.5, 2.5) : Offset(5, 5);
double blur = isPressed ? 2.5 : 10;
// previous next
Offset distancepre = Offset(2.5, 2.5);
double blurpre = 2.5;
Offset distancenxt = Offset(2.5, 2.5);
double blurnxt = 2.5;
// shuffle repeat
Offset distanceshfl = Offset(2.5, 2.5);
double blurshfl = 2.5;
Offset distancerpt = Offset(2.5, 2.5);
double blurrpt = 2.5;

class ScreenNowplaying extends StatefulWidget {
  const ScreenNowplaying({super.key});

  @override
  State<ScreenNowplaying> createState() => _ScreenNowplayingState();
}

class _ScreenNowplayingState extends State<ScreenNowplaying> {
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer.withId("0");
  var musicList = [];
  double deviceheight = 0;
  double devicewidth = 0;

  Audio? audio;
  final _box = Boxes.getInstance();
  List<AllSongsModel> allSongs = [];
  final favourites = ValueNotifier([]);
  @override
  Widget build(BuildContext context) {
    final keys = _box.keys.toList();
    if (keys.where((element) => element == "allSongs").isNotEmpty) {
      List list = _box.get("allSongs");
      allSongs = list.cast<AllSongsModel>();
    }
    if (keys.where((element) => element == "fav").isNotEmpty) {
      favourites.value = _box.get("fav");
    }

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : Colors.black,
      appBar: appBar2(context),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? layer1
              : appbarColorD,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        child: buildpage(),
      ),
    );
  }

  Widget buildpage() {
    deviceheight = MediaQuery.of(context).size.height;
    devicewidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: deviceheight * 0.05,
        ),
        // image
        assetsAudioPlayer.builderCurrent(builder: (context, nowPlay) {
          return Card(
            color: Colors.transparent,
            elevation: 15,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Colors.black,
                  borderRadius: BorderRadius.circular(4)),
              height: deviceheight * 0.35,
              width: devicewidth * 0.8,
              child: QueryArtworkWidget(
                artworkBorder: BorderRadius.circular(4),
                id: int.parse(nowPlay.audio.audio.metas.id.toString()),
                type: ArtworkType.AUDIO,
                nullArtworkWidget: Image(
                  image: Theme.of(context).brightness == Brightness.light
                      ? AssetImage("assets/images/songi.png")
                      : AssetImage("assets/images/songidark.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          );
        }),
        SizedBox(
          height: deviceheight * 0.05,
        ),
        //  song name
        assetsAudioPlayer.builderRealtimePlayingInfos(
            builder: (context, realtimeplayer) {
          return Container(
            width: devicewidth * 0.9,
            height: deviceheight * 0.06,
            child: Center(
              child: Text(
                realtimeplayer.current!.audio.audio.metas.title.toString(),
                maxLines: 1,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
          );
        }),
        // artist name
        assetsAudioPlayer.builderRealtimePlayingInfos(
            builder: (context, realtimePlaying) {
          return Container(
            width: devicewidth * 0.8,
            height: deviceheight * 0.02,
            child: Center(
              child: Text(
                realtimePlaying.current!.audio.audio.metas.artist.toString(),
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18, color: layer3),
              ),
            ),
          );
        }),
        SizedBox(
          height: deviceheight * 0.05,
        ),
        // favorites and playlist
        assetsAudioPlayer.builderRealtimePlayingInfos(
          builder: (context, realtimePlaying) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ValueListenableBuilder(
                    valueListenable: favourites,
                    builder:
                        (BuildContext context, List<dynamic> newFavourites, _) {
                      return favourites.value
                              .where((element) =>
                                  element.id.toString() ==
                                  realtimePlaying.current!.audio.audio.metas.id)
                              .isEmpty
                          ? IconButton(
                              onPressed: () async {
                                var id = realtimePlaying
                                    .current!.audio.audio.metas.id;
                                var indx = allSongs.indexWhere(
                                    (element) => element.id.toString() == id);
                                favourites.value.add(allSongs[indx]);
                                await _box.put("fav", favourites.value);
                                favourites.notifyListeners();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Added to favourites',
                                      textAlign: TextAlign.center,
                                    ),
                                    duration: Duration(seconds: 1),
                                    behavior: SnackBarBehavior.floating,
                                    width: 135,
                                    backgroundColor: layer3,
                                    padding: EdgeInsets.all(10),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.favorite_border,
                                color: Colors.red,
                              ))
                          : IconButton(
                              onPressed: () async {
                                var id = realtimePlaying
                                    .current!.audio.audio.metas.id;
                                var indx = allSongs.indexWhere(
                                    (element) => element.id.toString() == id);

                                favourites.value.removeWhere(
                                    (element) => element.id.toString() == id);
                                await _box.put("fav", favourites.value);
                                favourites.notifyListeners();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'Removed from favourites',
                                      textAlign: TextAlign.center,
                                    ),
                                    duration: Duration(seconds: 1),
                                    behavior: SnackBarBehavior.floating,
                                    width: 160,
                                    backgroundColor: layer3,
                                    padding: EdgeInsets.all(10),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ));
                    }),
                IconButton(
                    onPressed: () {
                      var id = realtimePlaying.current!.audio.audio.metas.id;
                      var indx = allSongs
                          .indexWhere((element) => element.id.toString() == id);

                      showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return ScreenSongsAddToPlaylist(index: indx);
                          });
                    },
                    icon: Icon(
                      Icons.playlist_add,
                    ))
              ],
            );
          },
        ),
        SizedBox(
          height: deviceheight * 0.015,
        ),
        // progress
        SizedBox(
            width: devicewidth * 0.93,
            height: devicewidth * 0.03,
            child: assetsAudioPlayer.builderRealtimePlayingInfos(
              builder: (context, realtimePlaying) {
                return slideBar(realtimePlaying);
              },
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PlayerBuilder.currentPosition(
              player: assetsAudioPlayer,
              builder: (context, duration) {
                var songTime = getTimeString(duration.inMilliseconds);
                return Text(songTime);
              },
            ),
            SizedBox(width: devicewidth * 0.7),
            assetsAudioPlayer.builderRealtimePlayingInfos(
                builder: (context, realtimePlaying) {
              return Text(
                getTimeString(realtimePlaying.duration.inMilliseconds),
              );
            })
          ],
        ),
        SizedBox(
          height: deviceheight * 0.04,
        ),
        // controlls
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () {
                  assetsAudioPlayer.toggleShuffle();
                  setState(() {
                    ispressedshuffle = !ispressedshuffle;
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 50),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context).brightness == Brightness.light
                          ? layer1
                          : appbarColorD,
                      boxShadow: ispressedshuffle
                          ? [
                              BoxShadow(
                                  blurRadius: blurshfl,
                                  offset: -distanceshfl,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : Color.fromARGB(255, 30, 30, 30),
                                  inset: ispressedshuffle),
                              BoxShadow(
                                  blurRadius: blurshfl,
                                  offset: distanceshfl,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Color.fromARGB(255, 167, 167, 167)
                                      : Color.fromARGB(255, 0, 0, 0),
                                  inset: ispressedshuffle),
                            ]
                          : []),
                  child: Container(
                      height: deviceheight * 0.045,
                      width: deviceheight * 0.045,
                      child: Icon(
                        Icons.shuffle,
                        size: deviceheight * 0.03,
                      )),
                )),
            Listener(
                onPointerUp: (event) {
                  previousSong();
                  setState(() {
                    ispressedprev = false;
                    isPressed = true;
                  });
                },
                onPointerDown: (_) => setState(() {
                      ispressedprev = true;
                    }),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 50),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context).brightness == Brightness.light
                          ? layer1
                          : appbarColorD,
                      boxShadow: ispressedprev
                          ? [
                              BoxShadow(
                                  blurRadius: blurpre,
                                  offset: -distancepre,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : Color.fromARGB(255, 30, 30, 30),
                                  inset: ispressedprev),
                              BoxShadow(
                                  blurRadius: blurpre,
                                  offset: distancepre,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Color.fromARGB(255, 167, 167, 167)
                                      : Color.fromARGB(255, 0, 0, 0),
                                  inset: ispressedprev),
                            ]
                          : []),
                  child: Container(
                      height: deviceheight * 0.055,
                      width: deviceheight * 0.055,
                      child: Icon(
                        Icons.skip_previous,
                        size: deviceheight * 0.04,
                      )),
                )),
            Center(
              child: assetsAudioPlayer.builderIsPlaying(
                builder: (context, isPlaying) {
                  return GestureDetector(
                      onTap: () async {
                        await assetsAudioPlayer.playOrPause();
                        setState(() {
                          isPressed = !isPressed;
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 100),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? layer1
                                    : appbarColorD,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: blur,
                                  offset: -distance,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : Color.fromARGB(255, 30, 30, 30),
                                  inset: isPressed),
                              BoxShadow(
                                  blurRadius: blur,
                                  offset: distance,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Color.fromARGB(255, 167, 167, 167)
                                      : Color.fromARGB(255, 0, 0, 0),
                                  inset: isPressed),
                            ]),
                        child: Container(
                            height: deviceheight * 0.06,
                            width: deviceheight * 0.06,
                            child: Icon(
                              isPressed ? Icons.pause : Icons.play_arrow,
                              size: deviceheight * 0.05,
                            )),
                      ));
                },
              ),
            ),
            Listener(
                onPointerUp: (event) {
                  nextSong();

                  setState(() {
                    ispressednxt = false;
                    isPressed = true;
                  });
                },
                onPointerDown: (_) => setState(() {
                      ispressednxt = true;
                    }),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 50),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context).brightness == Brightness.light
                          ? layer1
                          : appbarColorD,
                      boxShadow: ispressednxt
                          ? [
                              BoxShadow(
                                  blurRadius: blurnxt,
                                  offset: -distancenxt,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : Color.fromARGB(255, 30, 30, 30),
                                  inset: ispressednxt),
                              BoxShadow(
                                  blurRadius: blurnxt,
                                  offset: distancenxt,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Color.fromARGB(255, 167, 167, 167)
                                      : Color.fromARGB(255, 0, 0, 0),
                                  inset: ispressednxt),
                            ]
                          : []),
                  child: Container(
                      height: deviceheight * 0.055,
                      width: deviceheight * 0.055,
                      child: Icon(
                        Icons.skip_next,
                        size: deviceheight * 0.04,
                      )),
                )),
            GestureDetector(
                onTap: () {
                  assetsAudioPlayer.toggleLoop();
                  setState(() {
                    ispressedrepeat = !ispressedrepeat;
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 50),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context).brightness == Brightness.light
                          ? layer1
                          : appbarColorD,
                      boxShadow: ispressedrepeat
                          ? [
                              BoxShadow(
                                  blurRadius: blurrpt,
                                  offset: -distancerpt,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : Color.fromARGB(255, 30, 30, 30),
                                  inset: ispressedrepeat),
                              BoxShadow(
                                  blurRadius: blurrpt,
                                  offset: distancerpt,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Color.fromARGB(255, 167, 167, 167)
                                      : Color.fromARGB(255, 0, 0, 0),
                                  inset: ispressedrepeat),
                            ]
                          : []),
                  child: Container(
                      height: deviceheight * 0.045,
                      width: deviceheight * 0.045,
                      child: Icon(
                        Icons.repeat,
                        size: deviceheight * 0.03,
                      )),
                )),
          ],
        ),
        SizedBox(
          height: deviceheight * 0.05,
        )
      ],
    );
  }

  Widget slideBar(RealtimePlayingInfos realtimeplayer) {
    return GetBuilder<AllSongsController>(
      init: AllSongsController(),
      initState: (_) {},
      builder: (_) {
        return SliderTheme(
            data: SliderThemeData(
              trackHeight: 1,
              thumbShape: SliderComponentShape.noThumb,
            ),
            child: Slider(
              value: realtimeplayer.currentPosition.inSeconds.toDouble(),
              max: realtimeplayer.duration.inSeconds.toDouble(),
              onChanged: (value) {
                Get.find<AllSongsController>().seekSongTime(value);
              },
              activeColor: layer3,
              inactiveColor: Theme.of(context).brightness == Brightness.light
                  ? layer2
                  : layer2D,
            ));
      },
    );
  }

  String getTimeString(int milliseconds) {
    if (milliseconds == null) milliseconds = 0;
    String minutes =
        '${(milliseconds / 60000).floor() < 10 ? 0 : ''}${(milliseconds / 60000).floor()}';
    String seconds =
        '${(milliseconds / 1000).floor() % 60 < 10 ? 0 : ''}${(milliseconds / 1000).floor() % 60}';
    return '$minutes:$seconds';
  }
}
