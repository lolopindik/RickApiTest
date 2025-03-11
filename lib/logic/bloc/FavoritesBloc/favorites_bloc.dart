import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import '../../../core/model/character.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  static const String favoritesBox = 'favorites';
  late Box<Map> _favoritesBox;

  FavoritesBloc() : super(const FavoritesState([])) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddToFavorites>(_onAddToFavorites);
    on<RemoveFromFavorites>(_onRemoveFromFavorites);
    _initHive();
  }

  Future<void> _initHive() async {
    _favoritesBox = await Hive.openBox<Map>(favoritesBox);
    add(LoadFavorites());
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final favorites = _favoritesBox.values
          .map((json) => Character.fromJson(Map<String, dynamic>.from(json)))
          .toList();
      emit(FavoritesState(favorites));
    } catch (e) {
      emit(const FavoritesState([]));
    }
  }

  Future<void> _onAddToFavorites(
    AddToFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await _favoritesBox.put(
        event.character.id.toString(),
        event.character.toJson(),
      );
      add(LoadFavorites());
    } catch (e) {
      debugPrint('Ошибка добавления в избранное: $e');
    }
  }

  Future<void> _onRemoveFromFavorites(
    RemoveFromFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await _favoritesBox.delete(event.character.id.toString());
      add(LoadFavorites());
    } catch (e) {
      debugPrint('Ошибка удаления из избранного: $e');
    }
  }

  bool isFavorite(Character character) {
    return _favoritesBox.containsKey(character.id.toString());
  }
} 