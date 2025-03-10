// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rick_test/config/theme/app_theme.dart';

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
}