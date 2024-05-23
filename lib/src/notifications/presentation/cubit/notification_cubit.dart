import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_x/src/notifications/domain/entity/notification.dart';
import 'package:social_x/src/notifications/domain/usecases/listen_notifications.dart';
import 'package:social_x/src/notifications/domain/usecases/update_seen.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final LitenTONotifications notifications;
  final UpdateNotificationSeenStatus updateNotificationSeenStatus;
  NotificationCubit(
      {required this.notifications, required this.updateNotificationSeenStatus})
      : super(NotificationInitial());

  Stream<List<NotificationEntity>> listenToNotifcations(
      {required String myUserId}) {
    return notifications.call(myUserId);
  }

  void updateSeenStatus({required String myUserId}) async {
    final update = await updateNotificationSeenStatus.call(myUserId);
    update.fold((l) => print(l.message), (r) => null);
  }
}
