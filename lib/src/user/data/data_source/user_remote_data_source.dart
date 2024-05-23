import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:social_x/core/common/errors/exceptions/firebase_auth_exceptions.dart';
import 'package:social_x/core/common/errors/exceptions/firebase_exceptions.dart';
import 'package:social_x/core/common/errors/exceptions/format_exceptions.dart';
import 'package:social_x/core/common/errors/exceptions/platform_exceptions.dart';
import 'package:social_x/core/utils/file_utils.dart';
import 'package:social_x/core/utils/firebase/push_notification.dart';
import 'package:social_x/src/notifications/domain/usecases/new_notification.dart';
import 'package:social_x/src/notifications/domain/usecases/remove_notification.dart';
import 'package:social_x/src/user/data/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

abstract interface class UserRemoteDataSource {
  Future<void> saveUserData(
      {required String username,
      required UserCredential user,
      required String email,
      required String country});

  Future<void> updateSingleField({required Map<String, dynamic> json});

  Future<void> storeUserProfile({required String path, required File image});

  Future<User?> getCurrentUser();
  Future<UserModel?> getCurrentUserData();
  Future<void> deleteUserRecord({required String userId});
  Future<void> followUser({required String userId, required String myId});

  Stream<UserModel> getUserData({required String userId});
  Future<UserModel> blockUser(
      {required String userId, required String myUserId});
  Future<void> setUserToken({required String token, required String userId});
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseStorage _storage;
  final NewNotification addNotification;
  final Removeotification removeotification;
  final NotificationServices notificationServices;

  UserRemoteDataSourceImpl(
      {required FirebaseFirestore firestore,
      required FirebaseAuth auth,
      required this.notificationServices,
      required this.addNotification,
      required this.removeotification,
      required FirebaseStorage storage})
      : _firestore = firestore,
        _storage = storage,
        _auth = auth;

  @override
  Future<void> deleteUserRecord({required String userId}) async {
    try {
      return await _firestore.collection('Users').doc(userId).delete();
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
  Future<User?> getCurrentUser() async {
    try {
      return _auth.currentUser;
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
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
  Future<UserModel?> getCurrentUserData() async {
    try {
      final documentSnapshot = await _firestore
          .collection('Users')
          .doc(_auth.currentUser?.uid)
          .get();

      if (documentSnapshot.exists) {
        return UserModel.fromMap(documentSnapshot.data()!);
      } else {
        return UserModel.empty();
      }
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code);
    } catch (e) {
      print(e.toString());
      throw 'Something went wrong. Please try again.';
    }
  }

  @override
  Future<void> saveUserData(
      {required String username,
      required UserCredential user,
      required String email,
      required String country}) async {
    try {
      UserModel newUser = UserModel(
          bio: "",
          country: country,
          email: email,
          id: user.user!.uid,
          isOnline: true,
          lastSeen: Timestamp.now(),
          followers: const [],
          followings: const [],
          blockedUsers: const [],
          photoUrl: "",
          signedUpAt: Timestamp.now(),
          username: username);
      await _firestore
          .collection('Users')
          .doc(user.user!.uid)
          .set(newUser.toMap());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
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
  Future<void> storeUserProfile(
      {required String path, required File image}) async {
    try {
      Uuid uuid = const Uuid();

      String ext = FileUtils.getFileExtension(image);
      Reference storageReference =
          _storage.ref(path).child("${uuid.v4()}.$ext");
      UploadTask uploadTask = storageReference.putFile(image);
      await uploadTask.whenComplete(() => null);
      String imageUrl = await storageReference.getDownloadURL();
      await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .update({'photoUrl': imageUrl});
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
  Future<void> updateSingleField({required Map<String, dynamic> json}) async {
    try {
      return await _firestore
          .collection('Users')
          .doc(_auth.currentUser?.uid)
          .update(json);
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
  Stream<UserModel> getUserData({required String userId}) {
    return _firestore
        .collection('Users')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return UserModel.fromMap(snapshot.data()!);
      } else {
        return UserModel.empty();
      }
    }).handleError((error) {
      throw error.toString();
    });
  }

  @override
  Future<void> followUser(
      {required String userId, required String myId}) async {
    try {
      var userData = await _firestore.collection('Users').doc(userId).get();
      var myUserData = await _firestore.collection('Users').doc(myId).get();

      UserModel user = UserModel.fromMap(userData.data()!);

      if (user.followers!.contains(myId)) {
        await _firestore.collection('Users').doc(userId).update({
          'followers': FieldValue.arrayRemove([myId])
        });
        await _firestore.collection('Users').doc(myId).update({
          'followings': FieldValue.arrayRemove([userId])
        });
        removeotification.call(RemoveotificationParams(userId, 'userId', myId));
      } else {
        await _firestore.collection('Users').doc(userId).update({
          'followers': FieldValue.arrayUnion([myId])
        });
        await _firestore.collection('Users').doc(myId).update({
          'followings': FieldValue.arrayUnion([userId])
        });
        var userToken =
            await _firestore.collection('UserToken').doc(userId).get();
        if (userToken.exists) {
          notificationServices.sendPushNotification(
              sendTo: userToken.data()!['token'],
              title: 'New Follower',
              payload: {
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'status': 'done',
                'type': 'profile',
                'uid': userId
              },
              body: '${myUserData.data()!['username']} started Following you');
        }

        addNotification.call(NewNotificationParams(
            type: 'follow',
            userId: userId,
            postId: "",
            myUserId: myId,
            mediaUrl: "",
            commentData: ""));
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

  @override
  Future<UserModel> blockUser(
      {required String userId, required String myUserId}) async {
    try {
      final myUser = await _firestore.collection('Users').doc(myUserId).get();

      List blockedUsers = myUser.data()!['blockedUsers'];
      if (blockedUsers.contains(userId)) {
        await _firestore.collection('Users').doc(myUserId).update({
          'blockedUsers': FieldValue.arrayRemove([userId])
        });
      } else {
        await _firestore.collection('Users').doc(myUserId).update({
          'blockedUsers': FieldValue.arrayUnion([userId])
        });
        if (myUser.data()!['followings'].contains(userId)) {
          await _firestore.collection('Users').doc(myUserId).update({
            'followings': FieldValue.arrayRemove([userId])
          });
          await _firestore.collection('Users').doc(userId).update({
            'followers': FieldValue.arrayRemove([myUserId])
          });
        }
        if (myUser.data()!['followers'].contains(userId)) {
          await _firestore.collection('Users').doc(myUserId).update({
            'followers': FieldValue.arrayRemove([userId])
          });
          await _firestore.collection('Users').doc(userId).update({
            'followings': FieldValue.arrayRemove([myUserId])
          });
        }
      }
      final updatedUser =
          await _firestore.collection('Users').doc(myUserId).get();
      return UserModel.fromMap(updatedUser.data()!);
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
  Future<void> setUserToken(
      {required String token, required String userId}) async {
    try {
      await FirebaseFirestore.instance
          .collection('UserToken')
          .doc(userId)
          .set({'token': token, 'userId': userId});
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
