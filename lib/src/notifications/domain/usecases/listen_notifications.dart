import 'package:social_x/core/common/usecase/usecase.dart';
import 'package:social_x/src/notifications/domain/entity/notification.dart';
import 'package:social_x/src/notifications/domain/repository/notifications_repository.dart';

class LitenTONotifications
    implements StreamUseCaseWithParams<List<NotificationEntity>, String> {
  final NotificationRepository repository;

  LitenTONotifications({required this.repository});
  @override
  Stream<List<NotificationEntity>> call(String params) {
    return repository.listenToNotifications(myUserId: params);
  }
}
