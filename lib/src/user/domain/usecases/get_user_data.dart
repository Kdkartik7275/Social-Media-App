import 'package:social_x/core/common/usecase/usecase.dart';
import 'package:social_x/src/user/domain/entity/user.dart';
import 'package:social_x/src/user/domain/repository/user_repository.dart';

class GetUserData implements StreamUseCaseWithParams<UserEntity, String> {
  final UserRepository repository;

  GetUserData({required this.repository});
  @override
  Stream<UserEntity> call(String userId) =>
      repository.getUserData(userId: userId);
}
