import 'package:social_x/core/common/usecase/usecase.dart';
import 'package:social_x/core/utils/constants/typedefs.dart';
import 'package:social_x/src/user/domain/repository/user_repository.dart';

class DeleteUserData implements UseCaseWithParams<void, String> {
  final UserRepository repository;

  DeleteUserData({required this.repository});
  @override
  ResultFuture<void> call(String userId) async =>
      await repository.deleteUserRecord(userId: userId);
}
