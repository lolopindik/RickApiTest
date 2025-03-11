// ignore_for_file: unrelated_type_equality_checks

import 'package:dio/dio.dart';
import 'package:rick_test/config/constrains/api_constrains.dart';
import 'package:rick_test/core/model/character.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rick_test/core/cache/cache_manager.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  
  final Dio _dio;
  final _internetChecker = InternetConnectionChecker.createInstance();
  final _cacheManager = AppCacheManager();
  
  ApiService() : _dio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));

  Future<List<Character>> getCharacters(int page) async {
    List<Character>? cachedData;
    
    try {
      final hasConnection = await _checkConnectivity();
      cachedData = await _cacheManager.getCachedCharacters(page);
      
      if (!hasConnection) {
        debugPrint('Нет подключения к интернету, используем кэш для страницы $page');
        if (cachedData != null) {
          return cachedData;
        }
        throw Exception('Нет подключения к интернету и отсутствуют кэшированные данные');
      }

      try {
        final response = await _dio.get(
          ApiConstants.charactersEndpoint,
          queryParameters: {'page': page},
        );
        
        if (response.statusCode == 200 && response.data['results'] != null) {
          final characters = (response.data['results'] as List)
              .map((json) => Character.fromJson(json))
              .toList();
              
          await _cacheManager.cacheCharacters(page, characters);
          return characters;
        } else {
          throw Exception('Некорректный ответ от сервера');
        }
      } on DioException catch (e) {
        if (cachedData != null) {
          debugPrint('Ошибка сети, возвращаем кэшированные данные для страницы $page');
          return cachedData;
        }
        throw _handleDioError(e);
      }
    } catch (e) {
      if (cachedData != null) {
        return cachedData;
      }
      rethrow;
    }
  }

  Future<bool> _checkConnectivity() async {
    try {
      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity == ConnectivityResult.none) {
        return false;
      }
      
      try {
        final result = await _internetChecker.hasConnection;
        if (!result) {
          return false;
        }
        
        final response = await _dio.get(
          '/',
          options: Options(
            sendTimeout: const Duration(seconds: 2),
            receiveTimeout: const Duration(seconds: 2),
          ),
        );
        return response.statusCode == 200;
      } catch (e) {
        debugPrint('Ошибка проверки подключения к API: $e');
        return false;
      }
    } catch (e) {
      debugPrint('Ошибка проверки подключения: $e');
      return false;
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return Exception('Превышено время ожидания соединения');
      case DioExceptionType.sendTimeout:
        return Exception('Превышено время отправки запроса');
      case DioExceptionType.receiveTimeout:
        return Exception('Превышено время получения ответа');
      case DioExceptionType.badResponse:
        return Exception('Ошибка сервера: ${e.response?.statusCode}');
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