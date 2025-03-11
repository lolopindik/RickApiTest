part of 'pagination_bloc.dart';

abstract class PaginationEvent extends Equatable {
  const PaginationEvent();

  @override
  List<Object?> get props => [];
}

class LoadInitialPage extends PaginationEvent {}

class LoadNextPage extends PaginationEvent {}

class RefreshCharacters extends PaginationEvent {}

class UpdateCharactersData extends PaginationEvent {
  const UpdateCharactersData();
}

class UpdateConnectivityStatus extends PaginationEvent {
  final bool isOnline;
  
  const UpdateConnectivityStatus(this.isOnline);
  
  @override
  List<Object?> get props => [isOnline];
}
