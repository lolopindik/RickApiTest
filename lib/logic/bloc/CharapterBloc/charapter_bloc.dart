import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_test/logic/bloc/repository/charapter_reposytory.dart';
import 'package:rick_test/core/model/character.dart';

part 'charapter_event.dart';
part 'charapter_state.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final CharacterRepository repository;

  CharacterBloc({required this.repository}) : super(CharacterInitial()) {
    on<FetchCharacters>(_onFetchCharacters);
    on<FetchCharacterById>(_onFetchCharacterById);
  }

  Future<void> _onFetchCharacters(
    FetchCharacters event,
    Emitter<CharacterState> emit,
  ) async {
    emit(CharacterLoading());
    try {
      final characters = await repository.getAllCharacters();
      emit(CharactersLoaded(characters: characters));
    } catch (e) {
      emit(CharacterError(message: 'Failed to load characters: ${e.toString()}'));
    }
  }

  Future<void> _onFetchCharacterById(
    FetchCharacterById event,
    Emitter<CharacterState> emit,
  ) async {
    emit(CharacterLoading());
    try {
      final character = await repository.getCharacterById(event.id);
      emit(CharacterLoaded(character: character));
    } catch (e) {
      emit(CharacterError(message: 'Failed to load character: ${e.toString()}'));
    }
  }
}