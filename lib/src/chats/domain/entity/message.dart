// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:social_x/core/utils/enums/message_type.dart';

class MessageEntity extends Equatable {
  String? senderId;
  String? message;
  MessagesType? type;
  Timestamp? timeSent;
  String? messageId;
  bool? isSeen;
  MessageEntity({
    this.senderId,
    this.message,
    this.type,
    this.timeSent,
    this.messageId,
    this.isSeen,
  });
  @override
  List<Object?> get props =>
      [senderId, message, type, timeSent, messageId, isSeen];

  MessageEntity copyWith({
    String? senderId,
    String? message,
    MessagesType? type,
    Timestamp? timeSent,
    String? messageId,
    bool? isSeen,
  }) {
    return MessageEntity(
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      type: type ?? this.type,
      timeSent: timeSent ?? this.timeSent,
      messageId: messageId ?? this.messageId,
      isSeen: isSeen ?? this.isSeen,
    );
  }
}
