import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:social_x/core/common/errors/failure.dart';
import 'package:social_x/core/common/network/connection_checker.dart';
import 'package:social_x/core/utils/constants/typedefs.dart';
import 'package:social_x/src/posts/data/data_source/post_data_source.dart';
import 'package:social_x/src/posts/domain/entity/comment.dart';
import 'package:social_x/src/posts/domain/entity/post.dart';
import 'package:social_x/src/posts/domain/repository/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final ConnectionChecker connectionChecker;
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl(
      {required this.connectionChecker, required this.remoteDataSource});
  @override
  ResultFuture<PostEntity> uploadPost(
      {required String ownerId,
      required String description,
      required File media}) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(FirebaseFailure(message: "No Internet Connection"));
      }
      final post = await remoteDataSource.uploadPost(
          description: description, media: media, ownerId: ownerId);
      return right(post);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<PostEntity>> fetchPosts({required int limits}) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(FirebaseFailure(message: "No Internet Connection"));
      }
      final posts = await remoteDataSource.fetchPosts(limit: limits);
      return right(posts);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid likePost({required String postId, required String myId}) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(FirebaseFailure(message: "No Internet Connection"));
      }
      await remoteDataSource.likePost(postId: postId, myId: myId);
      return right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid addComment(
      {required String userId,
      required String comment,
      required String postId}) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(FirebaseFailure(message: "No Internet Connection"));
      }
      await remoteDataSource.addComment(
          comment: comment, postId: postId, userId: userId);
      return right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<CommentEntity>> fetchComments(
      {required String postId}) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(FirebaseFailure(message: "No Internet Connection"));
      }
      final comments = await remoteDataSource.fetchComments(postId: postId);
      return right(comments);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  Stream<List<PostEntity>> profilePosts({required String userId}) {
    return remoteDataSource.profilePosts(userId: userId);
  }
}
