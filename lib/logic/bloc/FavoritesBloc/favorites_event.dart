part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoritesEvent {}

class AddToFavorites extends FavoritesEvent {
  final Character character;

  const AddToFavorites(this.character);

  @override
  List<Object?> get props => [character];
}

class RemoveFromFavorites extends FavoritesEvent {
  final Character character;

  const RemoveFromFavorites(this.character);

  @override
  List<Object?> get props => [character];
} 