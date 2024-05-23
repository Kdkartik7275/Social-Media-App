part of 'comment_bloc.dart';

sealed class CommentEvent extends Equatable {
  const CommentEvent();

  @override
  List<Object> get props => [];
}

final class OnFetchComments extends CommentEvent {
  final String postId;

  const OnFetchComments({required this.postId});
}
