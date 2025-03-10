part of 'connectivity_bloc.dart';

abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();

  @override
  List<Object?> get props => [];
}

class ConnectionChanged extends ConnectivityEvent {
  final bool isConnected;

  const ConnectionChanged(this.isConnected);

  @override
  List<Object?> get props => [isConnected];
} 