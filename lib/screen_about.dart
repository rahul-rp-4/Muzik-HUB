import 'package:flutter/material.dart';
import 'package:muzik_hub/privacyAndTerms/privacy.dart';
import 'package:muzik_hub/privacyAndTerms/terms.dart';
import 'package:muzik_hub/screen_all_songs.dart';
import 'package:url_launcher/url_launcher.dart';

class ScreenAbout extends StatelessWidget {
  const ScreenAbout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : Colors.black,
      appBar: appBar2(context),
      body: Padding(
        padding: const EdgeInsets.only(left: 40.0),
        child: Column(
          children: [
            Container(
                height: 50,
                alignment: Alignment.centerLeft,
                child: Text(
                  'ABOUT',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                )),
            Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'V 1.1.2',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Color.fromARGB(255, 173, 173, 173)),
                )),
            SizedBox(
              height: 10,
            ),
            Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'By Rahul',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Color.fromARGB(255, 173, 173, 173)),
                )),
            SizedBox(
              height: 25,
            ),
            Container(
                height: 50,
                alignment: Alignment.centerLeft,
                child: Text(
                  'SOCIAL',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                )),
            ListTile(
              onTap: () {
                _launchGit();
              },
              title: Text('GitHub'),
            ),
            ListTile(
              onTap: () {
                _launchInstagram();
              },
              title: Text('Instagram'),
            ),
            Container(
                height: 50,
                alignment: Alignment.centerLeft,
                child: Text(
                  'MORE',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                )),
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const privacy()),
                );
              },
              horizontalTitleGap: 0,
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Privacy'),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const terms()),
                );
              },
              horizontalTitleGap: 0,
              leading: const Icon(Icons.text_snippet_outlined),
              title: const Text('Terms and Conditions'),
            )
          ],
        ),
      ),
    );
  }

  _launchInstagram() async {
    final Uri toLaunch = Uri(
        scheme: 'https',
        host: 'www.instagram.com',
        path: '____________________rp/');

    await launchUrl(toLaunch, mode: LaunchMode.externalNonBrowserApplication);
  }

  _launchGit() async {
    final Uri toLaunch =
        Uri(scheme: 'https', host: 'github.com', path: 'rahul-rp-4');

    await launchUrl(toLaunch, mode: LaunchMode.externalNonBrowserApplication);
  }
}
