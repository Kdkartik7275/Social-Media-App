// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:social_x/src/posts/domain/entity/comment.dart';
import 'package:social_x/src/posts/domain/usecases/fetch_comments.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  List<CommentEntity> comments = [];

  final FetchComments fetchComments;
  CommentBloc({required this.fetchComments}) : super(CommentInitial()) {
    on<OnFetchComments>(_fetchComments);
  }

  FutureOr<void> _fetchComments(
      OnFetchComments event, Emitter<CommentState> emit) async {
    emit(CommentsLoading());
    final commentsData = await fetchComments.call(event.postId);
    commentsData.fold((l) => emit(CommentsFailure(error: l.message)), (r) {
      comments = r;
      emit(CommentsLoaded(comments: r));
    });
  }
}
