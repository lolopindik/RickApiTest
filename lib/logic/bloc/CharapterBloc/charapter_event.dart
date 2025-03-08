part of 'charapter_bloc.dart';

abstract class CharacterEvent extends Equatable {
  const CharacterEvent();

  @override
  List<Object?> get props => [];
}

class FetchCharacters extends CharacterEvent {
  const FetchCharacters();
}

class FetchCharacterById extends CharacterEvent {
  final int id;

  const FetchCharacterById(this.id);

  @override
  List<Object?> get props => [id];
}