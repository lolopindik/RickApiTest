import 'package:flutter/material.dart';
import 'package:rick_test/config/theme/app_theme.dart';
import 'package:rick_test/presentation/pages/favorites_page.dart';
import 'package:rick_test/presentation/widgets/drawer_widget.dart';
import 'package:rick_test/presentation/widgets/home_appbar.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeAppbar = HomeAppbar();
    final drawer = DrawerWidget();
    return Scaffold(
      appBar: homeAppbar.buildHomeAppbar(context),
      drawer: drawer.buildDrawer(context),
      backgroundColor: RickAndMortyColors.mainColor,
      body: FavoritesPage().build(context),
    );
  }
}