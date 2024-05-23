// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class ChatUser extends Equatable {
  String? userId;
  bool? isTyping;
  ChatUser({
    this.userId,
    this.isTyping,
  });

  @override
  List<Object?> get props => [userId, isTyping];

  ChatUser copyWith({
    String? userId,
    bool? isTyping,
  }) {
    return ChatUser(
      userId: userId ?? this.userId,
      isTyping: isTyping ?? this.isTyping,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'isTyping': isTyping,
    };
  }

  factory ChatUser.fromMap(Map<String, dynamic> map) {
    return ChatUser(
      userId: map['userId'] != null ? map['userId'] as String : null,
      isTyping: map['isTyping'] != null ? map['isTyping'] as bool : null,
    );
  }
}
