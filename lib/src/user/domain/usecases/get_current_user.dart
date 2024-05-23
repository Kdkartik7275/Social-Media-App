import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_x/core/common/usecase/usecase.dart';
import 'package:social_x/core/utils/constants/typedefs.dart';
import 'package:social_x/src/user/domain/repository/user_repository.dart';

class GetCurrentUser implements UseCaseWithoutParams<User?> {
  final UserRepository repository;

  GetCurrentUser({required this.repository});
  @override
  ResultFuture<User?> call() async => await repository.getCurrentUser();
}
