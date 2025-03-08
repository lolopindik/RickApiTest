// ignore_for_file: prefer_final_fields

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../service/api_service.dart';
import '../../model/character.dart';

part 'pagination_event.dart';
part 'pagination_state.dart';

class PaginationBloc extends Bloc<PaginationEvent, PaginationState> {
  final ApiService _apiService;
  int _currentPage = 1;
  bool _hasMore = true;
  List<Character> _characters = [];

  PaginationBloc(this._apiService) : super(PaginationInitial()) {
    on<LoadNextPage>(_onLoadNextPage);
  }

  Future<void> _onLoadNextPage(LoadNextPage event, Emitter<PaginationState> emit) async {
    if (!_hasMore || state is PaginationLoading) return;

    emit(PaginationLoading(_characters));
    try {
      final newCharacters = await _apiService.getCharacters(_currentPage);
      if (newCharacters.isEmpty) {
        _hasMore = false;
      } else {
        _characters.addAll(newCharacters);
        _currentPage++;
      }
      emit(PaginationLoaded(_characters, _hasMore));
    } catch (e) {
      emit(PaginationError("Ошибка загрузки данных"));
    }
  }
}