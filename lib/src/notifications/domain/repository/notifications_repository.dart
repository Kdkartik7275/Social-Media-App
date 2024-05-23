import 'package:social_x/core/utils/constants/typedefs.dart';
import 'package:social_x/src/notifications/domain/entity/notification.dart';

abstract interface class NotificationRepository {
  ResultVoid addNotification({
    required String type,
    required String userId,
    required String postId,
    required String myUserId,
    required String mediaUrl,
    required String commentData,
  });

  Stream<List<NotificationEntity>> listenToNotifications(
      {required String myUserId});

  ResultVoid removeNotification(
      {required String userId, required String key, required String value});
  ResultVoid updateNotificationSeen({required String myUserId});
}
