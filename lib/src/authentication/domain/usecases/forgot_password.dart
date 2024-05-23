import 'package:social_x/core/common/usecase/usecase.dart';
import 'package:social_x/core/utils/constants/typedefs.dart';
import 'package:social_x/src/authentication/domain/repository/auth_repository.dart';

class ForgotPassword implements UseCaseWithParams<void, String> {
  final AuthRepository repository;

  ForgotPassword({required this.repository});

  @override
  ResultFuture<void> call(String email) async =>
      await repository.forgotPassword(email: email);
}
