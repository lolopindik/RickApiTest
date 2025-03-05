import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_test/constrains/preferences.dart';
import 'package:rick_test/logic/bloc/CharapterBloc/charapter_bloc.dart';
import 'package:rick_test/logic/bloc/CharapterBloc/charapter_event.dart';
import 'package:rick_test/logic/bloc/CharapterBloc/charapter_state.dart';
import 'package:rick_test/logic/bloc/repository/charapter_reposytory.dart';
import 'package:rick_test/logic/service/api_service.dart';

class HomePage {
  Widget buildHomePage(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              CharacterBloc(repository: CharacterRepositoryImpl(ApiService()))
                ..add(const FetchCharacters()),
      child: BlocBuilder<CharacterBloc, CharacterState>(
        builder: (context, state) {
          if (state is CharacterLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CharactersLoaded) {
            return Scrollbar(
              child: GridView.builder(
                padding: EdgeInsets.fromLTRB(
                  15,
                  20,
                  15,
                  MediaQuery.of(context).size.height * 0.2,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.65,
                ),
                itemCount: state.characters.length,
                itemBuilder: (context, index) {
                  final character = state.characters[index];
                  return Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: RickAndMortyColors.secondaryColor,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(30),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(character.image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: RickAndMortyColors.anotherColor,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  character.name,
                                  style: RickAndMortyTextStyles.neonBlue24,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  character.status,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color:
                                        (character.status == 'Alive')
                                            ? RickAndMortyColors.secondaryColor
                                            : Colors.red,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          } else if (state is CharacterError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CharacterBloc>().add(
                        const FetchCharacters(),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('Loading characters...'));
        },
      ),
    );
  }
}
