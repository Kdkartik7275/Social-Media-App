part of 'comment_bloc.dart';

sealed class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object> get props => [];
}

final class CommentInitial extends CommentState {}

final class CommentsLoading extends CommentState {}

final class AddCommentLoading extends CommentState {}

final class CommentsLoaded extends CommentState {
  final List<CommentEntity> comments;

  const CommentsLoaded({required this.comments});
}

final class CommentsFailure extends CommentState {
  final String error;

  const CommentsFailure({required this.error});
}
