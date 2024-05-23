import 'package:social_x/core/common/usecase/usecase.dart';
import 'package:social_x/core/utils/constants/typedefs.dart';
import 'package:social_x/src/posts/domain/entity/post.dart';
import 'package:social_x/src/posts/domain/repository/post_repository.dart';

class FetchPosts implements UseCaseWithParams<List<PostEntity>, int> {
  final PostRepository repository;

  FetchPosts({required this.repository});
  @override
  ResultFuture<List<PostEntity>> call(int limit) async =>
      await repository.fetchPosts(limits: limit);
}
