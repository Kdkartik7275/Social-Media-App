import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_x/src/posts/domain/entity/post.dart';
import 'package:social_x/src/posts/domain/usecases/add_comment.dart';
import 'package:social_x/src/posts/domain/usecases/fetch_posts.dart';
import 'package:social_x/src/posts/domain/usecases/like_post.dart';
import 'package:social_x/src/posts/domain/usecases/profile_posts.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  List<PostEntity> posts = [];
  final FetchPosts fetchPosts;
  final LikePost likePost;
  final AddComment addComment;
  final ProfilePosts fetchProfilePosts;
  PostsBloc(
      {required this.fetchPosts,
      required this.fetchProfilePosts,
      required this.likePost,
      required this.addComment})
      : super(PostsInitial()) {
    on<OnFetchPosts>(_fetchPosts);
    on<OnLikePost>(_likePost);
    on<OnAddComment>(_addComment);
    on<OnPostsScreenReturned>(_postsScreenReturned);
  }

  FutureOr<void> _fetchPosts(
      OnFetchPosts event, Emitter<PostsState> emit) async {
    emit(PostsLoading());
    if (posts.isNotEmpty) {
      emit(PostsLoaded(posts: posts));
      return;
    }
    final postsData = await fetchPosts.call(event.limit);
    postsData.fold((l) => emit(PostsFailure(error: l.message)), (r) {
      posts = r;
      emit(PostsLoaded(posts: r));
    });
  }

  Future<void> _postsScreenReturned(
      OnPostsScreenReturned event, Emitter<PostsState> emit) async {
    // Check if reels are already cached
    if (posts.isNotEmpty) {
      emit(PostsLoaded(posts: posts));
      return;
    }

    // If not cached, fetch reels data
    emit(PostsLoading());

    final postsData = await fetchPosts.call(event.limit);
    postsData.fold((l) => emit(PostsFailure(error: l.message)), (r) {
      posts = r;
      emit(PostsLoaded(posts: r));
    });
  }

  FutureOr<void> _likePost(OnLikePost event, Emitter<PostsState> emit) async {
    final likedPost = await likePost.call(event.params);
    likedPost.fold((l) => emit(PostsFailure(error: l.message)), (r) => null);
  }

  FutureOr<void> _addComment(
      OnAddComment event, Emitter<PostsState> emit) async {
    final comment = await addComment.call(event.params);
    comment.fold((l) => emit(PostsFailure(error: l.message)), (r) => null);
  }

  Stream<List<PostEntity>> profilePosts({required String userId}) {
    return fetchProfilePosts.call(userId);
  }
}
