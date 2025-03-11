import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_test/config/theme/app_theme.dart';
import 'package:rick_test/logic/bloc/PaginationBloc/pagination_bloc.dart';
import 'package:rick_test/logic/funcs/crossaxis_mixin.dart';
import 'package:rick_test/core/service/api_service.dart';
import 'package:rick_test/presentation/widgets/character_card.dart';

class HomePage {
  Widget buildHomePage(BuildContext context) {
    return BlocProvider(
      create: (context) => PaginationBloc(ApiService())..add(LoadInitialPage()),
      child: const HomePageContent(),
    );
  }
}

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  HomePageContentState createState() => HomePageContentState();
}

class HomePageContentState extends State<HomePageContent> with CrossaxisX {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      context.read<PaginationBloc>().add(LoadNextPage());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 1200,
          minWidth: 300,
        ),
        child: BlocBuilder<PaginationBloc, PaginationState>(
          builder: (context, state) {
            if (state is PaginationLoading && state.characters.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(
                  color: RickAndMortyColors.secondaryColor,
                ),
              );
            } else if (state is PaginationLoaded ||
                (state is PaginationLoading && state.characters.isNotEmpty)) {
              final characters = state is PaginationLoaded
                  ? state.characters
                  : (state as PaginationLoading).characters;

              final hasMore = state is PaginationLoaded ? state.hasMore : true;

              return Scrollbar(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                  ),
                  child: GridView.builder(
                    key: const PageStorageKey('charactersGrid'),
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: getCrossAxisCount(context),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: characters.length + (hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == characters.length && hasMore) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(
                              color: RickAndMortyColors.secondaryColor,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      }

                      final character = characters[index];
                      return CharacterCard(character: character);
                    },
                  ),
                ),
              );
            } else if (state is PaginationError) {
              final characters = state.message.contains('кэшированные данные')
                  ? [] 
                  : (state as dynamic).characters ?? []; 

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildErrorState(context),
                    if (characters.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          'Показаны сохранённые данные',
                          style: RickAndMortyTextStyles.toxicPink14,
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              );
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
            'Не удалось загрузить персонажей.\nПроверьте подключение к интернету',
            style: RickAndMortyTextStyles.neonBlue24.copyWith(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<PaginationBloc>()
                ..add(RefreshCharacters())
                ..add(LoadInitialPage());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: RickAndMortyColors.secondaryColor,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Повторить',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
