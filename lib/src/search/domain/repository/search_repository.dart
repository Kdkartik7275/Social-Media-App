import 'package:social_x/core/utils/constants/typedefs.dart';
import 'package:social_x/src/user/domain/entity/user.dart';

abstract interface class SearchRepository {
  ResultFuture<List<UserEntity>> searchUsers({required String query});
}
