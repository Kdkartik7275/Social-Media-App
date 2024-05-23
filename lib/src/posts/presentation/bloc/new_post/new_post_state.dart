part of 'new_post_bloc.dart';

sealed class NewPostState extends Equatable {
  const NewPostState();

  @override
  List<Object> get props => [];
}

final class NewPostInitial extends NewPostState {}

final class NewPostUploading extends NewPostState {}

final class NewPostUploadedSuccess extends NewPostState {}

final class NewPostFailure extends NewPostState {
  final String error;

  const NewPostFailure({required this.error});
}
