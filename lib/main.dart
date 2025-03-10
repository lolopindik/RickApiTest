import 'package:flutter/material.dart';
import 'package:rick_test/constrains/preferences.dart';
import 'package:rick_test/logic/bloc/PaginationBloc/pagination_bloc.dart';
import 'package:rick_test/logic/bloc/bloc_observer.dart';
import 'package:rick_test/logic/service/api_service.dart';
import 'package:rick_test/presentation/router/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PaginationBloc(ApiService()),
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
        initialRoute: AppRouter.main,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
