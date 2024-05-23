import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_x/core/utils/enums/message_type.dart';
import 'package:social_x/src/chats/domain/entity/chat_room.dart';
import 'package:social_x/src/chats/domain/entity/message.dart';
import 'package:social_x/src/chats/domain/usecases/chat_room.dart';
import 'package:social_x/src/chats/domain/usecases/create_chat_room.dart';
import 'package:social_x/src/chats/domain/usecases/file_message.dart';
import 'package:social_x/src/chats/domain/usecases/listen_chatroomds.dart';
import 'package:social_x/src/chats/domain/usecases/listen_messages.dart';
import 'package:social_x/src/chats/domain/usecases/message_read.dart';
import 'package:social_x/src/chats/domain/usecases/set_user_typing.dart';
import 'package:social_x/src/chats/domain/usecases/text_message.dart';

part 'chats_event.dart';
part 'chats_state.dart';

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  final GetChatRoom chatRoom;
  final CreateChatRoom createChatRoom;
  final SetUserTyping setUserTyping;
  final SendTextMessage sendTextMessage;
  final ListenToMessages listenToMessages;
  final ListenToChatRooms listenToChats;
  final SendFileMessage fileMessage;
  final MessageRead setMessageRead;
  ChatsBloc(
      {required this.chatRoom,
      required this.listenToMessages,
      required this.setMessageRead,
      required this.listenToChats,
      required this.fileMessage,
      required this.sendTextMessage,
      required this.setUserTyping,
      required this.createChatRoom})
      : super(ChatsInitial()) {
    on<OnCreatChatRoom>(_createChatRoom);
    on<OnToggleUserTyping>(_setUserTyping);
    on<OnSendTextMessage>(_textMessage);
    on<OnSendFileMessage>(_fileMessage);
    on<OnMessageRead>(_setMessageRead);
  }

  Stream<ChatRoom> getChatRoom({required String roomId}) {
    return chatRoom.call(roomId);
  }

  FutureOr<void> _createChatRoom(
      OnCreatChatRoom event, Emitter<ChatsState> emit) async {
    emit(ChatsLoading());
    final data = await createChatRoom.call(CreateChatRoomParams(
        userId: event.params.userId, myUserId: event.params.myUserId));
    data.fold((l) => emit(ChatRoomFailure(error: l.message)),
        (r) => emit(ChatRoomCreated(roomId: r)));
  }

  @override
  void onChange(Change<ChatsState> change) {
    super.onChange(change);
    print(change);
  }

  FutureOr<void> _setUserTyping(
      OnToggleUserTyping event, Emitter<ChatsState> emit) async {
    final typing = await setUserTyping.call(event.params);
    typing.fold((l) => emit(ChatRoomFailure(error: l.message)), (r) => null);
  }

  FutureOr<void> _textMessage(
      OnSendTextMessage event, Emitter<ChatsState> emit) async {
    final message = await sendTextMessage.call(SendMessagesParams(
        myUserId: event.myUserId,
        roomId: event.roomId,
        message: event.message));
    message.fold((l) => emit(ChatRoomFailure(error: l.message)), (r) => null);
  }

  Future _fileMessage(OnSendFileMessage event, Emitter<ChatsState> emit) async {
    final message = await fileMessage.call(SendFileMessageParams(
        myUserId: event.myUserId,
        type: MessagesType.image,
        file: event.file,
        roomId: event.roomId));
    message.fold((l) => emit(ChatRoomFailure(error: l.message)), (r) => null);
  }

  Stream<List<MessageEntity>> listenMessages({required String chatId}) {
    return listenToMessages.call(ListenToMessagesParams(chatRoomId: chatId));
  }

  Stream<List<ChatRoom>> listenToChatRooms({required String myUserId}) {
    return listenToChats.call(myUserId);
  }

  FutureOr<void> _setMessageRead(
      OnMessageRead event, Emitter<ChatsState> emit) async {
    final read = await setMessageRead.call(event.params);
    read.fold((l) => emit(ChatRoomFailure(error: l.message)), (r) => null);
  }
}
