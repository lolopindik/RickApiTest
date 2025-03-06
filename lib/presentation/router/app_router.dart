import 'package:flutter/material.dart';
import 'package:rick_test/presentation/screens/main_screen.dart';

class AppRouter {
  static const String main = '/';
  
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case main:
        return MaterialPageRoute(
          builder: (_) => const MainScreen(),
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