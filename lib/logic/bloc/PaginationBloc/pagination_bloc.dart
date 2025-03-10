import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/service/api_service.dart';
import '../../../core/model/character.dart';

part 'pagination_event.dart';
part 'pagination_state.dart';

class PaginationBloc extends Bloc<PaginationEvent, PaginationState> {
  final ApiService _apiService;
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoading = false;
  List<Character> _characters = [];

  PaginationBloc(this._apiService) : super(PaginationInitial()) {
    on<LoadInitialPage>(_onLoadInitialPage);
    on<LoadNextPage>(_onLoadNextPage);
  }

  Future<void> _onLoadInitialPage(LoadInitialPage event, Emitter<PaginationState> emit) async {
    if (_isLoading) return;
    _isLoading = true;
    emit(PaginationLoading([]));
    try {
      final newCharacters = await _apiService.getCharacters(_currentPage);
      _characters = newCharacters;
      _hasMore = newCharacters.isNotEmpty;
      _currentPage++;
      emit(PaginationLoaded(_characters, _hasMore));
    } catch (_) {
      emit(PaginationError("Ошибка загрузки данных"));
    } finally {
      _isLoading = false;
    }
  }

  Future<void> _onLoadNextPage(LoadNextPage event, Emitter<PaginationState> emit) async {
    if (_isLoading) {
      return;
    }
    if (!_hasMore) {
      emit(PaginationLoaded(_characters, false));
      return;
    }

    _isLoading = true;
    emit(PaginationLoading(_characters));
    
    try {
      final newCharacters = await _apiService.getCharacters(_currentPage);
      _characters.addAll(newCharacters);
      _currentPage++;
      _hasMore = newCharacters.isNotEmpty;
      
      emit(PaginationLoaded(_characters, _hasMore));
    } catch (e) {
      emit(PaginationError('Не удалось загрузить персонажей: ${e.toString()}'));
    } finally {
      _isLoading = false;
    }
  }
}
