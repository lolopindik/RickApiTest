import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_test/config/theme/app_theme.dart';
import 'package:rick_test/core/cache/image_cache_config.dart';
import 'package:rick_test/core/model/character.dart';
import 'package:rick_test/logic/bloc/FavoritesBloc/favorites_bloc.dart';
import 'package:rick_test/presentation/router/app_router.dart';

class CharacterCard extends StatelessWidget {
  final Character character;
  final bool showFavoriteButton;

  const CharacterCard({
    super.key,
    required this.character,
    this.showFavoriteButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AppRouter.characterDetails,
        arguments: character.id,
      ),
      child: Hero(
        tag: 'character_image_${character.id}',
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.black87,
              border: Border.all(
                color: RickAndMortyColors.secondaryColor,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: RickAndMortyColors.seedColor,
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(18),
                        ),
                        child: ImageCacheConfig.getNetworkImage(
                          imageUrl: character.image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      if (showFavoriteButton)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: _FavoriteButton(character: character),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          RickAndMortyColors.mainColor,
                          RickAndMortyColors.mainColor,
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(18),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Center(
                            child: AutoSizeText(
                              character.name,
                              style: RickAndMortyTextStyles.neonBlue24.copyWith(
                                fontSize: 20,
                                height: 1.2,
                                shadows: [
                                  Shadow(
                                    color: RickAndMortyColors.seedColor,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              minFontSize: 14,
                            ),
                          ),
                        ),
                        _StatusBadge(status: character.status),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  final Character character;

  const _FavoriteButton({required this.character});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        final isFavorite = context.read<FavoritesBloc>().isFavorite(character);
        return Container(
          decoration: BoxDecoration(
            color: RickAndMortyColors.mainColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: RickAndMortyColors.secondaryColor,
              width: 1,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                final favoritesBloc = context.read<FavoritesBloc>();
                if (isFavorite) {
                  favoritesBloc.add(RemoveFromFavorites(character));
                } else {
                  favoritesBloc.add(AddToFavorites(character));
                }
              },
              customBorder: const CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (status.toLowerCase()) {
      case 'alive':
        statusColor = RickAndMortyColors.secondaryColor;
        break;
      case 'dead':
        statusColor = Colors.redAccent;
        break;
      default:
        statusColor = RickAndMortyColors.seedColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: statusColor,
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: statusColor,
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: statusColor,
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 