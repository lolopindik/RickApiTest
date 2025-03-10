// ignore_for_file: unrelated_type_equality_checks

import 'package:dio/dio.dart';
import 'package:rick_test/config/constrains/api_constrains.dart';
import 'package:rick_test/core/model/character.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ApiService {
  final Dio _dio;
  final _internetChecker = InternetConnectionChecker.createInstance();
  
  ApiService() : _dio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));

  Future<List<Character>> getCharacters(int page) async {
    if (!await _checkConnectivity()) {
      throw Exception('Нет подключения к интернету');
    }

    try {
      final response = await _dio.get('/character', queryParameters: {'page': page});
      return (response.data['results'] as List)
          .map((json) => Character.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<bool> _checkConnectivity() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      return false;
    }
    return await _internetChecker.hasConnection;
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return Exception('Превышено время ожидания соединения');
      case DioExceptionType.connectionError:
        return Exception('Ошибка подключения к серверу');
      default:
        return Exception('Ошибка сети: ${e.message}');
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
      final response = await _dio.get('/character/$id');
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