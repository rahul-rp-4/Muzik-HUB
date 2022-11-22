import 'dart:io';
import 'package:muzik_hub/screen_all_songs.dart';
import 'package:muzik_hub/screen_main.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:muzik_hub/screen_about.dart';

import 'themes/theme_provider.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    bool darkmode =
        Theme.of(context).brightness == Brightness.light ? true : false;
    deviceheight = MediaQuery.of(context).size.height;
    devicewidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Drawer(
        width: devicewidth * 0.75,
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                  ? backgroundL
                  : backgroundD),
          child: Column(
            children: [
              SizedBox(
                height: 65,
                width: double.infinity,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Color.fromARGB(22, 42, 37, 37)
                          : Color.fromARGB(255, 22, 22, 22)),
                  child: const Center(
                      child: Text(
                    "MUZIK HUB",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Container(
                    height: 50,
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'OPTIONS',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    )),
              ),
              Consumer<ThemeProvider>(
                builder: (context, provider, child) => ListTile(
                    title: Text(
                        Theme.of(context).brightness == Brightness.light
                            ? 'Dark Mode'
                            : 'Light Mode',
                        style: headdingText),
                    trailing: Icon(
                      Theme.of(context).brightness == Brightness.light
                          ? Icons.dark_mode
                          : Icons.light_mode,
                      size: 20,
                    ),
                    onTap: () {
                      setState(() {
                        darkmode = !darkmode;
                        darkmode ? mode = 'light' : mode = 'dark';
                        provider.changeTheme(mode);
                      });
                    }),
              ),
              ListTile(
                title: Text(
                  "Share app",
                  style: headdingText,
                ),
                onTap: () {
                  Share.share(
                      'HEY!! Check out this awsome music player: MUZIK HUB at:https://drive.google.com/drive/u/1/folders/1Zz202DXe5sYjIjJvDtheIYhD6P-ldcAH');
                },
                trailing: Icon(
                  Icons.share,
                  size: 20,
                ),
              ),
              ListTile(
                title: Text(
                  "About",
                  style: headdingText,
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (ctx) => ScreenAbout()));
                },
                trailing: Icon(
                  Icons.info_sharp,
                  size: 20,
                ),
              ),
              ListTile(
                title: Text(
                  "Exit ",
                  style: headdingText,
                ),
                onTap: () => exit(0),
                trailing: Icon(
                  Icons.exit_to_app,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
