part of 'pagination_bloc.dart';

abstract class PaginationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadInitialPage extends PaginationEvent {}

class LoadNextPage extends PaginationEvent {}
