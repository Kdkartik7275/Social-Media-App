import 'dart:io';

import 'package:social_x/core/common/usecase/usecase.dart';
import 'package:social_x/core/utils/constants/typedefs.dart';
import 'package:social_x/src/posts/domain/entity/post.dart';
import 'package:social_x/src/posts/domain/repository/post_repository.dart';

class NewPost implements UseCaseWithParams<PostEntity, NewPostParams> {
  final PostRepository repository;

  NewPost({required this.repository});
  @override
  ResultFuture<PostEntity> call(NewPostParams params) async =>
      await repository.uploadPost(
          ownerId: params.ownerId,
          description: params.description,
          media: params.media);
}

class NewPostParams {
  final String ownerId;
  final String description;
  final File media;

  NewPostParams(
      {required this.ownerId, required this.description, required this.media});
}
