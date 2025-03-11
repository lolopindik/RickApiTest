import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_test/config/theme/app_theme.dart';
import 'package:rick_test/logic/bloc/FavoritesBloc/favorites_bloc.dart';
import 'package:rick_test/logic/funcs/crossaxis_mixin.dart';
import 'package:rick_test/presentation/widgets/character_card.dart';

class FavoritesPage extends StatelessWidget with CrossaxisX {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RickAndMortyColors.mainColor,
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state.favorites.isEmpty) {
            return const Center(
              child: Text(
                'Нет избранных персонажей',
                style: RickAndMortyTextStyles.portalGreen30,
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: getCrossAxisCount(context),
              crossAxisSpacing: 16,
              mainAxisSpacing: 20,
              childAspectRatio: 0.75,
            ),
            itemCount: state.favorites.length,
            itemBuilder: (context, index) {
              final character = state.favorites[index];
              return CharacterCard(character: character);
            },
          );
        },
      ),
    );
  }
}