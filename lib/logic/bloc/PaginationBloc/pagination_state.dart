part of 'pagination_bloc.dart';

sealed class PaginationState extends Equatable {
  const PaginationState();
  
  @override
  List<Object> get props => [];
}

final class PaginationInitial extends PaginationState {}
