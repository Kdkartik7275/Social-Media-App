import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_x/src/posts/domain/usecases/new_post.dart';

part 'new_post_event.dart';
part 'new_post_state.dart';

class NewPostBloc extends Bloc<NewPostEvent, NewPostState> {
  final NewPost newPost;
  NewPostBloc({required this.newPost}) : super(NewPostInitial()) {
    on<OnUploadPost>(_uploadPost);
  }

  FutureOr<void> _uploadPost(
      OnUploadPost event, Emitter<NewPostState> emit) async {
    emit(NewPostUploading());
    final post = await newPost.call(event.params);
    post.fold((l) => emit(NewPostFailure(error: l.message)),
        (r) => emit(NewPostUploadedSuccess()));
  }
}
