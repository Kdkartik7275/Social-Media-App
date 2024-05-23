import 'package:social_x/core/common/usecase/usecase.dart';
import 'package:social_x/src/posts/domain/entity/post.dart';
import 'package:social_x/src/posts/domain/repository/post_repository.dart';

class ProfilePosts
    implements StreamUseCaseWithParams<List<PostEntity>, String> {
  final PostRepository repository;

  ProfilePosts({required this.repository});
  @override
  Stream<List<PostEntity>> call(String params) {
    return repository.profilePosts(userId: params);
  }
}
