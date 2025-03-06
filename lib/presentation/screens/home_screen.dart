import 'package:flutter/material.dart';
import 'package:rick_test/constrains/preferences.dart';
import 'package:rick_test/presentation/pages/home_page.dart';
import 'package:rick_test/presentation/widgets/home_appbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppbar().buildHomeAppbar(context),
      backgroundColor: RickAndMortyColors.mainColor,
      body: HomePage().buildHomePage(context),
    );
  }
}
