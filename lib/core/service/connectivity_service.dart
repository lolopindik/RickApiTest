import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter/material.dart';

class ConnectivityService {
  final _connectivity = Connectivity();
  final _internetChecker = InternetConnectionChecker.createInstance();
  
  StreamController<bool> connectionStatusController = StreamController<bool>.broadcast();
  bool _previousState = true;
  Timer? _debounceTimer;

  ConnectivityService() {
    // Задержка 10 секунд перед первой проверкой
    Future.delayed(const Duration(seconds: 10), () {
      _initConnectivity();
      _setupConnectivityListener();
    });
  }

  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      final isConnected = await _checkConnection(result as ConnectivityResult);
      _previousState = isConnected;
      connectionStatusController.add(isConnected);
    } catch (e) {
      debugPrint('Ошибка при инициализации подключения: $e');
      connectionStatusController.add(false);
    }
  }

  void _setupConnectivityListener() {
    _connectivity.onConnectivityChanged.listen(
      (result) async {
        // Отменяем предыдущий таймер, если он существует
        _debounceTimer?.cancel();
        
        // Создаем новый таймер с задержкой
        _debounceTimer = Timer(const Duration(seconds: 10), () async {
          try {
            final isConnected = await _checkConnection(result as ConnectivityResult);
            if (isConnected != _previousState) {
              _previousState = isConnected;
              connectionStatusController.add(isConnected);
            }
          } catch (e) {
            debugPrint('Ошибка при проверке подключения: $e');
            connectionStatusController.add(false);
          }
        });
      },
    );
  }

  Future<bool> _checkConnection(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      return false;
    }
    return await _internetChecker.hasConnection;
  }

  void dispose() {
    _debounceTimer?.cancel();
    connectionStatusController.close();
  }
} 