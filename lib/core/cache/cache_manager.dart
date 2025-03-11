import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rick_test/core/model/character.dart';
import 'package:flutter/foundation.dart';

class AppCacheManager {
  static const String charactersBox = 'characters';
  static const String cacheConfigBox = 'cacheConfig';
  static const Duration defaultCacheDuration = Duration(hours: 24);
  
  late Box<Map> _charactersCache;
  late Box<dynamic> _cacheConfig;
  late DefaultCacheManager _imageCacheManager;
  
  static final AppCacheManager _instance = AppCacheManager._internal();
  
  factory AppCacheManager() => _instance;
  
  AppCacheManager._internal() {
    _imageCacheManager = DefaultCacheManager();
  }

  Future<void> init() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      Hive.init(appDir.path);
      
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(CharacterAdapter());
      }
      
      _charactersCache = await Hive.openBox<Map>(charactersBox);
      _cacheConfig = await Hive.openBox(cacheConfigBox);
      
      debugPrint('Кэш успешно инициализирован');
    } catch (e) {
      debugPrint('Ошибка инициализации кэша: $e');
      rethrow;
    }
  }

  Future<void> cacheCharacters(int page, List<Character> characters) async {
    try {
      final key = 'characters_page_$page';
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      
      final Map<String, dynamic> cacheData = {
        'data': characters.map((c) => c.toJson()).toList(),
        'timestamp': timestamp,
        'page': page,
      };
      
      await _charactersCache.put(key, cacheData);
      debugPrint('Кэширование страницы $page выполнено успешно');
    } catch (e) {
      debugPrint('Ошибка при кэшировании данных: $e');
      rethrow;
    }
  }

  Future<List<Character>?> getCachedCharacters(int page) async {
    try {
      final key = 'characters_page_$page';
      final cached = _charactersCache.get(key);
      
      if (cached != null) {
        final timestamp = cached['timestamp'] as int;
        final now = DateTime.now().millisecondsSinceEpoch;
        final age = now - timestamp;
        
        final List<dynamic> data = cached['data'];
        final characters = data
            .map((json) => Character.fromJson(Map<String, dynamic>.from(json)))
            .toList();
        
        debugPrint('Получены кэшированные данные для страницы $page. Возраст кэша: ${age ~/ 1000} сек');
        return characters;
      }
      return null;
    } catch (e) {
      debugPrint('Ошибка при получении кэшированных данных: $e');
      return null;
    }
  }

  Future<void> clearCache() async {
    await _charactersCache.clear();
    await _imageCacheManager.emptyCache();
    await CachedNetworkImage.evictFromCache('');
  }

  Future<void> removeExpiredCache() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    
    for (var key in _charactersCache.keys) {
      final cached = _charactersCache.get(key);
      if (cached != null) {
        final timestamp = cached['timestamp'] as int;
        if (now - timestamp > defaultCacheDuration.inMilliseconds) {
          await _charactersCache.delete(key);
        }
      }
    }
  }

  Future<Map<String, dynamic>> getCacheStats() async {
    final totalSize = await _calculateCacheSize();
    final itemCount = _charactersCache.length;
    
    return {
      'totalSize': totalSize,
      'itemCount': itemCount,
      'lastCleanup': _cacheConfig.get('lastCleanup'),
    };
  }

  Future<int> _calculateCacheSize() async {
    int totalSize = 0;
    for (var key in _charactersCache.keys) {
      final cached = _charactersCache.get(key);
      if (cached != null) {
        // Примерный подсчет размера данных
        totalSize += cached.toString().length;
      }
    }
    return totalSize;
  }

  DefaultCacheManager get imageCacheManager => _imageCacheManager;
} 