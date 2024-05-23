part of 'posts_bloc.dart';

sealed class PostsState extends Equatable {
  const PostsState();

  @override
  List<Object> get props => [];
}

final class PostsInitial extends PostsState {}

final class PostsLoading extends PostsState {}

final class PostsLoaded extends PostsState {
  final List<PostEntity> posts;

  const PostsLoaded({required this.posts});
}

final class PostsFailure extends PostsState {
  final String error;

  const PostsFailure({required this.error});
}
