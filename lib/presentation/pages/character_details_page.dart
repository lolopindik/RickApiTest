// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_test/config/theme/app_theme.dart';
import 'package:rick_test/logic/bloc/CharapterBloc/charapter_bloc.dart';
import 'package:rick_test/core/model/character.dart';

class CharacterDetailsPage {
  Widget buildCharacterDetails(BuildContext context) {
    return BlocBuilder<CharacterBloc, CharacterState>(
      builder: (context, state) {
        if (state is CharacterLoading) {
          return const Center(child: CircularProgressIndicator(
            color: RickAndMortyColors.secondaryColor,
          ));
        } else if (state is CharacterLoaded) {
          final character = state.character;
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
                maxWidth: 900,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + kToolbarHeight,
                  bottom: 32,
                  left: 16,
                  right: 16,
                ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Hero(
                          tag: 'character_image_${character.id}',
                          child: Material(
                            color: Colors.transparent,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.45,
                              constraints: const BoxConstraints(
                                maxHeight: 500,
                                minHeight: 300,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: RickAndMortyColors.secondaryColor,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: RickAndMortyColors.seedColor.withOpacity(0.3),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(28),
                                child: Image.network(
                                  character.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: RickAndMortyColors.mainColor.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          character.name,
                          style: RickAndMortyTextStyles.neonBlue24.copyWith(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildStatusIndicator(character.status),
                      const SizedBox(height: 32),
                      _buildInfoSection(context, character),
                      const SizedBox(height: 24),
                      _buildEpisodesSection(character.episodeCount),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else if (state is CharacterError) {
          return _buildErrorState(context, state);
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildInfoSection(BuildContext context, Character character) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: RickAndMortyColors.mainColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: RickAndMortyColors.secondaryColor.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: RickAndMortyColors.secondaryColor.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Species:', character.species),
          const SizedBox(height: 16),
          _buildInfoRow('Status:', character.status),
          if (character.type.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildInfoRow('Type:', character.type),
          ],
          const SizedBox(height: 16),
          _buildInfoRow('Gender:', character.gender),
          const SizedBox(height: 16),
          _buildInfoRow('Origin:', character.origin),
          const SizedBox(height: 16),
          _buildInfoRow('Current location:', character.location),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(String status) {
    Color statusColor;
    switch (status.toLowerCase()) {
      case 'alive':
        statusColor = RickAndMortyColors.secondaryColor;
        break;
      case 'dead':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: statusColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: statusColor.withOpacity(0.5),
                  blurRadius: 6,
                  spreadRadius: 0,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            status,
            style: RickAndMortyTextStyles.white16.copyWith(
              color: statusColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: RickAndMortyTextStyles.portalGreen30.copyWith(
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: RickAndMortyTextStyles.white16.copyWith(
            fontSize: 20,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildEpisodesSection(int episodeCount) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: RickAndMortyColors.anotherColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: RickAndMortyColors.anotherColor.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: RickAndMortyColors.anotherColor.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.movie_outlined,
            color: RickAndMortyColors.secondaryColor,
            size: 28,
          ),
          const SizedBox(width: 12),
          Text(
            'Episodes appeared: $episodeCount',
            style: RickAndMortyTextStyles.white16.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, CharacterError state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: RickAndMortyColors.anotherColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Error: ${state.message}',
              style: RickAndMortyTextStyles.toxicPink14.copyWith(
                fontSize: 18,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Add reload functionality
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                backgroundColor: RickAndMortyColors.secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Retry',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}