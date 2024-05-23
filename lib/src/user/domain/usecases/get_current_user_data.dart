import 'package:social_x/core/common/usecase/usecase.dart';
import 'package:social_x/core/utils/constants/typedefs.dart';
import 'package:social_x/src/user/domain/entity/user.dart';
import 'package:social_x/src/user/domain/repository/user_repository.dart';

class GetCurrentUserData implements UseCaseWithoutParams<UserEntity?> {
  final UserRepository repository;

  GetCurrentUserData({required this.repository});
  @override
  ResultFuture<UserEntity?> call() async =>
      await repository.getCurrentUserData();
}
