import 'package:flutter/material.dart';
import 'package:muzik_hub/screen_all_songs.dart';
import 'bottomplay/bottomplay.dart';
import 'recents and mostplayed/screen_most_played.dart';
import 'recents and mostplayed/screen_recent_played.dart';
import 'screen_nowplaying.dart';

String mode = 'light';
Color layer3 = const Color.fromARGB(255, 120, 120, 120);
Color layer2 = const Color.fromARGB(255, 217, 217, 217);
Color layer2D = const Color.fromARGB(255, 51, 51, 51);
Color layer1 = const Color.fromARGB(255, 235, 235, 235);
Color backgroundL = Colors.white;
Color backgroundD = Color.fromARGB(255, 12, 12, 12);
Color appbarColorD = Color.fromARGB(255, 22, 22, 22);
Color textColorL = Colors.black;
Color textColord = Colors.white;

TextStyle headdingText = const TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 14,
);
TextStyle songTitle =
    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
TextStyle songSubtitle = const TextStyle(fontSize: 10);

class ScreenMain extends StatefulWidget {
  const ScreenMain({super.key});

  @override
  State<ScreenMain> createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMain> {
  int index = 0;

  final pages = const [AllSongs(), RecentPlayed(), MostPlayed()];
  @override
  Widget build(BuildContext context) {
    final deviceheight = MediaQuery.of(context).size.height;
    final devicewidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(children: [
        pages[index],
        Positioned(
            left: devicewidth * 0.0,
            right: devicewidth * 0.0,
            bottom: 0,
            child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => const ScreenNowplaying()));
                },
                child: const Bottomplay()))
      ]),
      bottomNavigationBar: SizedBox(
        height: deviceheight * 0.07,
        child: BottomNavigationBar(
            showSelectedLabels: true,
            showUnselectedLabels: true,
            currentIndex: index,
            onTap: (newindex) {
              setState(() {
                index = newindex;
              });
            },
            selectedFontSize: 11,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedFontSize: 10,
            selectedItemColor: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
            unselectedItemColor: layer3,
            backgroundColor: Theme.of(context).brightness == Brightness.light
                ? layer2
                : backgroundD,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.music_note_rounded),
                label: 'All Songs',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.history), label: 'Recently Played'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.trending_up_outlined), label: 'Most Played'),
            ]),
      ),
    );
  }
}
