import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_test/logic/bloc/NavigationBloc/navigation_event.dart';
import 'package:rick_test/logic/bloc/NavigationBloc/navigation_state.dart';

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