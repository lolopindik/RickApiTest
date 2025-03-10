import 'package:rick_test/core/model/character.dart';
import 'package:rick_test/core/remote/service/api_service.dart';

abstract class CharacterRepository {
  Future<List<Character>> getAllCharacters();
  Future<Character> getCharacterById(int id);
}

class CharacterRepositoryImpl implements CharacterRepository {
  final ApiService _apiService;

  CharacterRepositoryImpl(this._apiService);

  @override
  Future<List<Character>> getAllCharacters() async {
    try {
      return await _apiService.getCharacters(1);
    } catch (e) {
      throw Exception('Failed to fetch characters: $e');
    }
  }

  @override
  Future<Character> getCharacterById(int id) async {
    try {
      return await _apiService.getCharacterById(id);
    } catch (e) {
      throw Exception('Failed to fetch character: $e');
    }
  }
}