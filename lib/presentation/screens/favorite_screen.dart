import 'package:flutter/material.dart';
import 'package:rick_test/presentation/pages/favorite_page.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FavoritePage().buildFavorite(context),
    );
  }
}