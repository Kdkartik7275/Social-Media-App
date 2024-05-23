import 'package:social_x/core/common/usecase/usecase.dart';
import 'package:social_x/core/utils/constants/typedefs.dart';
import 'package:social_x/src/user/domain/repository/user_repository.dart';

class FollowUser implements UseCaseWithParams<void, FollowUserParams> {
  final UserRepository repository;

  FollowUser({required this.repository});
  @override
  ResultFuture<void> call(params) async =>
      await repository.followUser(userId: params.userId, myId: params.myId);
}

class FollowUserParams {
  final String userId;
  final String myId;

  FollowUserParams({required this.userId, required this.myId});
}
