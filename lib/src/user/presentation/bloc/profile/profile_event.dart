part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

final class OnGetUserProfile extends ProfileEvent {
  final String userId;

  const OnGetUserProfile({required this.userId});
}

final class OnFollowUser extends ProfileEvent {
  final FollowUserParams params;

  const OnFollowUser({required this.params});
}
