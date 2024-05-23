import 'package:fpdart/fpdart.dart';
import 'package:social_x/core/common/errors/failure.dart';
import 'package:social_x/core/common/network/connection_checker.dart';
import 'package:social_x/core/utils/constants/typedefs.dart';
import 'package:social_x/src/search/data/data_souce/search_remote_data_source.dart';
import 'package:social_x/src/search/domain/repository/search_repository.dart';
import 'package:social_x/src/user/domain/entity/user.dart';

class SearchRepositoryImplementation implements SearchRepository {
  final ConnectionChecker connectionChecker;
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImplementation(
      {required this.connectionChecker, required this.remoteDataSource});

  @override
  ResultFuture<List<UserEntity>> searchUsers({required String query}) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(FirebaseFailure(message: "No Internet Connection"));
      }
      final users = await remoteDataSource.searchUsers(query: query);
      return right(users);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }
}
