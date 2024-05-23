import 'package:social_x/core/common/usecase/usecase.dart';
import 'package:social_x/core/utils/constants/typedefs.dart';
import 'package:social_x/src/user/domain/repository/user_repository.dart';

class SetUserToken implements UseCaseWithParams<void, SetUserTokenParams> {
  final UserRepository repository;

  SetUserToken({required this.repository});
  @override
  ResultFuture<void> call(SetUserTokenParams params) async {
    return await repository.setUserToken(
        token: params.token, userId: params.userId);
  }
}

class SetUserTokenParams {
  final String token;
  final String userId;

  SetUserTokenParams({required this.token, required this.userId});
}
