import 'package:social_x/core/common/usecase/usecase.dart';
import 'package:social_x/core/utils/constants/typedefs.dart';
import 'package:social_x/src/search/domain/repository/search_repository.dart';
import 'package:social_x/src/user/domain/entity/user.dart';

class SearchUser implements UseCaseWithParams<List<UserEntity>, String> {
  final SearchRepository repository;

  SearchUser({required this.repository});

  @override
  ResultFuture<List<UserEntity>> call(String params) async =>
      await repository.searchUsers(query: params);
}
