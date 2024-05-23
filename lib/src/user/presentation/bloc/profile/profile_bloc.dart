import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_x/src/user/domain/entity/user.dart';
import 'package:social_x/src/user/domain/usecases/follow_user.dart';
import 'package:social_x/src/user/domain/usecases/get_user_data.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserData userData;
  final FollowUser followUser;

  ProfileBloc({
    required this.userData,
    required this.followUser,
  }) : super(ProfileInitial()) {
    on<OnFollowUser>(_followUser);
  }

  Stream<UserEntity> getUser({required String userId}) {
    return userData.call(userId);
  }

  FutureOr<void> _followUser(
      OnFollowUser event, Emitter<ProfileState> emit) async {
    final follow = await followUser.call(event.params);
    follow.fold((l) => emit(ProfileFailure(error: l.message)), (r) => null);
  }

  @override
  void onChange(Change<ProfileState> change) {
    super.onChange(change);
    print(change);
  }
}
