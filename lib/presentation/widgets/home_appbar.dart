// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rick_test/constrains/preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeAppbar {
  PreferredSizeWidget buildHomeAppbar(BuildContext context) {
    return AppBar(
      title: SizedBox(
        height: 55,
        width: 180,
        child: SvgPicture.asset(
          'lib/assets/images/Rick_and_Morty.svg',
          fit: BoxFit.cover,
        ),
      ),
      toolbarHeight: MediaQuery.of(context).size.height * 0.08,
      centerTitle: true,
      backgroundColor: RickAndMortyColors.mainColor,
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(
              Icons.menu_rounded,
              size: MediaQuery.of(context).size.height * 0.035,
              color: RickAndMortyColors.secondaryColor,
            ),
          );
        },
      ),
    );
  }

  Widget buildDrawer(BuildContext context) {
    Future<void> _launchTelegram() async {
      final Uri url = Uri.parse('https://t.me/Denchick8');
      try {
        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
          throw Exception('Could not launch $url');
        }
      } catch (e) {
        debugPrint('Error launching URL: $e');
      }
    }

    return Drawer(
      backgroundColor: RickAndMortyColors.mainColor,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: RickAndMortyColors.mainColor,
            ),
            child: Center(
              child: SvgPicture.asset(
                'lib/assets/images/Rick_and_Morty.svg',
                fit: BoxFit.contain,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.telegram,
              color: RickAndMortyColors.secondaryColor,
              size: 30,
            ),
            title: Text(
              'Telegram',
              style: RickAndMortyTextStyles.portalGreen30.copyWith(fontSize: 20),
            ),
            onTap: () {
              _launchTelegram();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}