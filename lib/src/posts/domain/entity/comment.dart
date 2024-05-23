// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CommentEntity extends Equatable {
  String? username;
  String? comment;
  Timestamp? timestamp;
  String? commentId;
  String? userDp;
  String? userId;
  CommentEntity({
    this.username,
    this.comment,
    this.timestamp,
    this.userDp,
    this.commentId,
    this.userId,
  });

  @override
  List<Object?> get props => [userDp, username, userId, comment, timestamp];

  CommentEntity copyWith({
    String? username,
    String? comment,
    Timestamp? timestamp,
    String? userDp,
    String? commentId,
    String? userId,
  }) {
    return CommentEntity(
        username: username ?? this.username,
        comment: comment ?? this.comment,
        timestamp: timestamp ?? this.timestamp,
        userDp: userDp ?? this.userDp,
        userId: userId ?? this.userId,
        commentId: commentId ?? this.commentId);
  }
}
