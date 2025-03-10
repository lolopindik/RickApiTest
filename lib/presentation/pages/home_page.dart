// ignore_for_file: deprecated_member_use

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_test/config/theme/app_theme.dart';
import 'package:rick_test/logic/bloc/PaginationBloc/pagination_bloc.dart';
import 'package:rick_test/logic/funcs/crossaxis_mixin.dart';
import 'package:rick_test/core/remote/service/api_service.dart';
import 'package:rick_test/presentation/router/app_router.dart';

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
                          child: CircularProgressIndicator(
                            color: RickAndMortyColors.secondaryColor,
                          ),
                        );
                      }

                      final character = characters[index];
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
            } else if (state is PaginationError) {
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor, width: 1.5),
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
              context.read<PaginationBloc>().add(LoadInitialPage());
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
              'Retry',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
