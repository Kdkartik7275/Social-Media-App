import 'package:fpdart/fpdart.dart';
import 'package:social_x/core/common/errors/failure.dart';
import 'package:social_x/core/common/network/connection_checker.dart';
import 'package:social_x/core/utils/constants/typedefs.dart';
import 'package:social_x/src/notifications/data/data_source/notification_data_source.dart';
import 'package:social_x/src/notifications/domain/entity/notification.dart';
import 'package:social_x/src/notifications/domain/repository/notifications_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final ConnectionChecker connectionChecker;
  final NotificationDataSource dataSource;

  NotificationRepositoryImpl(
      {required this.connectionChecker, required this.dataSource});
  @override
  ResultVoid addNotification(
      {required String type,
      required String userId,
      required String postId,
      required String myUserId,
      required String mediaUrl,
      required String commentData}) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(FirebaseFailure(message: "No Internet Connection"));
      }
      await dataSource.addNotification(
          type: type,
          userId: userId,
          postId: postId,
          mediaUrl: mediaUrl,
          myUserId: myUserId,
          commentData: commentData);
      return right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  Stream<List<NotificationEntity>> listenToNotifications(
      {required String myUserId}) {
    return dataSource.listenToNotifications(myUserId: myUserId);
  }

  @override
  ResultVoid removeNotification(
      {required String userId,
      required String key,
      required String value}) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(FirebaseFailure(message: "No Internet Connection"));
      }
      await dataSource.removeNotification(
          key: key, userId: userId, value: value);
      return right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid updateNotificationSeen({required String myUserId}) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(FirebaseFailure(message: "No Internet Connection"));
      }
      await dataSource.updateNotificationSeen(myUserId: myUserId);
      return right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }
}
