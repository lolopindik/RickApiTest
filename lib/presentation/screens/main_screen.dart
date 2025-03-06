import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_test/constrains/preferences.dart';
import 'package:rick_test/logic/bloc/NavigationBloc/navigation_bloc.dart';
import 'package:rick_test/logic/bloc/NavigationBloc/navigation_event.dart';
import 'package:rick_test/logic/bloc/NavigationBloc/navigation_state.dart';
import 'package:rick_test/presentation/screens/home_screen.dart';
import 'package:rick_test/presentation/screens/favorite_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationBloc(),
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return Scaffold(
            body: IndexedStack(
              index: state.currentIndex,
              children: const [
                HomeScreen(),
                FavoriteScreen(),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: state.currentIndex,
              onTap: (index) {
                context.read<NavigationBloc>().add(NavigationIndexChanged(index));
              },
              backgroundColor: RickAndMortyColors.mainColor,
              selectedItemColor: RickAndMortyColors.secondaryColor,
              unselectedItemColor: Colors.grey,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.star),
                  label: 'Wubba lubba dub dub',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 