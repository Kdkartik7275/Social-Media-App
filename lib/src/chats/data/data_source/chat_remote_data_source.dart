import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:social_x/core/common/errors/exceptions/firebase_exceptions.dart';
import 'package:social_x/core/common/errors/exceptions/format_exceptions.dart';
import 'package:social_x/core/common/errors/exceptions/platform_exceptions.dart';
import 'package:social_x/core/utils/enums/message_type.dart';
import 'package:social_x/core/utils/helper_functions/helper_functions.dart';
import 'package:social_x/src/chats/data/models/chat_room_model.dart';
import 'package:social_x/src/chats/data/models/chat_user_model.dart';
import 'package:social_x/src/chats/data/models/message_model.dart';
import 'package:uuid/uuid.dart';

abstract interface class ChatRemoteDataSource {
  Stream<ChatRoomModel> getChatRoom({required String roomId});

  Future<String> createChatRoom(
      {required String userId, required String myUserId});

  Future<void> setUserTyping(
      {required String chatId,
      required String myUserId,
      required bool istyping});

  Future<void> sendTextMessage(
      {required String chatId,
      required String myUserId,
      required String message});

  Future<void> sendFileMessage(
      {required MessagesType type,
      required String roomId,
      required File file,
      required String myUserId});
  Stream<List<MessageModel>> listenToMessages({required String chatRoomId});

  Stream<List<ChatRoomModel>> listenToChats({required String myUserId});
  Future<void> setMessageRead({required String chatId, required String userId});
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore _firestore;
  final THelperFunctions functions;
  final FirebaseStorage _storage;

  ChatRemoteDataSourceImpl(
      {required FirebaseFirestore firestore,
      required this.functions,
      required FirebaseStorage storage})
      : _firestore = firestore,
        _storage = storage;
  @override
  Stream<ChatRoomModel> getChatRoom({required String roomId}) {
    return _firestore.collection('chats').doc(roomId).snapshots().map((value) {
      return ChatRoomModel.fromMap(value.data()!);
    }).handleError((error) => print(error.toString()));
  }

  @override
  Future<String> createChatRoom(
      {required String userId, required String myUserId}) async {
    try {
      String roomId = functions.chatRoomId(myUserId, userId);
      final chatData = await _firestore.collection('chats').doc(roomId).get();
      if (chatData.exists) {
        return chatData.data()!['roomId'];
      } else {
        ChatRoomModel newRoom = ChatRoomModel(
            islastmsgread: false,
            lastmessage: "",
            roomId: roomId,
            timeSent: Timestamp.now(),
            lastMessageId: "",
            users: [
              myUserId,
              userId
            ],
            usersTyping: [
              ChatUserModel(isTyping: false, userId: userId),
              ChatUserModel(isTyping: false, userId: myUserId)
            ]);
        await _firestore.collection('chats').doc(roomId).set(newRoom.toMap());
        return roomId;
      }
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code);
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  @override
  Future<void> setUserTyping(
      {required String chatId,
      required String myUserId,
      required bool istyping}) async {
    try {
      var chatDoc = await _firestore.collection('chats').doc(chatId).get();
      List<dynamic> users = chatDoc.data()!['usersTyping'];

      final myUserIndex =
          users.indexWhere((user) => user['userId'] == myUserId);

      users[myUserIndex]['isTyping'] = istyping;
      await _firestore.collection('chats').doc(chatId).update({
        'usersTyping': users,
      });
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code);
    } catch (e) {
      print(e.toString());
      throw 'Something went wrong. Please try again.';
    }
  }

  @override
  Future<void> sendTextMessage(
      {required String chatId,
      required String myUserId,
      required String message}) async {
    try {
      String messageId = const Uuid().v1();
      MessageModel newMessage = MessageModel(
          isSeen: false,
          message: message,
          messageId: messageId,
          senderId: myUserId,
          timeSent: Timestamp.now(),
          type: MessagesType.text);

      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .set(newMessage.toMap());

      _updateLastMessage(
          roomId: chatId, message: message, lastMessageId: messageId);
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code);
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  @override
  Stream<List<MessageModel>> listenToMessages({required String chatRoomId}) {
    try {
      return _firestore
          .collection("chats")
          .doc(chatRoomId)
          .collection("messages")
          .orderBy('timeSent', descending: true)
          .snapshots()
          .asyncMap((event) async {
        List<MessageModel> messages = [];
        for (var message in event.docs) {
          MessageModel messageModel = MessageModel.fromMap(message.data());
          messages.add(messageModel);
        }
        return messages;
      });
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  @override
  Stream<List<ChatRoomModel>> listenToChats({required String myUserId}) {
    try {
      return _firestore
          .collection("chats")
          .where('users', arrayContainsAny: [myUserId])
          .snapshots()
          .asyncMap((event) {
            // print(event.docs.first.data());
            List<ChatRoomModel> chats = [];
            for (var chat in event.docs) {
              print(chat.data()['timeSent']);
              ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(chat.data());
              chats.add(chatRoomModel);
            }
            return chats;
          });
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      print(e.toString());
      throw 'Something went wrong. Please try again.';
    }
  }

  @override
  Future<void> setMessageRead(
      {required String chatId, required String userId}) async {
    try {
      final chatdOC = await _firestore.collection('chats').doc(chatId).get();
      final messagesDoc = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .where('senderId', isEqualTo: userId)
          .get();
      for (var item in messagesDoc.docs) {
        _firestore
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .doc(item.data()['messageId'])
            .update({'isSeen': true});
      }
      final lastMessageDoc = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .where('messageId', isEqualTo: chatdOC.data()!['lastMessageId'])
          .get();
      if (lastMessageDoc.docs.first.data()['senderId'] == userId) {
        await _firestore
            .collection('chats')
            .doc(chatId)
            .update({'islastmsgread': true});
      }
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  @override
  Future<void> sendFileMessage(
      {required MessagesType type,
      required String roomId,
      required File file,
      required String myUserId}) async {
    try {
      String messageId = const Uuid().v1();
      String text =
          await _uploadFileToStorage(path: "$roomId/chat", file: file);
      MessageModel fileMessage = MessageModel(
          isSeen: false,
          message: text,
          type: MessagesType.image,
          messageId: messageId,
          senderId: myUserId,
          timeSent: Timestamp.now());

      _updateLastMessage(
          roomId: roomId, message: type.name, lastMessageId: messageId);
      return _firestore
          .collection("chats")
          .doc(roomId)
          .collection("messages")
          .doc(messageId)
          .set(fileMessage.toMap());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      print(e.toString());
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<String> _uploadFileToStorage(
      {required String path, required File file}) async {
    try {
      final ref = _storage.ref().child('chats').child(path);
      UploadTask uploadTask = ref.putFile(File(file.path));
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }

  _updateLastMessage(
      {required String roomId,
      required String message,
      required String lastMessageId}) async {
    try {
      return _firestore.collection("chats").doc(roomId).update({
        'lastmessage': message,
        'timeSent': Timestamp.now(),
        'lastMessageId': lastMessageId,
      });
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }
}
