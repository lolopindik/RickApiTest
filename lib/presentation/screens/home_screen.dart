import 'package:flutter/material.dart';
import 'package:rick_test/constrains/preferences.dart';
import 'package:rick_test/presentation/pages/home_page.dart';
import 'package:rick_test/presentation/widgets/home_appbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeAppbar = HomeAppbar();
    return Scaffold(
      key: UniqueKey(),
      appBar: homeAppbar.buildHomeAppbar(context),
      drawer: homeAppbar.buildDrawer(context),
      backgroundColor: RickAndMortyColors.mainColor,
      body: HomePage().buildHomePage(context),
    );
  }
}
