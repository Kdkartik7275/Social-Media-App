// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_x/src/posts/domain/entity/post.dart';

class PostModel extends PostEntity {
  PostModel(
      {super.comments,
      super.description,
      super.likes,
      super.mediaUrl,
      super.ownerId,
      super.postId,
      super.shareCount,
      super.timestamp,
      super.commentsCount});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'postId': postId,
      'ownerId': ownerId,
      'description': description,
      'likes': likes,
      'comments': comments,
      'shareCount': shareCount,
      'mediaUrl': mediaUrl,
      'timestamp': timestamp,
      'commentsCount': commentsCount
    };
  }

  PostModel copyWith({
    String? postId,
    String? ownerId,
    String? description,
    List<String>? likes,
    List<String>? comments,
    int? shareCount,
    int? commentsCount,
    String? mediaUrl,
    Timestamp? timestamp,
  }) {
    return PostModel(
        postId: postId ?? this.postId,
        ownerId: ownerId ?? this.ownerId,
        description: description ?? this.description,
        likes: likes ?? this.likes,
        comments: comments ?? this.comments,
        shareCount: shareCount ?? this.shareCount,
        mediaUrl: mediaUrl ?? this.mediaUrl,
        timestamp: timestamp ?? this.timestamp,
        commentsCount: commentsCount ?? this.commentsCount);
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
        postId: map['postId'] ?? "",
        ownerId: map['ownerId'] ?? "",
        description: map['description'] ?? "",
        likes: map['likes'] ?? [],
        comments: map['comments'] ?? [],
        shareCount: map['shareCount'] ?? 0,
        commentsCount: map['commentsCount'] ?? 0,
        mediaUrl: map['mediaUrl'] ?? "",
        timestamp: map['timestamp'] ?? Timestamp.now());
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
