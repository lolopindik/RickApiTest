part of 'favorites_bloc.dart';

class FavoritesState extends Equatable {
  final List<Character> favorites;

  const FavoritesState(this.favorites);

  @override
  List<Object?> get props => [favorites];
} 