import 'package:flutter/material.dart';
import 'package:rick_test/config/theme/app_theme.dart';
import 'package:rick_test/presentation/pages/home_page.dart';
import 'package:rick_test/presentation/widgets/drawer_widget.dart';
import 'package:rick_test/presentation/widgets/home_appbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeAppbar = HomeAppbar();
    final drawer = DrawerWidget();
    return Scaffold(
      key: UniqueKey(),
      appBar: homeAppbar.buildHomeAppbar(context),
      drawer: drawer.buildDrawer(context),
      backgroundColor: RickAndMortyColors.mainColor,
      body: HomePage().buildHomePage(context),
    );
  }
}
