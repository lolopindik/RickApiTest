import 'package:flutter/material.dart';
import 'package:rick_test/logic/bloc/repository/charapter_reposytory.dart';
import 'package:rick_test/core/service/api_service.dart';
import 'package:rick_test/presentation/screens/main_screen.dart';
import 'package:rick_test/presentation/screens/character_details_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_test/logic/bloc/CharapterBloc/charapter_bloc.dart';
import 'package:rick_test/presentation/pages/favorites_page.dart';

class AppRouter {
  static const String main = '/';
  static const String characterDetails = '/character-details';
  static const String favorites = '/favorites';
  
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case main:
        return MaterialPageRoute(
          builder: (_) => const MainScreen(),
        );
      case characterDetails:
        final characterId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => CharacterBloc(
              repository: CharacterRepositoryImpl(ApiService()),
            )..add(FetchCharacterById(characterId)),
            child: CharacterDetailsScreen(characterId: characterId),
          ),
        );
      case favorites:
        return MaterialPageRoute(
          builder: (_) => const FavoritesPage(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Маршрут ${settings.name} не найден'),
            ),
          ),
        );
    }
  }
} 