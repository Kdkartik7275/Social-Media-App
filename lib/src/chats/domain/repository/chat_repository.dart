import 'dart:io';

import 'package:social_x/core/utils/constants/typedefs.dart';
import 'package:social_x/core/utils/enums/message_type.dart';
import 'package:social_x/src/chats/domain/entity/chat_room.dart';
import 'package:social_x/src/chats/domain/entity/message.dart';

abstract interface class ChatsRepository {
  Stream<ChatRoom> getChatRoom({required String roomId});

  ResultFuture<String> createChatRoom(
      {required String userId, required String myUserId});

  ResultVoid setUserTyping(
      {required String chatId,
      required String myUserId,
      required bool istyping});

  ResultVoid sendTextMessage(
      {required String chatId,
      required String myUserId,
      required String message});

  ResultVoid sendFileMessage(
      {required MessagesType type,
      required String roomId,
      required File file,
      required String myUserId});

  Stream<List<MessageEntity>> listenToMessages({required String chatRoomId});
  Stream<List<ChatRoom>> listenToChats({required String myUserId});

  ResultVoid setMessageRead({required String chatId, required String userId});
}
