import 'package:social_x/core/common/usecase/usecase.dart';
import 'package:social_x/core/utils/constants/typedefs.dart';
import 'package:social_x/src/posts/domain/entity/comment.dart';
import 'package:social_x/src/posts/domain/repository/post_repository.dart';

class FetchComments implements UseCaseWithParams<List<CommentEntity>, String> {
  final PostRepository repository;

  FetchComments({required this.repository});

  @override
  ResultFuture<List<CommentEntity>> call(String params) async =>
      await repository.fetchComments(postId: params);
}
