part of 'search_bloc.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

final class SearchInitial extends SearchState {}

final class SearchUserLoading extends SearchState {}

final class SearchUserLoaded extends SearchState {
  final List<UserEntity> users;

  const SearchUserLoaded({required this.users});
}

final class SearchUserFailure extends SearchState {
  final String error;

  const SearchUserFailure({required this.error});
}
