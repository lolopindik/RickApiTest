// ignore_for_file: unnecessary_type_check

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityService {
  final _connectivity = Connectivity();
  StreamController<bool> connectionStatusController = StreamController<bool>.broadcast();
  bool _previousState = true;
  Timer? _debounceTimer;

  ConnectivityService() {
    Future.delayed(const Duration(seconds: 1), () {
      _initConnectivity();
      _setupConnectivityListener();
    });
  }

  Future<void> _initConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      if (results is List<ConnectivityResult>) {
        final isConnected = _checkConnections(results);
        _previousState = isConnected;
        connectionStatusController.add(isConnected);
      } else {
        final isConnected = _checkConnection(results as ConnectivityResult);
        _previousState = isConnected;
        connectionStatusController.add(isConnected);
      }
    } catch (e) {
      debugPrint('Ошибка при инициализации подключения: $e');
      connectionStatusController.add(false);
    }
  }

  void _setupConnectivityListener() {
    _connectivity.onConnectivityChanged.listen(
      (results) {
        _debounceTimer?.cancel();
        
        _debounceTimer = Timer(const Duration(seconds: 1), () {
          bool isConnected;
          if (results is List<ConnectivityResult>) {
            isConnected = _checkConnections(results);
          } else {
            isConnected = _checkConnection(results as ConnectivityResult);
          }
          if (isConnected != _previousState) {
            _previousState = isConnected;
            connectionStatusController.add(isConnected);
          }
        });
      },
    );
  }

  bool _checkConnections(List<ConnectivityResult> results) {
    return results.any((result) => 
      result == ConnectivityResult.wifi || 
      result == ConnectivityResult.mobile ||
      result == ConnectivityResult.ethernet
    );
  }

  bool _checkConnection(ConnectivityResult result) {
    return result == ConnectivityResult.wifi || 
           result == ConnectivityResult.mobile ||
           result == ConnectivityResult.ethernet;
  }

  void dispose() {
    _debounceTimer?.cancel();
    connectionStatusController.close();
  }
} 