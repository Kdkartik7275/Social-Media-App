import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_x/core/utils/enums/message_type.dart';
import 'package:social_x/src/chats/domain/entity/message.dart';

class MessageModel extends MessageEntity {
  MessageModel(
      {super.isSeen,
      super.message,
      super.messageId,
      super.senderId,
      super.timeSent,
      super.type});

  MessageModel copyWith({
    String? senderId,
    String? message,
    MessagesType? type,
    Timestamp? timeSent,
    String? messageId,
    bool? isSeen,
  }) {
    return MessageModel(
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      type: type ?? this.type,
      timeSent: timeSent ?? this.timeSent,
      messageId: messageId ?? this.messageId,
      isSeen: isSeen ?? this.isSeen,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'message': message,
      'type': type!.type,
      'timeSent': timeSent,
      'messageId': messageId,
      'isSeen': isSeen,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map['senderId'] != null ? map['senderId'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      type: map['type'] != null ? (map['type'] as String).toEnum() : null,
      timeSent: map['timeSent'] ?? Timestamp.now(),
      messageId: map['messageId'] != null ? map['messageId'] as String : null,
      isSeen: map['isSeen'] != null ? map['isSeen'] as bool : null,
    );
  }
}
