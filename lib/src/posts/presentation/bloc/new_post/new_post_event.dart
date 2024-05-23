part of 'new_post_bloc.dart';

sealed class NewPostEvent extends Equatable {
  const NewPostEvent();

  @override
  List<Object> get props => [];
}

final class OnUploadPost extends NewPostEvent {
  final NewPostParams params;

  const OnUploadPost({required this.params});
}
