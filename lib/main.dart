import 'package:flutter/material.dart';
import 'package:rick_test/config/theme/app_theme.dart';
import 'package:rick_test/logic/bloc/PaginationBloc/pagination_bloc.dart';
import 'package:rick_test/logic/bloc/bloc_observer.dart';
import 'package:rick_test/core/service/api_service.dart';
import 'package:rick_test/presentation/router/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_test/core/service/connectivity_service.dart';
import 'package:rick_test/logic/bloc/ConnectivityBloc/connectivity_bloc.dart';
import 'package:rick_test/presentation/widgets/connectivity_banner.dart';
import 'package:rick_test/core/cache/cache_manager.dart';
import 'package:rick_test/logic/bloc/FavoritesBloc/favorites_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await AppCacheManager().init();
    debugPrint('Кэш успешно инициализирован');
  } catch (e) {
    debugPrint('Ошибка инициализации кэша: $e');
  }
  
  Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final connectivityService = ConnectivityService();
    
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PaginationBloc(ApiService()),
        ),
        BlocProvider(
          create: (context) => ConnectivityBloc(connectivityService),
        ),
        BlocProvider(
          create: (context) => FavoritesBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'PICO RICK!',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: RickAndMortyColors.secondaryColor,
            brightness: Brightness.light,
          ),
        ),
        builder: (context, child) {
          return ConnectivityBanner(
            child: child ?? const SizedBox(),
          );
        },
        initialRoute: AppRouter.main,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
