import 'package:flutter/material.dart';
import 'package:muzik_hub/playlist/create_playlist.dart';
import 'package:muzik_hub/screen_all_songs.dart';
import '../database/box_instance.dart';
import '../database/songs_adapter.dart';
import '../screen_main.dart';

class ScreenSongsAddToPlaylist extends StatefulWidget {
  int index;
  ScreenSongsAddToPlaylist({Key? key, required this.index}) : super(key: key);

  @override
  State<ScreenSongsAddToPlaylist> createState() =>
      _ScreenSongsAddToPlaylistState();
}

class _ScreenSongsAddToPlaylistState extends State<ScreenSongsAddToPlaylist> {
  final playlistControler = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final _box = Boxes.getInstance();
  final playlist = ValueNotifier([]);
  List<AllSongsModel> allSongslist = [];
  List<AllSongsModel> playList = [];

  Widget build(BuildContext context) {
    List allList = _box.get("allSongs");
    allSongslist = allList.cast<AllSongsModel>();
    final allkeys = _box.keys.toList();
    allkeys.remove("fav");
    allkeys.remove("allSongs");
    allkeys.remove("recent");
    allkeys.remove("mostplayed");
    playlist.value = allkeys;

    return Container(
      color: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : appbarColorD,
      child: Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Container(
                      height: 50,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Your Playlists',
                            style: headdingText,
                          ),
                          IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (ctx) => CreatePlaylist());
                              },
                              icon: Icon(Icons.add))
                        ],
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                ValueListenableBuilder(
                  valueListenable: playlist,
                  builder: (BuildContext context, List newPlaylist, _) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, top: 10, right: 20, bottom: 0),
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? layer2
                                        : layer2D,
                                  ),
                                  height: deviceheight * 0.07,
                                  width: devicewidth * 0.1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 2, bottom: 8),
                                    child: ListTile(
                                      onTap: () async {
                                        List onePlaylist =
                                            _box.get(newPlaylist[index]);
                                        if (onePlaylist
                                            .where((element) =>
                                                element.id.toString() ==
                                                allSongslist[widget.index]
                                                    .id
                                                    .toString())
                                            .isEmpty) {
                                          onePlaylist
                                              .add(allSongslist[widget.index]);

                                          await _box.put(playlist.value[index],
                                              onePlaylist);
                                          // Get.back();
                                          Navigator.of(context).pop();
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                songPresentinPlaylist(),
                                          );
                                        }
                                      },
                                      leading: Icon(
                                        Icons.playlist_play_rounded,
                                        size: 30,
                                      ),
                                      title: Text(
                                        newPlaylist[index],
                                        style: headdingText,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: newPlaylist.length),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  songPresentinPlaylist() {
    return SimpleDialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 70,
      ),
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
                'Song is already there in playlist',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: layer2),
                height: deviceheight * 0.04,
                width: deviceheight * 0.1,
                child: Center(
                  child: Text("OK",
                      style: TextStyle(fontSize: 14, color: Colors.black)),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
