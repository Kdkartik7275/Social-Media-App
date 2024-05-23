// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:social_x/core/common/errors/failure.dart';
import 'package:social_x/core/common/network/connection_checker.dart';
import 'package:social_x/core/utils/constants/typedefs.dart';
import 'package:social_x/core/utils/enums/message_type.dart';
import 'package:social_x/src/chats/data/data_source/chat_remote_data_source.dart';
import 'package:social_x/src/chats/domain/entity/chat_room.dart';
import 'package:social_x/src/chats/domain/entity/message.dart';
import 'package:social_x/src/chats/domain/repository/chat_repository.dart';

class ChatRepositoryImpl implements ChatsRepository {
  final ChatRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.connectionChecker,
  });
  @override
  Stream<ChatRoom> getChatRoom({required String roomId}) {
    try {
      return remoteDataSource.getChatRoom(roomId: roomId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  ResultFuture<String> createChatRoom(
      {required String userId, required String myUserId}) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(FirebaseFailure(message: "No Internet Connection"));
      }
      String roomId = await remoteDataSource.createChatRoom(
          userId: userId, myUserId: myUserId);
      return right(roomId);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid setUserTyping(
      {required String chatId,
      required String myUserId,
      required bool istyping}) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(FirebaseFailure(message: "No Internet Connection"));
      }
      await remoteDataSource.setUserTyping(
          chatId: chatId, istyping: istyping, myUserId: myUserId);
      return right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid sendTextMessage(
      {required String chatId,
      required String myUserId,
      required String message}) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(FirebaseFailure(message: "No Internet Connection"));
      }
      await remoteDataSource.sendTextMessage(
          chatId: chatId, message: message, myUserId: myUserId);
      return right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  Stream<List<MessageEntity>> listenToMessages({required String chatRoomId}) {
    try {
      final messages =
          remoteDataSource.listenToMessages(chatRoomId: chatRoomId);
      return messages;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<List<ChatRoom>> listenToChats({required String myUserId}) {
    try {
      final chats = remoteDataSource.listenToChats(myUserId: myUserId);
      return chats;
    } catch (e) {
      rethrow;
    }
  }

  @override
  ResultVoid sendFileMessage(
      {required MessagesType type,
      required String roomId,
      required File file,
      required String myUserId}) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(FirebaseFailure(message: "No Internet Connection"));
      }

      await remoteDataSource.sendFileMessage(
          file: file, myUserId: myUserId, roomId: roomId, type: type);
      return right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid setMessageRead(
      {required String chatId, required String userId}) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(FirebaseFailure(message: "No Internet Connection"));
      }

      await remoteDataSource.setMessageRead(chatId: chatId, userId: userId);
      return right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }
}
