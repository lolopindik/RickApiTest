part of 'pagination_bloc.dart';

abstract class PaginationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadNextPage extends PaginationEvent {}