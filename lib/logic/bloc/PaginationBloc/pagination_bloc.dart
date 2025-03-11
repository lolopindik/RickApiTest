import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/service/api_service.dart';
import '../../../core/model/character.dart';
import '../../../core/cache/cache_manager.dart';

part 'pagination_event.dart';
part 'pagination_state.dart';

class PaginationBloc extends Bloc<PaginationEvent, PaginationState> {
  final ApiService _apiService;
  final _cacheManager = AppCacheManager();
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoading = false;
  List<Character> _characters = [];
  bool _isOnline = true;

  PaginationBloc(this._apiService) : super(PaginationInitial()) {
    on<LoadInitialPage>(_onLoadInitialPage);
    on<LoadNextPage>(_onLoadNextPage);
    on<RefreshCharacters>(_onRefreshCharacters);
    on<UpdateConnectivityStatus>(_onUpdateConnectivityStatus);
  }

  Future<void> _onLoadInitialPage(LoadInitialPage event, Emitter<PaginationState> emit) async {
    if (_isLoading) return;
    _isLoading = true;
    
    try {
      emit(PaginationLoading([]));
      final characters = await _apiService.getCharacters(1);
      _characters = characters;
      _currentPage = 2;
      _hasMore = characters.isNotEmpty;
      emit(PaginationLoaded(_characters, _hasMore));
    } catch (e) {
      debugPrint('Ошибка загрузки: $e');
      if (_characters.isNotEmpty) {
        emit(PaginationLoaded(_characters, _hasMore));
      } else {
        emit(PaginationError(e.toString()));
      }
    } finally {
      _isLoading = false;
    }
  }

  Future<void> _onLoadNextPage(LoadNextPage event, Emitter<PaginationState> emit) async {
    if (_isLoading || !_hasMore) return;
    _isLoading = true;

    try {
      final newCharacters = await _apiService.getCharacters(_currentPage);
      if (newCharacters.isNotEmpty) {
        _characters.addAll(newCharacters);
        _currentPage++;
        emit(PaginationLoaded(_characters, true));
      } else {
        _hasMore = false;
        emit(PaginationLoaded(_characters, false));
      }
    } catch (e) {
      debugPrint('Ошибка загрузки следующей страницы: $e');
      _hasMore = false;
      emit(PaginationLoaded(_characters, false));
    } finally {
      _isLoading = false;
    }
  }

  Future<void> _onRefreshCharacters(RefreshCharacters event, Emitter<PaginationState> emit) async {
    _currentPage = 1;
    _hasMore = true;
    _characters.clear();
    
    await _cacheManager.clearCache();
    add(LoadInitialPage());
  }

  void _onUpdateConnectivityStatus(
    UpdateConnectivityStatus event,
    Emitter<PaginationState> emit,
  ) {
    _isOnline = event.isOnline;
    if (_isOnline && state is PaginationLoaded) {
      _updateCachedData(_currentPage - 1);
    }
  }

  Future<void> _updateCachedData(int page) async {
    try {
      final freshCharacters = await _apiService.getCharacters(page);
      if (!isClosed) {
        _characters = page == 1 
            ? freshCharacters 
            : [..._characters.sublist(0, (page - 1) * 20), ...freshCharacters];
        add(const UpdateCharactersData());
      }
    } catch (e) {
      debugPrint('Ошибка обновления кэшированных данных: $e');
    }
  }
}
