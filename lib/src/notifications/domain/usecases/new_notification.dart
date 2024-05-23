import 'package:social_x/core/common/usecase/usecase.dart';
import 'package:social_x/core/utils/constants/typedefs.dart';
import 'package:social_x/src/notifications/domain/repository/notifications_repository.dart';

class NewNotification
    implements UseCaseWithParams<void, NewNotificationParams> {
  final NotificationRepository repository;

  NewNotification({required this.repository});
  @override
  ResultFuture<void> call(NewNotificationParams params) async {
    return await repository.addNotification(
        type: params.type,
        userId: params.userId,
        postId: params.postId,
        myUserId: params.myUserId,
        mediaUrl: params.mediaUrl,
        commentData: params.commentData);
  }
}

class NewNotificationParams {
  final String type;
  final String userId;
  final String postId;
  final String myUserId;
  final String mediaUrl;
  final String commentData;

  NewNotificationParams(
      {required this.type,
      required this.userId,
      required this.postId,
      required this.myUserId,
      required this.mediaUrl,
      required this.commentData});
}
