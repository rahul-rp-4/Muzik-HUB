import 'package:flutter/material.dart';
import '../database/box_instance.dart';
import '../database/songs_adapter.dart';

addSongstoMostPlayed(
    int index, List<AllSongsModel> newList, ValueNotifier mostplayed) async {
  final box = Boxes.getInstance();
  await box.put("mostplayed", mostplayed.value);
  List mostply = box.get("mostplayed");
  int count = newList[index].count;
  newList[index].count = count + 1;
  if (mostply.length >= 15) {
    mostply.removeLast();
  }
  if (newList[index].count >= 5) {
    if (mostply
        .where(
            (element) => element.id.toString() == newList[index].id.toString())
        .isEmpty) {
      mostplayed.value.insert(0, newList[index]);
      await box.put("mostplayed", mostplayed.value);
    } else {
      (mostply.removeWhere(
          (element) => element.id.toString() == newList[index].toString()));
      mostplayed.value.remove(0, newList[index]);
      await box.put("mostplayed", mostplayed.value);
    }
  }
}
