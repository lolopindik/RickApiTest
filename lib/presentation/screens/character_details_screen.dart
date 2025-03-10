// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:rick_test/config/theme/app_theme.dart';
import 'package:rick_test/presentation/pages/character_details_page.dart';

class CharacterDetailsScreen extends StatelessWidget {
  final int characterId;

  const CharacterDetailsScreen({super.key, required this.characterId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: RickAndMortyColors.mainColor.withOpacity(0.7),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: RickAndMortyColors.secondaryColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      backgroundColor: RickAndMortyColors.mainColor,
      body: CharacterDetailsPage().buildCharacterDetails(context),
    );
  }
} 