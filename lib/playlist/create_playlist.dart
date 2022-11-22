import 'package:flutter/material.dart';
import 'package:muzik_hub/screen_main.dart';
import '../database/box_instance.dart';
import '../screen_all_songs.dart';
import 'screen_playlists.dart';

class CreatePlaylist extends StatelessWidget {
  CreatePlaylist({super.key});
  final _box = Boxes.getInstance();
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    deviceheight = MediaQuery.of(context).size.height;
    return SimpleDialog(
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 90,
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : layer2D,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        children: [
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  "Create Playlist",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Form(
                  key: formKey,
                  child: SizedBox(
                    height: deviceheight * 0.05,
                    child: TextFormField(
                      maxLines: 1,
                      controller: playlistControler,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : layer2D,
                                  width: 2)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : layer2D,
                                  width: 2)),
                          contentPadding: const EdgeInsets.all(15),
                          filled: true,
                          fillColor:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.white
                                  : layer2D,
                          hintText: "Playlist Name...",
                          hintStyle: const TextStyle(fontSize: 14)),
                      validator: (value) {
                        List keys = _box.keys.toList();
                        if (value!.isEmpty) {
                          return "Requried*";
                        }
                        if (keys
                            .where((element) => element == value)
                            .isNotEmpty) {
                          return "this name is already exists";
                        }
                      },
                    ),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      // Get.back();
                      playlistControler.clear();
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
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        String playListName = playlistControler.text;
                        _box.put(playListName, playlist);
                        playlistControler.clear();
                        Navigator.of(context).pop();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: layer2),
                      height: deviceheight * 0.04,
                      width: deviceheight * 0.1,
                      child: const Center(
                        child: Text("Create",
                            style:
                                TextStyle(fontSize: 14, color: Colors.black)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ]);
  }
}
