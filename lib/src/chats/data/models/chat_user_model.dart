import 'dart:convert';

import 'package:social_x/src/chats/domain/entity/chat_user.dart';

class ChatUserModel extends ChatUser {
  ChatUserModel({super.isTyping, super.userId});

  @override
  ChatUserModel copyWith({
    String? userId,
    bool? isTyping,
  }) {
    return ChatUserModel(
      userId: userId ?? this.userId,
      isTyping: isTyping ?? this.isTyping,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'isTyping': isTyping,
    };
  }

  factory ChatUserModel.fromMap(Map<String, dynamic> map) {
    return ChatUserModel(
      userId: map['userId'] != null ? map['userId'] as String : null,
      isTyping: map['isTyping'] != null ? map['isTyping'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatUserModel.fromJson(String source) =>
      ChatUserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
