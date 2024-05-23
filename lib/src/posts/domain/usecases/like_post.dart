import 'package:social_x/core/common/usecase/usecase.dart';
import 'package:social_x/core/utils/constants/typedefs.dart';
import 'package:social_x/src/posts/domain/repository/post_repository.dart';

class LikePost implements UseCaseWithParams<void, LikePostParams> {
  final PostRepository repository;

  LikePost({required this.repository});
  @override
  ResultFuture<void> call(LikePostParams params) async =>
      await repository.likePost(postId: params.postId, myId: params.myId);
}

class LikePostParams {
  final String postId;
  final String myId;

  LikePostParams({required this.postId, required this.myId});
}
