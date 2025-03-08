
part of 'pagination_bloc.dart';

abstract class PaginationState extends Equatable {
  @override
  List<Object> get props => [];
}

class PaginationInitial extends PaginationState {}

class PaginationLoading extends PaginationState {
  final List<Character> characters;
  PaginationLoading(this.characters);
  
  @override
  List<Object> get props => [characters];
}

class PaginationLoaded extends PaginationState {
  final List<Character> characters;
  final bool hasMore;
  
  PaginationLoaded(this.characters, this.hasMore);
  
  @override
  List<Object> get props => [characters, hasMore];
}

class PaginationError extends PaginationState {
  final String message;
  PaginationError(this.message);
  
  @override
  List<Object> get props => [message];
}