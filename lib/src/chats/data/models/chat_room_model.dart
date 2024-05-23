import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_x/src/chats/data/models/chat_user_model.dart';
import 'package:social_x/src/chats/domain/entity/chat_room.dart';
import 'package:social_x/src/chats/domain/entity/chat_user.dart';

class ChatRoomModel extends ChatRoom {
  ChatRoomModel(
      {super.islastmsgread,
      super.lastmessage,
      super.usersTyping,
      super.roomId,
      super.lastMessageId,
      super.timeSent,
      super.users});

  ChatRoomModel copyWith({
    String? roomId,
    String? lastmessage,
    bool? islastmsgread,
    String? lastMessageId,
    Timestamp? timeSent,
    List<ChatUser>? usersTyping,
    List? users,
  }) {
    return ChatRoomModel(
        roomId: roomId ?? this.roomId,
        lastmessage: lastmessage ?? this.lastmessage,
        islastmsgread: islastmsgread ?? this.islastmsgread,
        timeSent: timeSent ?? this.timeSent,
        lastMessageId: lastMessageId ?? this.lastMessageId,
        users: users ?? this.users,
        usersTyping: usersTyping ?? this.usersTyping);
  }

  static ChatRoomModel empty() => ChatRoomModel(
      islastmsgread: false,
      lastmessage: "",
      roomId: "",
      timeSent: Timestamp.now(),
      lastMessageId: "",
      users: []);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'roomId': roomId,
      'lastmessage': lastmessage,
      'islastmsgread': islastmsgread,
      'timeSent': timeSent,
      'lastMessageId': lastMessageId,
      'users': users,
      'usersTyping': usersTyping!.map((x) => x.toMap()).toList(),
    };
  }

  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
      roomId: map['roomId'] != null ? map['roomId'] as String : null,
      lastmessage:
          map['lastmessage'] != null ? map['lastmessage'] as String : null,
      islastmsgread:
          map['islastmsgread'] != null ? map['islastmsgread'] as bool : null,
      lastMessageId: map['lastMessageId'] ?? '',
      timeSent: map['timeSent'] != null ? map['timeSent'] : null,
      users: map['users'] ?? [],
      usersTyping: map['usersTyping'] != null
          ? List.from(map['usersTyping'])
              .map((e) => ChatUserModel.fromMap(e))
              .toList()
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatRoomModel.fromJson(String source) =>
      ChatRoomModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
