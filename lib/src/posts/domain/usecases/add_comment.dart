import 'package:social_x/core/common/usecase/usecase.dart';
import 'package:social_x/core/utils/constants/typedefs.dart';
import 'package:social_x/src/posts/domain/repository/post_repository.dart';

class AddComment implements UseCaseWithParams<void, AddCommentParams> {
  final PostRepository repository;

  AddComment({required this.repository});
  @override
  ResultFuture<void> call(AddCommentParams params) async =>
      await repository.addComment(
          userId: params.myId, comment: params.comment, postId: params.postId);
}

class AddCommentParams {
  final String myId;
  final String postId;
  final String comment;

  AddCommentParams(
      {required this.myId, required this.postId, required this.comment});
}
