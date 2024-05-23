import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:social_x/core/common/errors/exceptions/firebase_exceptions.dart';
import 'package:social_x/core/common/errors/exceptions/format_exceptions.dart';
import 'package:social_x/core/common/errors/exceptions/platform_exceptions.dart';
import 'package:social_x/src/notifications/data/model/notification_model.dart';
import 'package:uuid/uuid.dart';

abstract interface class NotificationDataSource {
  Future<void> addNotification({
    required String type,
    required String userId,
    required String postId,
    required String mediaUrl,
    required String myUserId,
    required String commentData,
  });

  Stream<List<NotificationModel>> listenToNotifications(
      {required String myUserId});

  Future<void> removeNotification(
      {required String userId, required String key, required String value});
  Future<void> updateNotificationSeen({required String myUserId});
}

class NotificationDataSourceImpl implements NotificationDataSource {
  final FirebaseFirestore _firestore;

  NotificationDataSourceImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;
  @override
  Future<void> addNotification(
      {required String type,
      required String userId,
      required String myUserId,
      required String postId,
      required String mediaUrl,
      required String commentData}) async {
    try {
      String notificationId = const Uuid().v1();

      NotificationModel newNotification = NotificationModel(
          notificationId: notificationId,
          type: type,
          userId: myUserId,
          commentData: commentData,
          isSeen: false,
          mediaUrl: mediaUrl,
          postId: postId,
          timestamp: Timestamp.now());
      await _firestore
          .collection('Users')
          .doc(userId)
          .collection('notifications')
          .doc(notificationId)
          .set(newNotification.toMap());
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
  Stream<List<NotificationModel>> listenToNotifications(
      {required String myUserId}) {
    try {
      return _firestore
          .collection("Users")
          .doc(myUserId)
          .collection("notifications")
          .orderBy('timestamp', descending: true)
          .snapshots()
          .asyncMap((event) async {
        List<NotificationModel> notifications = [];
        for (var notification in event.docs) {
          NotificationModel notificationModel =
              NotificationModel.fromMap(notification.data());
          notifications.add(notificationModel);
        }
        return notifications;
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

  @override
  Future<void> removeNotification(
      {required String userId,
      required String key,
      required String value}) async {
    try {
      await _firestore
          .collection('Users')
          .doc(userId)
          .collection('notifications')
          .where(key, isEqualTo: value)
          .get()
          .then((value) {
        if (value.docs.first.exists) {
          value.docs.first.reference.delete();
        }
      });
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
  Future<void> updateNotificationSeen({required String myUserId}) async {
    try {
      final notificationsDoc = await _firestore
          .collection('Users')
          .doc(myUserId)
          .collection('notifications')
          .where('isSeen', isEqualTo: false)
          .get();
      for (var item in notificationsDoc.docs) {
        _firestore
            .collection('Users')
            .doc(myUserId)
            .collection('notifications')
            .doc(item.data()['notificationId'])
            .update({'isSeen': true});
      }
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
}
