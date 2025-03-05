import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rick_test/constrains/preferences.dart';

class HomeAppbar {
  PreferredSizeWidget buildHomeAppbar(BuildContext context){
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
        leading: IconButton(
          //todo add func
          onPressed: () {},
          icon: Icon(
            Icons.menu_rounded,
            size: MediaQuery.of(context).size.height * 0.035,
            color: RickAndMortyColors.secondaryColor,
          ),
        ),
      );
  }
}