import 'dart:io';

import 'package:social_x/core/utils/constants/typedefs.dart';
import 'package:social_x/src/posts/domain/entity/comment.dart';
import 'package:social_x/src/posts/domain/entity/post.dart';

abstract interface class PostRepository {
  ResultFuture<PostEntity> uploadPost(
      {required String ownerId,
      required String description,
      required File media});

  ResultFuture<List<PostEntity>> fetchPosts({required int limits});

  ResultVoid likePost({required String postId, required String myId});

  ResultVoid addComment(
      {required String userId,
      required String comment,
      required String postId});

  ResultFuture<List<CommentEntity>> fetchComments({required String postId});

  Stream<List<PostEntity>> profilePosts({required String userId});
}
