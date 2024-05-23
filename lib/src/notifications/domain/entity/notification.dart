// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  String? type;
  String? notificationId;
  String? userId;
  String? postId;
  String? mediaUrl;
  String? commentData;
  Timestamp? timestamp;
  bool? isSeen;

  NotificationEntity(
      {this.commentData,
      this.mediaUrl,
      this.postId,
      this.isSeen,
      this.timestamp,
      this.notificationId,
      this.type,
      this.userId});

  @override
  List<Object?> get props =>
      [type, userId, postId, mediaUrl, commentData, timestamp];

  NotificationEntity copyWith({
    String? type,
    String? userId,
    String? notificationId,
    String? postId,
    String? mediaUrl,
    String? commentData,
    bool? isSeen,
    Timestamp? timestamp,
  }) {
    return NotificationEntity(
        type: type ?? this.type,
        userId: userId ?? this.userId,
        postId: postId ?? this.postId,
        notificationId: notificationId ?? this.notificationId,
        mediaUrl: mediaUrl ?? this.mediaUrl,
        commentData: commentData ?? this.commentData,
        timestamp: timestamp ?? this.timestamp,
        isSeen: isSeen ?? this.isSeen);
  }
}
