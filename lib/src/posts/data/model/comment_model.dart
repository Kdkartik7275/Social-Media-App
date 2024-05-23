import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_x/src/posts/domain/entity/comment.dart';

class CommentModel extends CommentEntity {
  CommentModel(
      {super.comment,
      super.timestamp,
      super.commentId,
      super.userDp,
      super.userId,
      super.username});

  CommentModel copyWith({
    String? username,
    String? comment,
    Timestamp? timestamp,
    String? userDp,
    String? commentId,
    String? userId,
  }) {
    return CommentModel(
      username: username ?? this.username,
      comment: comment ?? this.comment,
      timestamp: timestamp ?? this.timestamp,
      commentId: commentId ?? this.commentId,
      userDp: userDp ?? this.userDp,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'comment': comment,
      'timestamp': timestamp,
      'commentId': commentId,
      'userDp': userDp,
      'userId': userId,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      username: map['username'] ?? "",
      comment: map['comment'] ?? "",
      timestamp: map['timestamp'] ?? Timestamp.now(),
      userDp: map['userDp'] ?? "",
      userId: map['userId'] ?? "",
      commentId: map['commentId'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
