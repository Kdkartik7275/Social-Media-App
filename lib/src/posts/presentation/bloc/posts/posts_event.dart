part of 'posts_bloc.dart';

sealed class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object> get props => [];
}

final class OnFetchPosts extends PostsEvent {
  final int limit;

  const OnFetchPosts({required this.limit});
}

final class OnLikePost extends PostsEvent {
  final LikePostParams params;

  const OnLikePost({required this.params});
}

final class OnAddComment extends PostsEvent {
  final AddCommentParams params;

  const OnAddComment({required this.params});
}

final class OnPostsScreenReturned extends PostsEvent {
  final int limit;

  OnPostsScreenReturned({required this.limit});
}
