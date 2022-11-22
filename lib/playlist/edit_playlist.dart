import 'package:flutter/material.dart';
import 'package:muzik_hub/screen_main.dart';
import '../database/box_instance.dart';
import '../screen_all_songs.dart';

class EditPlaylist extends StatelessWidget {
  EditPlaylist({Key? key, required this.playlistName}) : super(key: key);
  final String playlistName;
  final _box = Boxes.getInstance();
  String? _title;
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    deviceheight = MediaQuery.of(context).size.height;
    return SimpleDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 85),
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : layer2D,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10, left: 10, top: 10),
                child: Text(
                  "Edit your playlist name.",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 10,
                ),
                child: Form(
                  key: formkey,
                  child: TextFormField(
                    initialValue: playlistName,
                    cursorHeight: 14,
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
                        contentPadding: EdgeInsets.all(15),
                        filled: true,
                        fillColor:
                            Theme.of(context).brightness == Brightness.light
                                ? Colors.white
                                : layer2D,
                        hintText: "Playlist Name...",
                        hintStyle: TextStyle(fontSize: 14)),
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                      fontSize: 14,
                    ),
                    onChanged: (value) {
                      _title = value;
                    },
                    validator: (value) {
                      List keys = _box.keys.toList();
                      if (value == "") {
                        return "Name required";
                      }
                      if (keys
                          .where((element) => element == value)
                          .isNotEmpty) {
                        return "This name already exits";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      // Get.back();
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
                      if (formkey.currentState!.validate()) {
                        List playlists = _box.get(playlistName);
                        _box.put(_title, playlists);
                        _box.delete(playlistName);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: layer2),
                      height: deviceheight * 0.04,
                      width: deviceheight * 0.1,
                      child: Center(
                        child: Text("Save",
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
