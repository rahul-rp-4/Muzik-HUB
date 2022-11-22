import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:muzik_hub/screen_all_songs.dart';
import '../database/box_instance.dart';
import '../database/songs_adapter.dart';
import 'create_playlist.dart';
import 'edit_playlist.dart';
import 'playlist_songs.dart';
import '../screen_main.dart';

final playlistControler = TextEditingController();
final _box = Boxes.getInstance();
List<AllSongsModel> playlist = [];
final formKey = GlobalKey<FormState>();
List allPlaylist = [];
final listenable = ValueNotifier([]);

class ScreenPlaylists extends StatefulWidget {
  const ScreenPlaylists({super.key});

  @override
  State<ScreenPlaylists> createState() => _ScreenPlaylistsState();
}

class _ScreenPlaylistsState extends State<ScreenPlaylists> {
  @override
  Widget build(BuildContext context) {
    deviceheight = MediaQuery.of(context).size.height;
    devicewidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : Colors.black,
      appBar: appBar2(context),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
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
            ValueListenableBuilder(
              valueListenable: _box.listenable(),
              builder: (BuildContext context, Box newPlayList, _) {
                final allkeys = _box.keys.toList();
                allkeys.remove("allSongs");
                allkeys.remove("fav");
                allkeys.remove("recent");
                allkeys.remove("mostplayed");
                allPlaylist = allkeys.toList();

                return allPlaylist.isNotEmpty
                    ? Expanded(
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
                                          await Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                ScreenPlaylistSongs(
                                                    titlePlaylist:
                                                        allPlaylist[index]),
                                          ));
                                        },
                                        leading: Icon(
                                          Icons.playlist_play_rounded,
                                          size: 30,
                                        ),
                                        title: Text(
                                          allPlaylist[index]
                                              .toString()
                                              .toUpperCase(),
                                          style: headdingText,
                                        ),
                                        trailing: Wrap(children: [
                                          IconButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      EditPlaylist(
                                                          playlistName:
                                                              allPlaylist[
                                                                  index]),
                                                );
                                              },
                                              icon: Icon(
                                                Icons.edit_outlined,
                                                size: 20,
                                              )),
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete_outline,
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    deleteplaylist(index),
                                              );
                                            },
                                          ),
                                        ]),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: allPlaylist.length),
                        ),
                      )
                    : Expanded(
                        child: Center(
                          child: Text("No playlist created"),
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }

  deleteplaylist(int index) {
    return SimpleDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 90),
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
                'Delete "${allPlaylist[index]}"',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                          fontSize: 14,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                        )),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await _box.delete(allPlaylist[index]);
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10), color: layer2),
                    height: deviceheight * 0.04,
                    width: deviceheight * 0.1,
                    child: Center(
                      child: Text("Delete",
                          style: TextStyle(fontSize: 14, color: Colors.black)),
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
