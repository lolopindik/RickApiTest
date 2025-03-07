// ignore_for_file: deprecated_member_use

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_test/constrains/preferences.dart';
import 'package:rick_test/logic/bloc/CharapterBloc/charapter_bloc.dart';
import 'package:rick_test/logic/bloc/CharapterBloc/charapter_event.dart';
import 'package:rick_test/logic/bloc/CharapterBloc/charapter_state.dart';
import 'package:rick_test/logic/bloc/repository/charapter_reposytory.dart';
import 'package:rick_test/logic/funcs/crossaxis_mixin.dart';
import 'package:rick_test/logic/service/api_service.dart';
import 'package:rick_test/presentation/router/app_router.dart';

class HomePage with CrossaxisX {
  Widget buildHomePage(BuildContext context) {
    return BlocProvider(
      create: (context) => CharacterBloc(
        repository: CharacterRepositoryImpl(ApiService())
      )..add(const FetchCharacters()),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1200, 
            minWidth: 300,  
          ),
          child: BlocBuilder<CharacterBloc, CharacterState>(
            builder: (context, state) {
              if (state is CharacterLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: RickAndMortyColors.seedColor,
                  ),
                );
              } else if (state is CharactersLoaded) {
                return Scrollbar(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05,
                      vertical: 20,
                    ),
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: getCrossAxisCount(context), 
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 20,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: state.characters.length,
                      itemBuilder: (context, index) {
                        final character = state.characters[index];
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
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  border: Border.all(
                                    color: RickAndMortyColors.secondaryColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: RickAndMortyColors.seedColor.withOpacity(0.3),
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
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(18),
                                        ),
                                        child: Image.network(
                                          character.image,
                                          fit: BoxFit.cover,
                                        ),
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
                                              RickAndMortyColors.mainColor.withOpacity(0.9),
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
                                                        color: RickAndMortyColors.seedColor.withOpacity(0.5),
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
                                            _buildStatusBadge(character.status),
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
                      },
                    ),
                  ),
                );
              } else if (state is CharacterError) {
                return _buildErrorState(context);
              }
              return const Center(
                child: Text(
                  'Loading characters...',
                  style: RickAndMortyTextStyles.neonBlue24,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
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
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusColor,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.3),
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
                  color: statusColor.withOpacity(0.5),
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
                  color: statusColor.withOpacity(0.5),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: RickAndMortyColors.seedColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load characters',
            style: RickAndMortyTextStyles.neonBlue24.copyWith(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<CharacterBloc>().add(const FetchCharacters());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: RickAndMortyColors.secondaryColor,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Retry',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}