import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationState(currentIndex: 0)) {
    on<NavigationIndexChanged>(_onIndexChanged);
  }

  void _onIndexChanged(
    NavigationIndexChanged event,
    Emitter<NavigationState> emit,
  ) {
    emit(NavigationState(currentIndex: event.newIndex));
  }
} 