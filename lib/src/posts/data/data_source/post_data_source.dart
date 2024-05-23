import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:social_x/core/common/errors/exceptions/firebase_exceptions.dart';
import 'package:social_x/core/common/errors/exceptions/format_exceptions.dart';
import 'package:social_x/core/common/errors/exceptions/platform_exceptions.dart';
import 'package:social_x/core/utils/firebase/push_notification.dart';
import 'package:social_x/core/utils/firebase/storage.dart';
import 'package:social_x/src/notifications/domain/usecases/new_notification.dart';
import 'package:social_x/src/notifications/domain/usecases/remove_notification.dart';
import 'package:social_x/src/posts/data/model/comment_model.dart';
import 'package:social_x/src/posts/data/model/post_model.dart';
import 'package:social_x/src/posts/domain/entity/post.dart';
import 'package:social_x/src/user/data/models/usermodel.dart';
import 'package:uuid/uuid.dart';

abstract interface class PostRemoteDataSource {
  Future<PostModel> uploadPost(
      {required String ownerId,
      required String description,
      required File media});

  Future<List<PostEntity>> fetchPosts({required int limit});
  Future<void> likePost({required String postId, required String myId});

  Future<void> addComment(
      {required String userId,
      required String comment,
      required String postId});
  Future<List<CommentModel>> fetchComments({required String postId});
  Stream<List<PostEntity>> profilePosts({required String userId});
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final FirebaseFirestore _firestore;
  final NewNotification addNotification;
  final NotificationServices notificationServices;
  final Removeotification removeotification;

  PostRemoteDataSourceImpl(
      {required FirebaseFirestore firestore,
      required this.addNotification,
      required this.notificationServices,
      required this.removeotification})
      : _firestore = firestore;
  @override
  Future<PostModel> uploadPost(
      {required String ownerId,
      required String description,
      required File media}) async {
    try {
      String postId = const Uuid().v1();

      String mediaURL = await uploadMediaToStorage(
          path: "posts/$ownerId", image: media, postId: postId);
      PostModel newPost = PostModel(
        comments: const [],
        description: description,
        likes: const [],
        mediaUrl: mediaURL,
        ownerId: ownerId,
        postId: postId,
        shareCount: 0,
        timestamp: Timestamp.now(),
        commentsCount: 0,
      );
      await _firestore.collection('posts').doc(postId).set(newPost.toMap());
      return newPost;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code);
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  @override
  Future<List<PostEntity>> fetchPosts({required int limit}) async {
    try {
      List<PostModel> posts = [];
      final postsData = await _firestore
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      for (var item in postsData.docs) {
        var data = item.data();
        PostModel post = PostModel(
          comments: data['comments'],
          description: data['description'],
          likes: data['likes'],
          mediaUrl: data['mediaUrl'],
          ownerId: data['ownerId'],
          postId: data['postId'],
          shareCount: data['shareCount'],
          timestamp: data['timestamp'],
          commentsCount: data['commentsCount'],
        );

        posts.add(post);
      }
      return posts;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> likePost({required String postId, required String myId}) async {
    try {
      final postData = await _firestore.collection('posts').doc(postId).get();
      final myData = await _firestore.collection('Users').doc(myId).get();
      PostModel post = PostModel.fromMap(postData.data()!);

      if (post.likes!.contains(myId)) {
        await _firestore.collection("posts").doc(postId).update({
          'likes': FieldValue.arrayRemove([myId])
        });
        if (post.ownerId != myId) {
          await removeotification
              .call(RemoveotificationParams(post.ownerId!, 'postId', postId));
        }
      } else {
        await _firestore.collection("posts").doc(postId).update({
          'likes': FieldValue.arrayUnion([myId])
        });
        var userToken = await _firestore
            .collection('UserToken')
            .where('userId', isEqualTo: post.ownerId)
            .get();
        if (userToken.docs.isNotEmpty) {
          notificationServices.sendPushNotification(
              sendTo: userToken.docs.first.data()['token'],
              title: 'Post Liked',
              payload: {
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'status': 'done',
                'type': 'postLike'
              },
              body: '${myData.data()!['username']} liked your post');
        }

        if (post.ownerId != myId) {
          await addNotification.call(NewNotificationParams(
              type: 'like',
              userId: post.ownerId!,
              postId: postId,
              myUserId: myId,
              mediaUrl: post.mediaUrl!,
              commentData: ""));
        }
      }
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> addComment(
      {required String userId,
      required String comment,
      required String postId}) async {
    try {
      String commentID = const Uuid().v1();

      CommentModel newComment = CommentModel(
          comment: comment,
          commentId: commentID,
          timestamp: Timestamp.now(),
          userDp: "",
          userId: userId,
          username: "");
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentID)
          .set(newComment.toMap());
      final doc = await _firestore.collection('posts').doc(postId).get();
      await _firestore
          .collection('posts')
          .doc(postId)
          .update({'commentsCount': doc.data()!['commentsCount'] + 1});
      await addNotification.call(NewNotificationParams(
          type: 'comment',
          userId: doc.data()!['ownerId'],
          postId: postId,
          myUserId: userId,
          mediaUrl: doc.data()!['mediaUrl'],
          commentData: comment));
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<List<CommentModel>> fetchComments({required String postId}) async {
    try {
      List<CommentModel> comments = [];
      final commentsData = await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .get();
      for (var item in commentsData.docs) {
        final user = await _firestore
            .collection('Users')
            .doc(item.data()['userId'])
            .get();

        UserModel commentUser = UserModel.fromMap(user.data()!);
        final data = item.data();
        CommentModel comment = CommentModel(
            comment: data['comment'],
            commentId: data['commentId'],
            timestamp: data['timestamp'],
            userDp: commentUser.photoUrl,
            userId: data['userId'],
            username: commentUser.username);
        comments.add(comment);
      }
      // print(comments.first.comment);
      return comments;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  @override
  Stream<List<PostEntity>> profilePosts({required String userId}) {
    try {
      return _firestore
          .collection("posts")
          .where('ownerId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .asyncMap((event) {
        List<PostModel> posts = [];
        for (var postdoc in event.docs) {
          PostModel post = PostModel.fromMap(postdoc.data());
          posts.add(post);
        }
        return posts;
      });
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }
}
