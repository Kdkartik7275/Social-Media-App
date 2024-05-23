part of 'chats_bloc.dart';

sealed class ChatsState extends Equatable {
  const ChatsState();

  @override
  List<Object> get props => [];
}

final class ChatsInitial extends ChatsState {}

final class ChatsLoading extends ChatsState {}

final class Sending extends ChatsState {
  final File image;

  const Sending({required this.image});
}

final class MessageSend extends ChatsState {}

final class ChatRoomCreated extends ChatsState {
  final String roomId;

  const ChatRoomCreated({required this.roomId});
}

final class ChatRoomFailure extends ChatsState {
  final String error;

  const ChatRoomFailure({required this.error});
}
