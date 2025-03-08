import 'package:dio/dio.dart';
import 'package:rick_test/logic/model/character.dart';

class ApiService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://rickandmortyapi.com/api';

  Future<List<Character>> getCharacters(int page) async {
    try {
      final response = await _dio.get('$baseUrl/character?page=$page');
      
      if (response.statusCode == 200) {
        List<dynamic> results = response.data['results'];
        return results.map((json) => Character.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load characters');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Future<List<Character>> getAllCharacters() async {
  //   List<Character> allCharacters = [];
  //   int page = 1;
  //   bool hasMore = true;

  //   while (hasMore) {
  //     try {
  //       final response = await _dio.get('$baseUrl/character?page=$page');
  //       if (response.statusCode == 200) {
  //         List<dynamic> results = response.data['results'];
  //         allCharacters.addAll(results.map((json) => Character.fromJson(json)));
  //         hasMore = response.data['info']['next'] != null;
  //         page++;
  //       } else {
  //         throw Exception('Failed to load characters');
  //       }
  //     } catch (e) {
  //       throw Exception('Error: $e');
  //     }
  //   }
  //   return allCharacters;
  // }

  Future<Character> getCharacterById(int id) async {
    try {
      final response = await _dio.get('$baseUrl/character/$id');
      if (response.statusCode == 200) {
        return Character.fromJson(response.data);
      } else {
        throw Exception('Failed to load character');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}