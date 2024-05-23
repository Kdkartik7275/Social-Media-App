part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class OnRegisterUser extends AuthEvent {
  final RegisterUserParams params;

  const OnRegisterUser({required this.params});
}

final class OnUploadUserProfile extends AuthEvent {
  final StoreUserProfileParams params;

  const OnUploadUserProfile({required this.params});
}

final class OnLoginUser extends AuthEvent {
  final String email;
  final String password;

  const OnLoginUser({required this.email, required this.password});
}

final class OnGetCurrentUser extends AuthEvent {}

final class OnLogoutUser extends AuthEvent {}
