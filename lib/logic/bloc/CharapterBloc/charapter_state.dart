part of 'charapter_bloc.dart';

abstract class CharacterState extends Equatable {
  const CharacterState();

  @override
  List<Object?> get props => [];
}

class CharacterInitial extends CharacterState {
  const CharacterInitial();
}

class CharacterLoading extends CharacterState {
  const CharacterLoading();
}

class CharactersLoaded extends CharacterState {
  final List<Character> characters;

  const CharactersLoaded({required this.characters});

  @override
  List<Object?> get props => [characters];
}

class CharacterLoaded extends CharacterState {
  final Character character;

  const CharacterLoaded({required this.character});

  @override
  List<Object?> get props => [character];
}

class CharacterError extends CharacterState {
  final String message;

  const CharacterError({required this.message});

  @override
  List<Object?> get props => [message];
}