// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  String? postId;
  String? ownerId;

  String? description;
  List? likes;
  List? comments;
  int? shareCount;
  int? commentsCount;
  String? mediaUrl;
  Timestamp? timestamp;
  PostEntity({
    this.postId,
    this.ownerId,
    this.description,
    this.likes,
    this.comments,
    this.commentsCount,
    this.shareCount,
    this.mediaUrl,
    this.timestamp,
  });

  @override
  List<Object?> get props => [
        postId,
        ownerId,
        description,
        shareCount,
        likes,
        comments,
        mediaUrl,
        timestamp,
        commentsCount
      ];

  PostEntity copyWith(
      {String? postId,
      String? ownerId,
      String? description,
      List<String>? likes,
      List<String>? comments,
      int? shareCount,
      String? mediaUrl,
      Timestamp? timestamp,
      int? commentsCount}) {
    return PostEntity(
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
}
