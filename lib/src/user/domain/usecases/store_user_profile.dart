import 'dart:io';

import 'package:social_x/core/common/usecase/usecase.dart';
import 'package:social_x/core/utils/constants/typedefs.dart';
import 'package:social_x/src/user/domain/repository/user_repository.dart';

class StoreUserProfile
    implements UseCaseWithParams<void, StoreUserProfileParams> {
  final UserRepository repository;

  StoreUserProfile({required this.repository});
  @override
  ResultFuture<void> call(StoreUserProfileParams params) async =>
      await repository.storeUserProfile(path: params.path, image: params.image);
}

class StoreUserProfileParams {
  final String path;
  final File image;

  StoreUserProfileParams({required this.path, required this.image});
}
