part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class Authenticated extends AuthState {
  const Authenticated();
}

final class UploadUserProfile extends AuthState {
  final String uid;

  const UploadUserProfile({required this.uid});
}

final class UnAuthenticated extends AuthState {}

final class AuthFailure extends AuthState {
  final String error;

  const AuthFailure({required this.error});
}
