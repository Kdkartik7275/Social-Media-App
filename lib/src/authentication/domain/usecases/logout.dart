import 'package:social_x/core/common/usecase/usecase.dart';
import 'package:social_x/core/utils/constants/typedefs.dart';
import 'package:social_x/src/authentication/domain/repository/auth_repository.dart';

class Logout implements UseCaseWithoutParams<void> {
  final AuthRepository repository;

  Logout({required this.repository});
  @override
  ResultFuture<void> call() async => await repository.logout();
}
