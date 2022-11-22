import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../screen_all_songs.dart';
import '../screen_main.dart';

class Bottomplay extends StatefulWidget {
  const Bottomplay({super.key});

  @override
  State<Bottomplay> createState() => _BottomplayState();
}

class _BottomplayState extends State<Bottomplay> {
  @override
  Widget build(BuildContext context) {
    deviceheight = MediaQuery.of(context).size.height;
    devicewidth = MediaQuery.of(context).size.width;
    return assetsAudioPlayer.builderIsPlaying(builder: (context, isPlaying) {
      return bottomplayon
          ? Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light
                      ? layer1
                      : appbarColorD,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              height: deviceheight * 0.046,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0, top: 3),
                child: ListTile(
                    visualDensity: VisualDensity(vertical: -2),
                    leading: assetsAudioPlayer.builderCurrent(
                      builder: (context, nowPlay) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 3, bottom: 10, left: 5),
                          child: SizedBox(
                            height: deviceheight * 0.035,
                            width: deviceheight * 0.035,
                            child: QueryArtworkWidget(
                              artworkBorder: BorderRadius.circular(4),
                              id: int.parse(
                                  nowPlay.audio.audio.metas.id.toString()),
                              artworkFit: BoxFit.fill,
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: Image(
                                image: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? AssetImage("assets/images/songi.png")
                                    : AssetImage("assets/images/songidark.png"),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    title: assetsAudioPlayer.builderRealtimePlayingInfos(
                        builder: (context, realtimeplayer) {
                      return Padding(
                        padding: EdgeInsets.only(
                            top: 0, bottom: deviceheight * 0.01),
                        child: Text(
                          realtimeplayer.current!.audio.audio.metas.title
                              .toString(),
                          maxLines: 1,
                          style: headdingText,
                        ),
                      );
                    }),
                    trailing: Wrap(
                      children: [
                        IconButton(
                          onPressed: () async {
                            await previousSong();
                            setState(() {
                              isPressed = true;
                            });
                          },
                          icon: Icon(
                            Icons.skip_previous_rounded,
                            size: 28,
                          ),
                        ),
                        Container(child: assetsAudioPlayer.builderIsPlaying(
                          builder: (context, isPlaying) {
                            return IconButton(
                              onPressed: () async {
                                await assetsAudioPlayer.playOrPause();
                                setState(() {
                                  isPressed = !isPressed;
                                });
                              },
                              icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                                size: 27,
                              ),
                            );
                          },
                        )),
                        IconButton(
                          onPressed: () {
                            nextSong();
                            setState(() {
                              isPressed = true;
                            });
                          },
                          icon: Icon(
                            Icons.skip_next,
                            size: 27,
                          ),
                        ),
                      ],
                    )),
              ),
            )
          : Container();
    });
  }
}
