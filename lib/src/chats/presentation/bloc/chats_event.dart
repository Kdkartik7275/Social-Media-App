part of 'chats_bloc.dart';

sealed class ChatsEvent extends Equatable {
  const ChatsEvent();

  @override
  List<Object> get props => [];
}

final class OnCreatChatRoom extends ChatsEvent {
  final CreateChatRoomParams params;

  const OnCreatChatRoom({required this.params});
}

final class OnToggleUserTyping extends ChatsEvent {
  final SetUserTypingParams params;

  const OnToggleUserTyping({required this.params});
}

final class OnSendTextMessage extends ChatsEvent {
  final String myUserId;
  final String roomId;
  final String message;

  const OnSendTextMessage(
      {required this.myUserId, required this.roomId, required this.message});
}

final class OnSendFileMessage extends ChatsEvent {
  final String myUserId;
  final String roomId;
  final File file;

  const OnSendFileMessage(
      {required this.myUserId, required this.roomId, required this.file});
}

final class OnMessageRead extends ChatsEvent {
  final MessageReadParams params;

  const OnMessageRead({required this.params});
}
