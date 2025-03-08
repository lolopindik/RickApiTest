import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'pagination_event.dart';
part 'pagination_state.dart';

class PaginationBloc extends Bloc<PaginationEvent, PaginationState> {
  PaginationBloc() : super(PaginationInitial()) {
    on<PaginationEvent>((event, emit) {
      
    });
  }
}
