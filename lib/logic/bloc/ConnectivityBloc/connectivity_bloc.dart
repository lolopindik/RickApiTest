import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rick_test/core/service/connectivity_service.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final ConnectivityService _connectivityService;
  
  ConnectivityBloc(this._connectivityService) : super(ConnectivityInitial()) {
    _connectivityService.connectionStatusController.stream.listen((isConnected) {
      add(ConnectionChanged(isConnected));
    });

    on<ConnectionChanged>((event, emit) {
      if (event.isConnected) {
        emit(ConnectivityConnected());
      } else {
        emit(ConnectivityDisconnected());
      }
    });
  }

  @override
  Future<void> close() {
    _connectivityService.dispose();
    return super.close();
  }
} 