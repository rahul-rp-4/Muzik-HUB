import 'package:flutter/material.dart';
import '../database/box_instance.dart';
import '../database/songs_adapter.dart';

addSongstoRecents(
  int index,
  List<AllSongsModel> newList,
  ValueNotifier recent,
) async {
  final box = Boxes.getInstance();
  recent.value.insert(0, newList[index]);
  await box.put("recent", recent.value);
  List recents = box.get("recent");
  if (recents.length >= 15) {
    recents.removeLast();
  }
  if (recents
      .where((element) => element.id.toString() == newList[index].id.toString())
      .isEmpty) {
    recent.value.insert(0, newList[index]);
    await box.put("recent", recent.value);
  } else {
    (recents.removeWhere(
        (element) => element.id.toString() == newList[index].id.toString()));
    recent.value.insert(0, newList[index]);
    await box.put("recent", recent.value);
  }
}
