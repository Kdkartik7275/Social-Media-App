import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_x/src/notifications/domain/entity/notification.dart';

class NotificationModel extends NotificationEntity {
  NotificationModel(
      {super.commentData,
      super.mediaUrl,
      super.postId,
      super.notificationId,
      super.timestamp,
      super.type,
      super.isSeen,
      super.userId});

  @override
  NotificationModel copyWith({
    String? type,
    String? userId,
    String? notificationId,
    String? postId,
    String? mediaUrl,
    bool? isSeen,
    String? commentData,
    Timestamp? timestamp,
  }) {
    return NotificationModel(
      type: type ?? this.type,
      userId: userId ?? this.userId,
      notificationId: notificationId ?? this.notificationId,
      postId: postId ?? this.postId,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      isSeen: isSeen ?? this.isSeen,
      commentData: commentData ?? this.commentData,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'userId': userId,
      'postId': postId,
      'mediaUrl': mediaUrl,
      'commentData': commentData,
      'timestamp': timestamp,
      'notificationId': notificationId,
      'isSeen': isSeen,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
        type: map['type'] != null ? map['type'] as String : null,
        userId: map['userId'] != null ? map['userId'] as String : null,
        postId: map['postId'] != null ? map['postId'] as String : null,
        mediaUrl: map['mediaUrl'] != null ? map['mediaUrl'] as String : null,
        commentData:
            map['commentData'] != null ? map['commentData'] as String : null,
        timestamp: map['timestamp'] ?? Timestamp.now(),
        isSeen: map['isSeen'] ?? false,
        notificationId: map['notificationId'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
