part of 'navigation_bloc.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object?> get props => [];
}

class NavigationIndexChanged extends NavigationEvent {
  final int newIndex;

  const NavigationIndexChanged(this.newIndex);

  @override
  List<Object?> get props => [newIndex];
} 