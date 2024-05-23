part of 'currentuser_cubit.dart';

sealed class CurrentuserState extends Equatable {
  const CurrentuserState();

  @override
  List<Object> get props => [];
}

final class CurrentuserInitial extends CurrentuserState {}

final class CurrentuserLoading extends CurrentuserState {}

final class OnProfileUpdating extends CurrentuserState {}

final class CurrentuserLoaded extends CurrentuserState {
  final UserEntity user;

  const CurrentuserLoaded({required this.user});
}

final class CurrentuserFailure extends CurrentuserState {
  final String error;

  const CurrentuserFailure({required this.error});
}
