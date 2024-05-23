import 'package:social_x/core/common/usecase/usecase.dart';
import 'package:social_x/core/utils/constants/typedefs.dart';
import 'package:social_x/src/notifications/domain/repository/notifications_repository.dart';

class UpdateNotificationSeenStatus implements UseCaseWithParams<void, String> {
  final NotificationRepository repository;

  UpdateNotificationSeenStatus({required this.repository});
  @override
  ResultFuture<void> call(String params) async {
    return await repository.updateNotificationSeen(myUserId: params);
  }
}
