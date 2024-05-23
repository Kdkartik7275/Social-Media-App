import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_x/src/authentication/domain/usecases/login_user.dart';
import 'package:social_x/src/authentication/domain/usecases/logout.dart';
import 'package:social_x/src/authentication/domain/usecases/register_user.dart';
import 'package:social_x/src/user/domain/usecases/get_current_user.dart';
import 'package:social_x/src/user/domain/usecases/save_user_data.dart';
import 'package:social_x/src/user/domain/usecases/store_user_profile.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUser registerUser;
  final StoreUserProfile userProfile;
  final LoginUser loginUser;
  final SaveUserData saveUserData;
  final GetCurrentUser getCurrentUser;
  final Logout logoutUser;
  AuthBloc(
      {required this.registerUser,
      required this.userProfile,
      required this.logoutUser,
      required this.getCurrentUser,
      required this.loginUser,
      required this.saveUserData})
      : super(AuthInitial()) {
    on<OnRegisterUser>(_register);
    on<OnUploadUserProfile>(_storeUserProfile);
    on<OnLoginUser>(_loginUser);
    on<OnGetCurrentUser>(_currentUser);
    on<OnLogoutUser>(_logoutUser);
  }

  FutureOr<void> _register(
      OnRegisterUser event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final user = await registerUser.call(event.params);
    user.fold((l) => emit(AuthFailure(error: l.message)), (r) {
      emit(UploadUserProfile(uid: r!.user!.uid));
    });
  }

  FutureOr<void> _storeUserProfile(
      OnUploadUserProfile event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final profile = await userProfile.call(event.params);
    profile.fold((l) => emit(AuthFailure(error: l.message)),
        (r) => emit(const Authenticated()));
  }

  FutureOr<void> _loginUser(OnLoginUser event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final user = await loginUser
        .call(LoginUserParams(email: event.email, password: event.password));

    user.fold((l) => emit(AuthFailure(error: l.message)),
        (r) => emit(const Authenticated()));
  }

  FutureOr<void> _currentUser(
      OnGetCurrentUser event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final user = await getCurrentUser.call();
    user.fold(
        (l) => emit(UnAuthenticated()), (r) => emit(const Authenticated()));
  }

  FutureOr<void> _logoutUser(
      OnLogoutUser event, Emitter<AuthState> emit) async {
    final logout = await logoutUser.call();

    logout.fold((l) => emit(AuthFailure(error: l.message)),
        (r) => emit(UnAuthenticated()));
  }

  @override
  void onChange(Change<AuthState> change) {
    super.onChange(change);
    print(change);
  }
}
