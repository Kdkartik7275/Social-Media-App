// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:social_x/src/chats/domain/entity/chat_user.dart';

class ChatRoom extends Equatable {
  String? roomId;
  String? lastmessage;
  String? lastMessageId;
  bool? islastmsgread;
  Timestamp? timeSent;
  List? users;
  List<ChatUser>? usersTyping;
  ChatRoom({
    this.roomId,
    this.lastmessage,
    this.islastmsgread,
    this.lastMessageId,
    this.timeSent,
    this.users,
    this.usersTyping,
  });
  @override
  List<Object?> get props =>
      [roomId, lastmessage, islastmsgread, timeSent, users];

  ChatRoom copyWith({
    String? roomId,
    String? lastmessage,
    bool? islastmsgread,
    Timestamp? timeSent,
    List? users,
    List<ChatUser>? usersTyping,
    String? lastMessageId,
  }) {
    return ChatRoom(
        roomId: roomId ?? this.roomId,
        lastmessage: lastmessage ?? this.lastmessage,
        islastmsgread: islastmsgread ?? this.islastmsgread,
        lastMessageId: lastMessageId ?? this.lastMessageId,
        timeSent: timeSent ?? this.timeSent,
        users: users ?? this.users,
        usersTyping: usersTyping ?? this.usersTyping);
  }

  static ChatRoom empty() => ChatRoom(
      islastmsgread: false,
      lastmessage: "",
      roomId: "",
      timeSent: Timestamp.now(),
      lastMessageId: '',
      usersTyping: [],
      users: []);
}
