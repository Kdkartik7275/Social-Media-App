part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

final class OnSearchEvent extends SearchEvent {
  final String query;

  const OnSearchEvent({required this.query});
}

final class ClearUsers extends SearchEvent {}
