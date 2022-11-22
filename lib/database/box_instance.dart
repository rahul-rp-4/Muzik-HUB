import 'package:hive_flutter/hive_flutter.dart';

import '../screen_all_songs.dart';

class Boxes {
  static Box getInstance() => Hive.box("songs");
}

Box<AllSongs> getSongBox() {
  return Hive.box<AllSongs>('AllSongs');
}
