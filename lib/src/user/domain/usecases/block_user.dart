import 'package:social_x/core/common/usecase/usecase.dart';
import 'package:social_x/core/utils/constants/typedefs.dart';
import 'package:social_x/src/user/domain/entity/user.dart';
import 'package:social_x/src/user/domain/repository/user_repository.dart';

class BlockUser implements UseCaseWithParams<UserEntity, BlockUserParams> {
  final UserRepository repository;

  BlockUser({required this.repository});
  @override
  ResultFuture<UserEntity> call(BlockUserParams params) async {
    return await repository.blockUser(
        userId: params.userId, myUserId: params.myUserId);
  }
}

class BlockUserParams {
  final String userId;
  final String myUserId;

  BlockUserParams({required this.userId, required this.myUserId});
}
